//
//  DatabaseRepository.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import Foundation
import RealmSwift

enum DatabaseRepository {
    private static let realm = try! Realm()
    
    static var movies: Results<MovieTable> {
        realm.objects(MovieTable.self)
    }
    
    static func addMovie(movie: MovieTable) {
        do {
            try realm.write {
                realm.add(movie)
                print("success add movie")
            }
        } catch {
            print("failure add movie")
        }
    }
    
    static func removeMovie(movie: MovieTable) {
        do {
            try realm.write {
                realm.delete(movie)
                print("success delete movie")
            }
        } catch {
            print("failure delete movie")
        }
    }
    
    static func existMovie(movieId: Int) -> Bool {
        return movies.contains { $0.id == movieId }
    }
    
    static func printFilePath() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
}
