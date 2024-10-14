//
//  TMDBRepository.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import Foundation
import RxSwift

final class TMDBRepository {
    static let shared = TMDBRepository()
    
    private let networkManager: NetworkManager
    
    private init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
}

extension TMDBRepository {
    func requestSearch(query: String, page: Int) {
        let dto = SearchMovieRequestDTO(query: query, page: page)
        networkManager.request(.searchMovie(dto), of: SearchMovieResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestTrendingMovie() {
        let dto = TrendingRequestDTO()
        networkManager.request(.trendingMovie(dto), of: TrendingMovieResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestTrendingTV() {
        let dto = TrendingRequestDTO()
        networkManager.request(.trendingTV(dto), of: TrendingTVResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestGenreMovie() {
        let dto = GenreRequestDTO()
        networkManager.request(.genreMovie(dto), of: GenreResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestGenreTV() {
        let dto = GenreRequestDTO()
        networkManager.request(.genreTV(dto), of: GenreResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

// MARK: DetailView에 활용하는 Credit, Similar Movie, Similar TV request
extension TMDBRepository {
   func requestCredit(
      mediaId: Int,
      mediaType: DetailViewInput.MediaType,
      successHandler: @escaping([DetailCastAndDirect], [DetailCastAndDirect]) -> Void,
      errorHandler: @escaping() -> Void
   ) {
      let dto = CreditRequestDTO()
      networkManager.request(
         mediaType == .movie
         ? .creditMovie(dto, movieId: mediaId)
         : .creditTV(dto, seriesId: mediaId),
         of: CreditResponseDTO.self
      ) { result in
         switch result {
         case .success(let success):
            successHandler(success.toCastGroup(), success.toDirectGroup())
         case .failure:
            errorHandler()
         }
      }
   }
   
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
   
   func requestSimilarTV(
      seriesId: Int,
      successHandler: @escaping ([DetailViewInput]) -> Void,
      errorHandler: @escaping () -> Void
   ) {
      let dto = SimilarRequestDTO()
      networkManager.request(
         .similarTV(dto, seriesId: seriesId), of: SimilarTVResponseDTO.self) { result in
         switch result {
         case .success(let success):
            successHandler(success.asDetailViewInput())
         case .failure:
            errorHandler()
         }
      }
   }
}
// 서치뷰에서 영화 검색
extension TMDBRepository {
    func requestSearchMovie(query: String, page: Int) -> Single<Result<SearchResult, TMDBError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.badRequest)))
                return Disposables.create()
            }
            
            let dto = SearchMovieRequestDTO(query: query, page: page)
            networkManager.request(.searchMovie(dto), of: SearchMovieResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toSearchResult())))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            
            return Disposables.create()
        }
    }
}

// MARK: HomeView
extension TMDBRepository {
    func requestTrendingMovie() -> Single<Result<[HomeMedia], TMDBError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.badRequest)))
                return Disposables.create()
            }
            
            let dto = TrendingRequestDTO()
            networkManager.request(.trendingMovie(dto), of: TrendingMovieResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toHomeMedias())))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func requestTrendingTV() -> Single<Result<[HomeMedia], TMDBError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.badRequest)))
                return Disposables.create()
            }
            
            let dto = TrendingRequestDTO()
            networkManager.request(.trendingTV(dto), of: TrendingTVResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toHomeMedias())))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func requestGenreMovie() -> Single<Result<[HomeGenre], TMDBError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.badRequest)))
                return Disposables.create()
            }
            
            let dto = GenreRequestDTO()
            networkManager.request(.genreMovie(dto), of: GenreResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toGenres())))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func requestGenreTV() -> Single<Result<[HomeGenre], TMDBError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.badRequest)))
                return Disposables.create()
            }
            
            let dto = GenreRequestDTO()
            networkManager.request(.genreTV(dto), of: GenreResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success.toGenres())))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            
            return Disposables.create()
        }
    }
}
