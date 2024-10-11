//
//  DetailViewInput.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/10/24.
//

import Foundation

struct DetailViewInput {
   enum MediaType {
      case movie
      case tv
   }
   
   var id: Int
   var title: String
   var backdropPath: String
   var voteAverage: Double?
   var overview: String?
   var mediaType: MediaType?
   var isSaved: Bool
   
   init(
      id: Int,
      title: String,
      backdropPath: String,
      voteAverage: Double? = nil,
      overview: String? = nil,
      mediaType: MediaType? = nil
   ) {
      self.id = id
      self.title = title
      self.backdropPath = backdropPath
      self.voteAverage = voteAverage
      self.overview = overview
      self.mediaType = mediaType
      self.isSaved = DatabaseRepository.existMovie(movieId: id)
   }
   
   mutating func mapIsSavedMedia() {
      if DatabaseRepository.existMovie(movieId: id) {
         backdropPath = title
         isSaved = true
      }
   }
}
