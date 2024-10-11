//
//  DetailViewController.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/10/24.
//

import UIKit

import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
   private let detailViewModel: DetailViewModel
   private let disposeBag: DisposeBag = .init()
   
   private let posterImage: UIImageView = {
      let view = UIImageView()
      view.contentMode = .scaleToFill
      return view
   }()
   let playButton: RoundedButton = .init(
      foregroundColor: .white,
      backgroundColor: .black.withAlphaComponent(0.5),
      title: "",
      fontSize: 16.0,
      image: .playCircle)
   let closeButton: RoundedButton = .init(
      foregroundColor: .white,
      backgroundColor: .black.withAlphaComponent(0.5),
      title: "",
      fontSize: 16.0,
      image: .xmark)
   
   private let contentScroll = UIScrollView()
   private let contentView = UIView()
   private let titleLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 18.0, weight: .bold)
      return view
   }()
   private let rateLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 14.0, weight: .regular)
      return view
   }()
   private let overviewLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 12.0, weight: .regular)
      view.numberOfLines = 0
      return view
   }()
   private let castLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 12.0, weight: .regular)
      return view
   }()
   private let directLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 12.0, weight: .regular)
      return view
   }()
   private let playLargeButton: RoundedButton = .init(
      foregroundColor: .black,
      backgroundColor: .white,
      title: "재생",
      fontSize: 15.0,
      image: .play)
   private let saveLargeButton: RoundedButton = .init(
      foregroundColor: .white,
      backgroundColor: .baseGray,
      title: "저장",
      fontSize: 15.0,
      image: .square)
   private let similarSectionTitleLabel: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 18.0, weight: .bold)
      view.text = "비슷한 콘텐츠"
      return view
   }()
   private let similarSectionCollection: UICollectionView = {
      let flow = UICollectionViewFlowLayout()
      let width = (UIScreen.main.bounds.width - 60) / 3
      let height = 120.0
      flow.itemSize = .init(width: width, height: height)
      flow.minimumInteritemSpacing = 15.0
      flow.minimumLineSpacing = 15.0
      let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
      view.register(
         VerticalCollectionViewCell.self,
         forCellWithReuseIdentifier: VerticalCollectionViewCell.id)
      view.backgroundColor = .clear
      view.showsVerticalScrollIndicator = false
      return view
   }()
   
   init(detailViewModel: DetailViewModel) {
      self.detailViewModel = detailViewModel
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      
      configureHierachy()
      configureLayout()
      bindOutput()
      bindInput()
      detailViewModel.bindDidLoad()
   }
}

extension DetailViewController {
   private func configureHierachy() {
      view.addSubviews(posterImage, playButton, closeButton, contentScroll)
      contentScroll.addSubview(contentView)
      contentView.addSubviews(
         titleLabel, rateLabel, playLargeButton, saveLargeButton, overviewLabel,
         castLabel, directLabel, similarSectionTitleLabel, similarSectionCollection
      )
   }
   
