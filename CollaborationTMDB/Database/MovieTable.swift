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
    @Persisted var ImagePath: String
    
    convenience init(id: Int, title: String, ImagePath: String) {
        self.init()
        self.id = id
        self.title = title
        self.ImagePath = ImagePath
    }
}
