//
//  HomePosterView.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/9/24.
//

import UIKit

import Kingfisher
import SnapKit

final class HomePosterView: UIView {
   private let posterImage: UIImageView = {
      let view = UIImageView()
      view.contentMode = .scaleToFill
      view.layer.cornerRadius = 10.0
      view.clipsToBounds = true
      return view
   }()
   private let posterGradientView: UIView = {
      let view = UIView()
      let gradient = CAGradientLayer()
      gradient.colors = [UIColor.clear.cgColor,
                         UIColor.white.withAlphaComponent(0.4).cgColor]
      gradient.locations = [0.0, 1.0]
      view.layer.addSublayer(gradient)
      return view
   }()
   private let posterButtonStack: UIStackView = {
      let view = UIStackView()
      view.axis = .horizontal
      view.distribution = .fillEqually
      view.spacing = 15.0
      view.alignment = .center
      return view
   }()
   let posterPlayButton: RoundedButton = .init(
      foregroundColor: .black,
      backgroundColor: .white,
      title: "재생",
      fontSize: 15.0,
      image: .play)
   let posterLikeButton: RoundedButton = .init(
      foregroundColor: .white,
      backgroundColor: .black,
      title: "내가 찜한 리스트",
      fontSize: 15.0,
      image: .plus)
   
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configureHierachy()
      configureLayout()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func configureHierachy() {
      addSubview(posterImage)
      posterImage.addSubviews(posterGradientView, posterButtonStack)
      posterButtonStack.addArrangedSubviews(posterPlayButton, posterLikeButton)
   }
   
   private func configureLayout() {
      posterImage.snp.makeConstraints { make in
         make.edges.equalTo(safeAreaLayoutGuide).inset(15.0)
      }
      posterButtonStack.snp.makeConstraints { make in
         make.bottom.horizontalEdges.equalTo(posterImage.safeAreaLayoutGuide).inset(15.0)
         make.height.equalTo(50.0)
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      posterGradientView.frame = posterImage.bounds
      posterGradientView.layer.sublayers?.first?.frame = posterGradientView.bounds
      posterImage.bringSubviewToFront(posterButtonStack)
   }
   
   func configureView(_ data: MovieModel) {
      posterImage.kf.setImage(with: URL(string: data.path))
   }
}
