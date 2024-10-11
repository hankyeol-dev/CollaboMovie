//
//  ThumbnailTableViewCell.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/8/24.
//

import UIKit

import SnapKit
import Kingfisher

// TODO: 실제 ResponseDTO와 타입 합칠 필요 있음
struct MovieModel: Decodable {
   var path: String
   var title: String
}

final class ThumbnailTableViewCell: BaseTableViewCell {
   static let id: String = "ThumbnailTableViewCell"
   
   private let thumbnail: UIImageView = {
      let view = UIImageView()
      view.contentMode = .scaleToFill
      return view
   }()
   private let titleLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 16.0, weight: .regular)
      return view
   }()
   private let playButton: RoundedButton = .init(
      foregroundColor: .white,
      backgroundColor: .clear,
      title: "",
      fontSize: 20.0,
      image: .playCircle
   )
   
   override func configureHierachy() {
      super.configureHierachy()
      contentView.addSubviews(thumbnail, titleLabel, playButton)
   }
   
   override func configureLayout() {
      super.configureLayout()
      thumbnail.snp.makeConstraints { make in
         make.verticalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15.0)
         make.width.equalTo(100.0)
      }
      titleLabel.snp.makeConstraints { make in
         make.centerY.equalTo(thumbnail.snp.centerY)
         make.leading.equalTo(thumbnail.snp.trailing).offset(15.0)
         make.trailing.equalTo(playButton.snp.leading).offset(-15.0)
      }
      playButton.snp.makeConstraints { make in
         make.centerY.equalTo(thumbnail.snp.centerY)
         make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15.0)
         make.width.equalTo(24.0)
      }
   }
   
   func configureView(_ data: MovieModel) {
      thumbnail.kf.setImage(with: URL(string: data.path))
      titleLabel.text = data.title
   }
   
   func configrueViewWithLocalData(_ data: MovieModel) {
      thumbnail.image = UIImage(contentsOfFile: data.path)
      titleLabel.text = data.title
   }
}

extension ThumbnailTableViewCell {
    func configrueViewWithLocalData(_ data: MovieTable) {
        thumbnail.image = ImageFileManager.loadImage(filename: data.imageName)
        titleLabel.text = data.title
    }
}
