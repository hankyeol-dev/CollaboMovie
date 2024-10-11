//
//  MovieTable.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import Foundation
import RealmSwift

final class MovieTable: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var imageName: String
    @Persisted var overview: String
    @Persisted var voteAverage: Double
    
    convenience init(
        id: Int,
        title: String,
        imageName: String,
        overview: String,
        voteAverage: Double
    ) {
        self.init()
        self.id = id
        self.title = title
        self.imageName = imageName
        self.overview = overview
        self.voteAverage = voteAverage
    }
}
