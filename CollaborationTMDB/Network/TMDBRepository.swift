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
    
    func requestSimilarMovie(movieId: Int) {
        let dto = SimilarRequestDTO()
        networkManager.request(.similarMovie(dto, movieId: movieId), of: SimilarMovieResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestSimilarTV(seriesId: Int) {
        let dto = SimilarRequestDTO()
        networkManager.request(.similarTV(dto, seriesId: seriesId), of: SimilarTVResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestCreditMovie(movieId: Int) {
        let dto = CreditRequestDTO()
        networkManager.request(.creditMovie(dto, movieId: movieId), of: CreditResponseDTO.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func requestCreditTV(seriesId: Int) {
        let dto = CreditRequestDTO()
        networkManager.request(.creditTV(dto, seriesId: seriesId), of: CreditResponseDTO.self) { result in
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

// 서치뷰에서 영화 검색
extension TMDBRepository {
    func requestSearch(query: String, page: Int, completion: @escaping (Result<SearchMovieResponseDTO, TMDBError>) -> Void) {
        let dto = SearchMovieRequestDTO(query: query, page: page)
        networkManager.request(.searchMovie(dto), of: SearchMovieResponseDTO.self) { result in
            completion(result)
        }
    }
}
