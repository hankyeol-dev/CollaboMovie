//
//  SimilarRequestDTO+Mapping.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct SimilarRequestDTO: Encodable {
    let language: String = "ko-KR"
    let page: Int = 1
}

extension SimilarRequestDTO {
    var asParameters: [String: Any] {
        return JSONEncoder.toDictionary(self)
    }
}