   private func configureLayout() {
      posterImage.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.height.equalTo(250.0)
      }
      playButton.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide).inset(15.0)
         make.size.equalTo(40.0)
         make.trailing.equalTo(closeButton.snp.leading).offset(-15.0)
      }
      closeButton.snp.makeConstraints { make in
         make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(15.0)
         make.size.equalTo(40.0)
      }
      contentScroll.snp.makeConstraints { make in
         make.top.equalTo(posterImage.snp.bottom)
         make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
      }
      contentView.snp.makeConstraints { make in
         make.width.equalTo(contentScroll.snp.width)
         make.verticalEdges.equalTo(contentScroll)
      }
      let guide = contentView.safeAreaLayoutGuide
      titleLabel.snp.makeConstraints { make in
         make.top.equalTo(guide).inset(10.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
      }
      rateLabel.snp.makeConstraints { make in
         make.top.equalTo(titleLabel.snp.bottom).offset(5.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
      }
      playLargeButton.snp.makeConstraints { make in
         make.top.equalTo(rateLabel.snp.bottom).offset(15.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
         make.height.equalTo(40.0)
      }
      saveLargeButton.snp.makeConstraints { make in
         make.top.equalTo(playLargeButton.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
         make.height.equalTo(40.0)
      }
      overviewLabel.snp.makeConstraints { make in
         make.top.equalTo(saveLargeButton.snp.bottom).offset(20.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
         make.bottom.equalTo(castLabel.snp.top).offset(-20.0)
      }
      castLabel.snp.makeConstraints { make in
         make.horizontalEdges.equalTo(guide).inset(15.0)
      }
      directLabel.snp.makeConstraints { make in
         make.top.equalTo(castLabel.snp.bottom).offset(5.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
      }
      similarSectionTitleLabel.snp.makeConstraints { make in
         make.top.equalTo(directLabel.snp.bottom).offset(30.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
      }
      similarSectionCollection.snp.makeConstraints { make in
         make.top.equalTo(similarSectionTitleLabel.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(guide).inset(15.0)
         make.height.equalTo(930.0)
         make.bottom.equalTo(guide).offset(-15.0)
      }
   }
}

extension DetailViewController {
   private func bindOutput() {
      detailViewModel
         .output.didLoadDetailViewOutput
         .bind(with: self) { vc, output in
            if output.isSaved {
               vc.posterImage.image = ImageFileManager.loadImage(filename: output.backdropPath)
            } else {
               vc.posterImage.kf.setImage(
                  with: URL(string: ImageURL.tmdb(image: output.backdropPath).urlString)
               )
            }
            vc.titleLabel.text = output.title
            
            if let rate = output.voteAverage {
               vc.rateLabel.text = String(rate)
            }
            if let overview = output.overview {
               vc.overviewLabel.text = overview               
            }
         }
         .disposed(by: disposeBag)
      
      detailViewModel
         .output.didLoadCastOutput
         .asDriver(onErrorJustReturn: [])
         .drive(with: self) { vc, casts in
            if !casts.isEmpty {
               vc.castLabel.text = "출연: \(casts.map { $0.name }.joined(separator: ","))"
            }
         }
         .disposed(by: disposeBag)
      
      detailViewModel
         .output.didLoadDirectOutput
         .asDriver(onErrorJustReturn: [])
         .drive(with: self) { vc, directs in
            if !directs.isEmpty {
               vc.directLabel.text = "크리에이터: \(directs.map { $0.name }.joined(separator: ","))"
            }
         }
         .disposed(by: disposeBag)
      
      detailViewModel
         .output.didLoadSimilarOutput
         .bind(to: similarSectionCollection.rx.items(
            cellIdentifier: VerticalCollectionViewCell.id,
            cellType: VerticalCollectionViewCell.self)
         ) { index, item, cell in
            if item.backdropPath.isEmpty {
               cell.configureWithoutData()
            } else {
               if item.isSaved {
                  cell.configureData(filePath: item.backdropPath)
               } else {
                  cell.configureData(item.backdropPath)
               }
            }
         }
         .disposed(by: disposeBag)
      
      detailViewModel
         .output.saveButtonOutput
         .bind(with: self) { vc, isSaved in
            BaseAlertBuilder(viewController: vc)
               .setMessage(isSaved ? "이미 저장된 미디어에요." : "미디어를 저장했어요.")
               .setAction {
                  vc.dismiss(animated: true)
               }
               .displayAlert()
         }
         .disposed(by: disposeBag)
   }
   
   private func bindInput() {
      closeButton
         .rx.tap
         .bind(with: self) { vc, _ in
            vc.dismiss(animated: true)
         }
         .disposed(by: disposeBag)
      
      saveLargeButton
         .rx.tap
         .bind(with: self) { vc, void in
            vc.detailViewModel.bindSaveButtonInput()
         }
         .disposed(by: disposeBag)

      // MARK: 디테일 뷰 안에서 다른 영화/tv 포스터 터치하면, 스택 형태로 뷰 컨트롤러 축적
      similarSectionCollection
         .rx.modelSelected(DetailViewInput.self)
         .bind(with: self) { vc, item in
            var targetItem = item
            targetItem.mapIsSavedMedia()
            let target = DetailViewController(
               detailViewModel: .init(detailViewInput: targetItem)
            )
            vc.present(target, animated: true)
         }
         .disposed(by: disposeBag)
   }
}
