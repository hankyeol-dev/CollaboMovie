//
//  HomeView.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = HomePosterView()
    private let collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let headerView1: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨는 영화"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let headerView2: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨는 TV 시리즈"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        bind()
        viewModel.action(.viewDidLoad)
    }
}

extension HomeViewController {
    private func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(headerView1)
        contentView.addSubview(headerView2)
        contentView.addSubview(collectionView1)
        contentView.addSubview(collectionView2)
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.75)
        }
        
        headerView1.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView1.snp.makeConstraints { make in
            make.top.equalTo(headerView1.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        headerView2.snp.makeConstraints { make in
            make.top.equalTo(collectionView1.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView2.snp.makeConstraints { make in
            make.top.equalTo(headerView2.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func configureCollectionView() {
        collectionView1.register(
            VerticalCollectionViewCell.self,
            forCellWithReuseIdentifier: VerticalCollectionViewCell.id
        )
        collectionView2.register(
            VerticalCollectionViewCell.self,
            forCellWithReuseIdentifier: VerticalCollectionViewCell.id
        )
    }
}

extension HomeViewController {
    private func bind() {
        collectionView1.rx
            .modelSelected(HomeMedia.self)
            .bind(with: self) { owner, movie in
                owner.viewModel.action(.movieCellTap(movie))
            }
            .disposed(by: disposeBag)
        
        collectionView2.rx
            .modelSelected(HomeMedia.self)
            .bind(with: self) { owner, tv in
                owner.viewModel.action(.tvCellTap(tv))
            }
            .disposed(by: disposeBag)
        
        viewModel.output.movieData
            .bind(to: collectionView1.rx.items(cellIdentifier: VerticalCollectionViewCell.id, cellType: VerticalCollectionViewCell.self)) { index, element, cell in
                cell.configureData(element.posterPath)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.tvData
            .bind(to: collectionView2.rx.items(cellIdentifier: VerticalCollectionViewCell.id, cellType: VerticalCollectionViewCell.self)) { index, element, cell in
                cell.configureData(element.posterPath)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.output.movieData, viewModel.output.tvData)
            .bind(with: self) { owner, data in
                if Bool.random(), let movie = data.0.randomElement() {
                    owner.posterImageView.configureView(movie.posterPath)
                    owner.viewModel.action(.randomMedia(.movie, genreIds: movie.genreIds))
                    owner.posterImageView.posterLikeButton
                        .rx.tap
                        .bind(with: self) { vc, void in
                            owner.viewModel.action(.saveButtonTap(movie))
                        }
                        .disposed(by: owner.disposeBag)
                } else if let tv = data.1.randomElement() {
                    owner.posterImageView.configureView(tv.posterPath)
                    owner.viewModel.action(.randomMedia(.tv, genreIds: tv.genreIds))
                    owner.posterImageView.posterLikeButton
                        .rx.tap
                        .bind(with: self) { vc, void in
                            owner.viewModel.action(.saveButtonTap(tv))
                        }
                        .disposed(by: owner.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.genreData
            .bind(with: self) { owner, genreData in
                owner.posterImageView.configureLabel(genreData)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.movieCellTapData
            .bind(with: self) { owner, detailViewInput in
                let detailView: DetailViewController = .init(
                    detailViewModel: .init(detailViewInput: detailViewInput)
                )
                owner.present(detailView, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.tvCellTapData
            .bind(with: self) { owner, detailViewInput in
                let detailView: DetailViewController = .init(
                    detailViewModel: .init(detailViewInput: detailViewInput)
                )
                owner.present(detailView, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.saveButtonTap
            .bind(with: self) { owner, isSaved in
                BaseAlertBuilder(viewController: owner)
                    .setMessage(isSaved ? "미디어를 저장했어요." : "이미 저장된 미디어에요.")
                    .setAction {
                        owner.dismiss(animated: true)
                    }
                    .displayAlert()
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
}
