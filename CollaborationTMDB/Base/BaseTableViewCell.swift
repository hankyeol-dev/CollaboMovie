//
//  BaseTableViewCell.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/8/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      configureHierachy()
      configureLayout()
   }
   
   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func configureHierachy() { }
   func configureLayout() { }
}
