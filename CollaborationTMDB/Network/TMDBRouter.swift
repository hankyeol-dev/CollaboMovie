//
//  TMDBRouter.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import Foundation
import Moya

protocol TMDBTargetType: TargetType { }

extension TMDBTargetType {
    var baseURL: URL { try! BaseURL.tmdb.asURL() }
    var method: Moya.Method { .get }
    var headers: [String : String]? {
        return [
            TMDBHeader.authorization.rawValue: APIKEY.tmdb,
            TMDBHeader.accept.rawValue: TMDBHeader.json.rawValue
        ]
    }
}

enum TMDBRouter {
    case searchMovie(_ dto: SearchMovieRequestDTO)
    
    case trendingMovie(_ dto: TrendingRequestDTO)
    case trendingTV(_ dto: TrendingRequestDTO)
    
    case similarMovie(_ dto: SimilarRequestDTO, movieId: Int)
    case similarTV(_ dto: SimilarRequestDTO, seriesId: Int)
    
    case creditMovie(_ dto: CreditRequestDTO, movieId: Int)
    case creditTV(_ dto: CreditRequestDTO, seriesId: Int)
    
    case genreMovie(_ dto: GenreRequestDTO)
    case genreTV(_ dto: GenreRequestDTO)
}

extension TMDBRouter: TMDBTargetType {
    var path: String {
        switch self {
        case .searchMovie: "search/movie"
            
        case .trendingMovie: "trending/movie/day"
        case .trendingTV: "trending/tv/day"
            
        case .similarMovie(_, let movieId): "movie/\(movieId)/similar"
        case .similarTV(_, let seriesId): "tv/\(seriesId)/similar"
            
        case .creditMovie(_, let movieId): "movie/\(movieId)/credits"
        case .creditTV(_, let seriesId): "tv/\(seriesId)/credits"
            
        case .genreMovie: "genre/movie/list"
        case .genreTV: "genre/tv/list"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchMovie(let dto):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .trendingMovie(let dto):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .trendingTV(let dto):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .similarMovie(let dto, _):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .similarTV(let dto, _):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .creditMovie(let dto, _):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .creditTV(let dto, _):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .genreMovie(let dto):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        case .genreTV(let dto):
                .requestParameters(parameters: dto.asParameters, encoding: URLEncoding.queryString)
        }
    }
}
