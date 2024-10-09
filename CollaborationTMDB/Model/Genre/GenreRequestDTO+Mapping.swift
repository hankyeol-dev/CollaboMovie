//
//  GenreRequestDTO+Mapping.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct GenreRequestDTO: Encodable {
    let language: String = "ko"
}

extension GenreRequestDTO {
    var asParameters: [String: Any] {
        return JSONEncoder.toDictionary(self)
    }
}
