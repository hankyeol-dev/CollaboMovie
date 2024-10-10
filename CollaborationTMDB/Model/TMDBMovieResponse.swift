//
//  TMDBMovieResponse.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct TMDBMovieResponseDTO: Decodable {
    let backdropPath: String // 옵셔널
    let id: Int
    let title: String // 옵셔널
    let originTitle: String // 옵셔널
    let overview: String
    let posterPath: String // 옵셔널
    let mediaType: String // 옵셔널
    let adult: Bool
    let originLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case originTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.originTitle = try container.decodeIfPresent(String.self, forKey: .originTitle) ?? ""
        self.overview = try container.decode(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        self.mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType) ?? ""
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.originLanguage = try container.decode(String.self, forKey: .originLanguage)
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}

extension TMDBMovieResponseDTO {
    func toHomeMedia() -> HomeMedia {
        return HomeMedia(
            id: self.id,
            title: self.title,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            genreIds: self.genreIds
        )
    }
}
