//
//  +UIView.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/8/24.
//

import UIKit

extension UIView {
   func addSubviews(_ views: UIView...) {
      views.forEach { self.addSubview($0) }
   }
}

extension UIStackView {
   func addArrangedSubviews(_ views: UIView...) {
      views.forEach { self.addArrangedSubview($0) }
   }
}
