//
//  TrendingTvResponseDTO.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct TrendingTVResponseDTO: Decodable {
    let results: [TMDBTVResponse]
}

extension TrendingTVResponseDTO {
    // TODO: Mapping Property
}