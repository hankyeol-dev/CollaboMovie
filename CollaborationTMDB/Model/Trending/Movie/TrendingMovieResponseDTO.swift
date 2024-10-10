//
//  TrendingMovieResponseDTO.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct TrendingMovieResponseDTO: Decodable {
    let results: [TMDBMovieResponseDTO]
}

extension TrendingMovieResponseDTO {
    // TODO: Mapping Property
    func toHomeMovies() -> [HomeMovie] {
        return self.results.map { $0.toHomeMovie() }
    }
}
