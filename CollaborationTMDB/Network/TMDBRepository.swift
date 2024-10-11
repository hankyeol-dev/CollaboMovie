//
//  TMDBRepository.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import Foundation

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
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            DispatchQueue.global().async(group: dispatchGroup) {
               successHandler(success.asDetailViewInput())
               dispatchGroup.leave()
            }
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
