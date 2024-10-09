//
//  CreditRequestDTO+Mapping.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct CreditRequestDTO: Encodable {
    let language: String = "ko-KR"
}

extension CreditRequestDTO {
    var asParameters: [String: Any] {
        return JSONEncoder.toDictionary(self)
    }
}

/*
 Cast
 "adult": false,
 "gender": 2,
 "id": 78402,
 "known_for_department": "Acting",
 "name": "모리타 마사카즈",
 "original_name": "森田成一",
 "popularity": 13.643,
 "profile_path": "/2INsHYbx9gEhhzXPHdqBDdvHjFt.jpg",
 "character": "Ichigo Kurosaki (voice)",
 "credit_id": "52589be5760ee346615fd536",
 "order": 0
 
 "adult": false,
 "gender": 2,
 "id": 2232,
 "known_for_department": "Acting",
 "name": "마이클 키튼",
 "original_name": "Michael Keaton",
 "popularity": 44.431,
 "profile_path": "/82rxrGxOqQW2NjKsIiNbDYHFfmb.jpg",
 "cast_id": 12,
 "character": "Betelgeuse",
 "credit_id": "640b254c3a4a120102214aa5",
 "order": 0
 */

/*
 Crew
 "adult": false,
 "gender": 1,
 "id": 3331947,
 "known_for_department": "Art",
 "name": "Satomi Okuhara",
 "original_name": "Satomi Okuhara",
 "popularity": 1.143,
 "profile_path": null,
 "credit_id": "6344506ff3b49a007c949fde",
 "department": "Art",
 "job": "Assistant Director of Photography"
 
 "adult": false,
 "gender": 2,
 "id": 510,
 "known_for_department": "Directing",
 "name": "팀 버튼",
 "original_name": "Tim Burton",
 "popularity": 25.52,
 "profile_path": "/wcjuY5vD1nlfwWNbvvTGg5dGoRR.jpg",
 "credit_id": "63073e8318864b007b189051",
 "department": "Directing",
 "job": "Director"
 */
