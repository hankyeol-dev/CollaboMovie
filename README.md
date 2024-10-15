# CollaborationTMDB

### 프로젝트 소개
[TMDB API](https://developer.themoviedb.org/reference/intro/getting-started)를 활용한 **나만의 영화/TV 미디어  관심 목록 관리** 앱
- 기간: 2024.10.10 ~ 10.13
- 팀 구성: 김민재(), 오종우(), 강한결 3인
- 최소 버전: iOS 15.0
- 스택: UIKit, RxSwift, RealmSwift, Moya MVVM
- 주요기능
  - Trending 영화, TV 데이터 조회
  - 실시간 영화, TV 미디어 검색
  - 나만의 미디어 관심 목록 저장/삭제

앱 구현 화면
|1. HomeView | 2. SearchView | 3. LikelistView  | 4. MediaDetailView  |
| -- | -- | -- | -- |
| <img width="200" src="https://github.com/user-attachments/assets/5ccaeb3f-7708-4564-afaa-293d103e9b43" /> | <img width="200" src="https://github.com/user-attachments/assets/cfca5af0-e394-4f07-bf47-aaa4355006cd" /> | <img width="200" src="https://github.com/user-attachments/assets/9f0b8869-220a-4760-a13f-6d73a5c07ead" /> | <img width="200" src="https://github.com/user-attachments/assets/e04eed32-8c1e-404c-badd-ab8c6de03fc1" /> |

- 기능 구현을 위해서 신경쓴거

<br />

### 프로젝트 구성원 별 담당 


|   | 이름(github) | 담당 및 구현 |
| :-: | :---: | :--- |
| <img width="50" height="50" src="https://avatars.githubusercontent.com/u/80156515?v=4" /> | 김민재<br />([bdrsky2010](https://github.com/bdrsky2010)) | - TMDB API 통신에 필요한 [Router](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Network/TMDBRouter.swift), [Request](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Network/NetworkManager.swift), [Model](https://github.com/bdrsky2010/CollaborationTMDB/tree/main/CollaborationTMDB/Model) 구현 <br /> - 미디어 관심 목록 저장/삭제를 위한 [로컬 DB Repository](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Database/DatabaseRepository.swift), [FileManager](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Database/ImageFileManager.swift) 로직 구현 <br /> - Trending 영화, TV 미디어 목록을 제공하는 [HomeView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Home/HomeViewController.swift) 구현 <br /> - 관심 목록으로 저장한 미디어 목록을 조회하는 [LikelistView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Like/LikeViewController.swift) 구현 <br /> - pr: [HomeView 구현](https://github.com/bdrsky2010/CollaborationTMDB/pull/4), [LikelistView 구현](https://github.com/bdrsky2010/CollaborationTMDB/pull/5)|
| <img width="50" height="50" src="https://avatars.githubusercontent.com/u/59233161?v=4" /> | 오종우<br />([audi3m](https://github.com/audi3m)) | - CollectionView에서 재사용할 VerticalCollectionViewCell 구현 <br /> - 실시간 검색으로 영화 목록 조회하는 [SearchView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Search/View/SearchViewController.swift), [ViewModel](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Search/ViewModel/SearchViewModel.swift) 구현 (페이지네이션 구현, 검색어 없을 시 Trending 영화 목록 테이블 뷰 노출) <br /> - pr: [reusable 뷰](https://github.com/bdrsky2010/CollaborationTMDB/pull/3), [SearchView](https://github.com/bdrsky2010/CollaborationTMDB/pull/6) |
| <img width="50" height="50" src="https://avatars.githubusercontent.com/u/121326152?v=4" /> | 강한결<br />([hankyeol-dev](https://github.com/hankyeol-dev)) | - 재사용 가능한 PosterImageView, TableCellView 구현 <br /> - 컬랙션, 테이블 셀 터치하여 전환되는 [MediaDetailView](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Detail/View/DetailViewController.swift), [ViewModel](https://github.com/bdrsky2010/CollaborationTMDB/blob/main/CollaborationTMDB/Scene/Detail/ViewModel/DetailViewModel.swift) 구현 <br /> - pr: [reusable 뷰](https://github.com/bdrsky2010/CollaborationTMDB/pull/1), [MediaDetailView](https://github.com/bdrsky2010/CollaborationTMDB/pull/7), [관심 목록 저장 로직](https://github.com/bdrsky2010/CollaborationTMDB/pull/9) |

- 협업 커뮤니케이션을 최소화 하기 위한 팀 전략 (?)

<br />

### 협업 브랜치 전략
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
