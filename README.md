# CollaborationTMDB

**목차**

- [프로젝트 소개](#프로젝트-소개)
- [프로젝트에서 고민한 것](#프로젝트에서-고민한-것)
- [프로젝트 협업 방식](#프로젝트-구성원-별-담당)
- [프로젝트 협업 브랜치 전략](#프로젝트-브랜치-전략)

<br />

## 프로젝트 소개
[TMDB API](https://developer.themoviedb.org/reference/intro/getting-started)를 활용한 **나만의 영화/TV 미디어  관심 목록 관리** 앱
- 기간: 2024.10.10 ~ 10.13
- 팀 구성: 김민재, 오종우, 강한결 (3인 협업 프로젝트)
- 최소 버전: iOS 15.0
- 스택: UIKit, RxSwift, RealmSwift, Moya, MVVM
- 주요 기능
  - Trending 영화, TV 데이터 조회
  - 실시간 영화 검색 및 상세 화면 조회
  - 나만의 미디어 관심 목록 저장/삭제

<br />

## 프로젝트에서 고민한 것

### 1️. MVVM Input-Output 패턴 적용으로 협업 코드의 통일성 형성

1️⃣ 프로젝트 전반에 MVVM 아키텍처를 적용하여 객체별 역할을 명확하게 구분지었습니다.
- ViewController에서는 View 요소마다 발생하는 이벤트를 ViewModel에 전달하고, ViewModel에서 받은 데이터 스트림을 View에 구독시켰습니다.
- ViewModel에서는 입력 받은 이벤트에 따라 데이터의 흐름을 다시 View로 돌려줄 수 있는 비즈니스 로직을 관리했습니다.

2️⃣ ViewModel에서는 각각 **Input, Output 라고 하는 Nested Structure를 두어 이벤트의 입력(Input)과 View에서 필요한 데이터 반환값(Output)을 방출하는데 활용**했습니다.
- 협업하는 모든 구성원이 동일한 Input-Output 패턴을 적용하여 에러가 발생한 부분, 코드 병합시에 충돌이 발생한 부분, 다른 구성원이 작업한 코드를 다른 코드에서 활용해야 하는 부분 등의 **협업 과정에서 통일성**을 높일 수 있었습니다.
  ```swift
  final class DetailViewModel {
     ...
  
     struct Input {
        var didLoadInput: PublishSubject<Void> = .init()
        var saveButtonInput: PublishSubject<Void> = .init()
     }
     
     struct Output {
        var didLoadDetailViewOutput: PublishSubject<DetailViewInput> = .init()
        var didLoadCastOutput: PublishSubject<[DetailCastAndDirect]> = .init()
        ...
     }
     
     var input = Input()
     var output = Output()
  
     ...
  }
  ```
- 또한, View에서 발생할 수 있는 이벤트를 ViewModel에서 Action 열거형으로 관리했습니다.
  - View에서는 ViewModel에서 구분된 이벤트를 action 함수에 넘겼습니다.
  - Input-Output 패턴과 더불어 Action 케이스로 각 객체의 역할을 더욱 구분할 수 있었습니다.
  ```swift
  enum Action {
     case viewDidLoad
     case randomMedia(_ type: MediaType, genreIds: [Int])
     ... 
  }

  func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            input.viewDidLoad.accept(())
        case .randomMedia(let type, let genreIds):
            input.randomMedia.accept((type, genreIds))
        ...
        }
  }
  ```
<br />

### 2. TMDB API 네트워크 통신에서 RxSwift의 Single Trait을 활용한 통신 데이터 흐름 관리

1️⃣ 기능 구현을 위해 총 7개의 서로 다른 엔드포인트로 통신했습니다.
- 각각의 API 통신 결과로 받을 수 있는 데이터 모델의 속성과 타입이 달랐습니다.
  - CompletionHandler와 같은 콜백 형태의 탈출 클로저를 활용했을 경우, 통신 성공과 실패에 따라 서로 다른 클로저를 함수의 인자로 전달해줘야 할 수 있고
  - ResultType을 반환하더라도, 통신 결과를 활용하는 ViewModel에서 다시 Observable로 맵핑하여 돌려줘야 했기 때문에 코드 작성에 반복과 번거로움이 있을 것이라 판단했습니다.
    ```swift
     func requestSimilarMovie(
        movieId: Int,
        successHandler: @escaping ([DetailViewInput]) -> Void,
        errorHandler: @escaping () -> Void
     ) {
        let dto = SimilarRequestDTO()
        networkManager.request(
           .similarMovie(dto, movieId: movieId), of: SimilarMovieResponseDTO.self
        ) { result in
           switch result {
           case .success(let success):
              successHandler(success.asDetailViewInput())
           case .failure:
              errorHandler()
           }
        }
     }
    ```

2️⃣ **Single Trait을 활용하여 구독 가능한 하나의 Observable을 방출**했습니다.
- RxSwift 라이브러리에는 데이터 흐름을 ResultType으로 반환하여 구독할 수 있는 `Single` Trait이 있었습니다.
- API 네트워크 통신 결과를 Single 객체로 감싸서 성공, 실패의 경우에 따라 각각 `.success(.success(someViewDataModel))`, `.success(.success(someError))` 형태로 방출했습니다.
  ```swift
  networkManager.request(.trendingMovie(dto), of: TrendingMovieResponseDTO.self) { result in
    switch result {
    case .success(let success):
      single(.success(.success(success.toHomeMedias())))
    case .failure(let failure):
      single(.success(.failure(failure)))
    }
  }
  ```
  - 실패의 경우에도 .success()로 한 번 더 감싸주었습니다.
  - 이는 Single 객체를 구독하는 환경에서 **.failure를 만나는 경우 .onError로 에러를 포착하고 바로 구독이 취소될 수 있는 상황을 방지하고 데이터 흐름에 대한 구독을 유지시키기 위함**이었습니다.
- Single 객체를 구독하는 환경에서는 성공/실패 경우를 구분(switch 구문 또는 if case 구문 활용)하여 View가 필요로 하는 데이터 흐름으로 돌려줄 수 있는 로직을 처리했습니다.
<br />

### 3. 실시간 영화 검색 API 요청 최소화 및 스크롤 기반의 페이지네이션 구현

1️⃣ **동일한 영화명 대한 지속적인 검색을 제한**하고, **검색 API 요청 횟수를 제한하는 로직**을 작성했습니다.
- 유저가 검색하려고 하는 영화명이 입력될 때마다 검색 API 요청을 보내는 것은 앱 자원을 비효율적으로 활용한다고 판단했습니다.
- 동일한 영화명이 Textfield에 유지될 경우, 중복적인 API 요청을 하지 않도록 검색 Observable에 distinctUntilChanged 제약을 걸었습니다.
- 검색할 영화명에 대한 일정한 입력 값이 형성되는 시점을 debounce로 고려하여 요청 횟수를 제한할 수 있었습니다.
  ```swift
  input.searchQuery
    .distinctUntilChanged()
    .debounce(.seconds(1), scheduler: MainScheduler.instance)
    .bind(with: self) { owner, query in
        ...
        owner.fetchSearchData(query: query, page: 1)
    }
    .disposed(by: disposeBag)
  ```

2️⃣ 검색된 영화 목록 전체를 보여주기 위해 **스크롤 이벤트 기반의 페이지네이션**을 구현했습니다.
- 검색 API의 응답값으로 영화 데이터 리스트를 받을 수 있었습니다.
- 검색된 전체 데이터를 한번에 뷰에 그리는 것은 과한 리소스 사용을 초래한다 판단하여, 한 번의 요청에서 받을 수 있는 데이터 양을 제한했습니다.
- 유저가 스크롤을 내릴 때, **보여져야 하는 콘텐츠 영역의 크기(contentOffset)와 스크롤된 화면의 크기(frame.size.height)를 비교하여 특정 포인트가 스크롤뷰의 하단에 도달하는 시점을 계산**하였습니다.
  - 스크롤 뷰의 하단에 도달하면 검색 데이터의 다음 페이지를 요청하는 형식으로 전체 데이터에 대한 페이지네이션을 구현할 수 있었습니다.
    ```swift
    collectionView.rx
      .didScroll
      .withLatestFrom(collectionView.rx.contentOffset)
      .filter { [weak self] offset in
          guard let self else { return false }
          let position = offset.y + self.collectionView.frame.size.height
          return position >= self.collectionView.contentSize.height
      }
      .map { _ in }
      .bind(to: viewModel.input.loadNextPage)
      .disposed(by: disposeBag)
    ```

<br />

## 프로젝트 구성원 별 담당 


|   | 이름(github) | 담당 및 구현 |
| :-: | :---: | :--- |
| <img width="50" height="50" src="https://avatars.githubusercontent.com/u/80156515?v=4" /> | 김민재<br />([bdrsky2010](https://github.com/bdrsky2010)) | - TMDB API 통신에 필요한 [Router](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Network/TMDBRouter.swift), [Request](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Network/NetworkManager.swift), [Model](https://github.com/bdrsky2010/CollaborationTMDB/tree/main/CollaborationTMDB/Model) 구현 <br /> - 미디어 관심 목록 저장/삭제를 위한 [로컬 DB Repository](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Database/DatabaseRepository.swift), [FileManager](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Database/ImageFileManager.swift) 로직 구현 <br /> - Trending 영화, TV 미디어 목록을 제공하는 [HomeView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Home/HomeViewController.swift) 구현 <br /> - 관심 목록으로 저장한 미디어 목록을 조회하는 [LikelistView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Like/LikeViewController.swift) 구현 <br /> - pr: [HomeView 구현](https://github.com/bdrsky2010/CollaborationTMDB/pull/4), [LikelistView 구현](https://github.com/bdrsky2010/CollaborationTMDB/pull/5)|
| <img width="50" height="50" src="https://avatars.githubusercontent.com/u/59233161?v=4" /> | 오종우<br />([audi3m](https://github.com/audi3m)) | - CollectionView에서 재사용할 VerticalCollectionViewCell 구현 <br /> - 실시간 검색으로 영화 목록 조회하는 [SearchView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Search/View/SearchViewController.swift), [ViewModel](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Search/ViewModel/SearchViewModel.swift) 구현 (페이지네이션 구현, 검색어 없을 시 Trending 영화 목록 테이블 뷰 노출) <br /> - pr: [reusable 뷰](https://github.com/bdrsky2010/CollaborationTMDB/pull/3), [SearchView](https://github.com/bdrsky2010/CollaborationTMDB/pull/6) |
| <img width="50" height="50" src="https://avatars.githubusercontent.com/u/121326152?v=4" /> | 강한결<br />([hankyeol-dev](https://github.com/hankyeol-dev)) | - 재사용 가능한 PosterImageView, TableCellView 구현 <br /> - 컬랙션, 테이블 셀 터치하여 전환되는 [MediaDetailView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Detail/View/DetailViewController.swift), [ViewModel](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Detail/ViewModel/DetailViewModel.swift) 구현 <br /> - pr: [reusable 뷰](https://github.com/bdrsky2010/CollaborationTMDB/pull/1), [MediaDetailView](https://github.com/bdrsky2010/CollaborationTMDB/pull/7), [관심 목록 저장 로직](https://github.com/bdrsky2010/CollaborationTMDB/pull/9) |


<br />

## 프로젝트 구현 화면

|1. HomeView | 2. SearchView | 3. LikelistView  | 4. MediaDetailView  |
| -- | -- | -- | -- |
| <img width="200" src="https://github.com/user-attachments/assets/5ccaeb3f-7708-4564-afaa-293d103e9b43" /> | <img width="200" src="https://github.com/user-attachments/assets/cfca5af0-e394-4f07-bf47-aaa4355006cd" /> | <img width="200" src="https://github.com/user-attachments/assets/9f0b8869-220a-4760-a13f-6d73a5c07ead" /> | <img width="200" src="https://github.com/user-attachments/assets/e04eed32-8c1e-404c-badd-ab8c6de03fc1" /> |

<br />

## 프로젝트 브랜치 전략
<img width="786" alt="스크린샷 2024-10-15 오후 4 18 19" src="https://github.com/user-attachments/assets/d7fbf6c5-ca9f-41a4-9c65-9a10f973c166">

- github flow를 채택한 브랜치 전략 적용
  - main 브랜치에서 각자 담당한 feature별로 `feature/기능` 브랜치를 구분하여 작업
  - Pull Request 방식으로 브랜치별 코드를 main 브랜치에 합치고, 그 과정에 발생하는 충돌 해결
  - 프로젝트 초기 설정 후 github flow를 진행하여 협업 초반의 충돌 최소화 


- 협업 커밋 컨벤션

  ```
  #  👾 Fix: 올바르지 않은 동작(버그)을 고친 경우
  #  🧑🏻‍💻 Feat: 새로운 기능을 추가한 경우
  #  💾 Add: feat 이외의 부수적인 코드, 라이브러리 등을 추가한 경우, 새로운 파일(Component나 Activity 등)을 생성한 경우도 포함
  #  🩹 Refactor: 내부 로직은 변경하지 않고 기존의 코드를 개선한 경우, 클래스명 수정&가독성을 위해 변수명을 변경한 경우도 포함
  #  🗑️ Remove: 코드, 파일을 삭제한 경우, 필요 없는 주석 삭제도 포함
  #  🚚 Move: fix, refactor 등과 관계 없이 코드, 파일 등의 위치를 이동하는 작업만 수행한 경우
  #  🎨 Style: 내부 로직은 변경하지 않고 코드 스타일, 포맷 등을 수정한 경우, 줄 바꿈, 누락된 세미콜론 추가 등의 작업도 포함
  #  💄 Design: CSS 등 사용자 UI 디자인을 추가, 수정한 경우
  #  📝 Comment: 필요한 주석을 추가, 수정한 경우(❗ 필요 없는 주석을 삭제한 경우는 remove)
  #  📚 Docs: 문서를 추가, 수정한 경우
  #  🔧 Test: 테스트 코드를 추가, 수정, 삭제한 경우
  #  🎸 Chore: 위 경우에 포함되지 않는 기타 변경 사항
  #  🙈 GitIgnore: ignore파일 추가 및 수정
  ```
