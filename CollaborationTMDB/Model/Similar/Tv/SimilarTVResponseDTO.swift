//
//  SimilarTVResponseDTO.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct SimilarTVResponseDTO: Decodable {
    let results: [TMDBMovieResponseDTO]
}

extension SimilarTVResponseDTO {
    // TODO: Mapping Property
}
