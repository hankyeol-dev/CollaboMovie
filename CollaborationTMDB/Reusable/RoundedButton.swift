//
//  RoundedButton.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/8/24.
//

import UIKit

final class RoundedButton: UIButton {
   enum ButtonImages: String {
      case play
      case magnifyingglass
      case sparkles = "sparkles.tv"
      case house
      case playCircle = "play.circle"
      case square = "square.and.arrow.down"
      case face = "face.smiling"
      case plus
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   convenience init(
      foregroundColor: UIColor = .black,
      backgroundColor: UIColor = .white,
      title: String,
      fontSize: CGFloat = 14.0,
      image: ButtonImages? = nil
   ) {
      self.init(frame: .zero)

      var config = UIButton.Configuration.filled()
      config.baseForegroundColor = foregroundColor
      config.baseBackgroundColor = backgroundColor
      
      var titleContainer = AttributeContainer()
      titleContainer.font = .systemFont(ofSize: fontSize, weight: .bold)
      config.attributedTitle = AttributedString(title, attributes: titleContainer)

      if let image {
         config.image = UIImage(systemName: image.rawValue)
         config.imagePlacement = .leading
         config.imagePadding = 15.0
         config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: fontSize - 4.0
         )
      }
      
      configuration = config
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
}
