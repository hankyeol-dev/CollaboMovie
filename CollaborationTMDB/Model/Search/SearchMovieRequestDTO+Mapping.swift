//
//  SearchMovieRequestDTO+Mapping.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct SearchMovieRequestDTO: Encodable {
    let query: String
    let language: String = "ko-KR"
    let page: Int
    let region: String = "KR"
}

extension SearchMovieRequestDTO {
    var asParameters: [String: Any] {
        return JSONEncoder.toDictionary(self)
    }
}
