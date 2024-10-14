//
//  SearchMedia.swift
//  CollaborationTMDB
//
//  Created by J Oh on 10/12/24.
//

import Foundation

struct SearchMedia {
    let id: Int
    let title: String
    let posterPath: String
    let backdropPath: String
    var genreIds: [Int]
    var overview: String
    var voteAverage: Double
}
