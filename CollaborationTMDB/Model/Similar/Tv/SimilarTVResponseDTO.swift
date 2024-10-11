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
         backdropPath: $0.backdropPath,
         voteAverage: $0.voteAverage,
         overview: $0.overview,
         mediaType: .tv
      )}
   }
}
