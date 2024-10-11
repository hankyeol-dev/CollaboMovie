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
         backdropPath: DatabaseRepository.existMovie(movieId: $0.id) ? $0.title : $0.posterPath,
         voteAverage: $0.voteAverage,
         overview: $0.overview.isEmpty ? "줄거리 요약이 없습니다." : $0.overview,
         mediaType: .movie
      )}
   }
}
