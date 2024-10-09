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
}
