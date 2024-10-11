//
//  SimilarTVResponseDTO.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct SimilarTVResponseDTO: Decodable {
    let results: [TMDBTVResponse]
}

extension SimilarTVResponseDTO {
    // TODO: Mapping Property
   func asDetailViewInput() -> [DetailViewInput] {
      results.map { .init(
         id: $0.id,
         title: $0.name,
         backdropPath: DatabaseRepository.existMovie(movieId: $0.id) ? $0.name : $0.posterPath,
         voteAverage: $0.voteAverage,
         overview: $0.overview.isEmpty ? "줄거리 요약이 없습니다." : $0.overview,
         mediaType: .tv
      )}
   }
}
