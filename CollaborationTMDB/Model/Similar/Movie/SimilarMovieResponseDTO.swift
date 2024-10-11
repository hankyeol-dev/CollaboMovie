//
//  SimilarMovieResponseDTO.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct SimilarMovieResponseDTO: Decodable {
    let results: [TMDBMovieResponseDTO]
}

extension SimilarMovieResponseDTO {
    // TODO: Mapping Property
   func asDetailViewInput() -> [DetailViewInput] {
      results.map { .init(
         id: $0.id, 
         title: $0.title,
         backdropPath: $0.backdropPath,
         voteAverage: $0.voteAverage,
         overview: $0.overview,
         mediaType: .movie
      )}
   }
}
