//
//  +UIImage.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/10/24.
//

import UIKit

enum Icons: String {
   case play
   case magnifyingglass
   case sparkles = "sparkles.tv"
   case house
   case playCircle = "play.circle"
   case square = "square.and.arrow.down"
   case face = "face.smiling"
   case plus
   
   func asUIImage() -> UIImage? {
      return UIImage(systemName: self.rawValue)
   }
}
