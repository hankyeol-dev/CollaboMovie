//
//  SearchViewController.swift
//  CollaborationTMDB
//
//  Created by J Oh on 10/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "게임, 시리즈, 영화를 검색하세요.."
        bar.backgroundImage = UIImage()
        return bar
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ThumbnailTableViewCell.self, forCellReuseIdentifier: ThumbnailTableViewCell.id)
        view.separatorStyle = .none
        view.rowHeight = 180
        view.isHidden = false
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: SearchViewController.layout())
        view.delegate = self
        view.isHidden = true
        view.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: VerticalCollectionViewCell.id)
        view.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeader.id)
        return view
    }()
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "결과가 없습니다."
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        viewModel.action(.viewDidLoad)
        configureTableViewHeader()
        rxBind()
    }
    
}

// RxBind
extension SearchViewController {
    private func rxBind() {
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)
        
        viewModel.output.trendMovieData
            .bind(to: tableView.rx.items(cellIdentifier: ThumbnailTableViewCell.id, cellType: ThumbnailTableViewCell.self)) { index, movie, cell in
                cell.configureView(movie)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.trendCellTapData
            .bind(with: self) { owner, detailViewInput in
                let detailView: DetailViewController = .init(
                    detailViewModel: .init(detailViewInput: detailViewInput)
                )
                owner.present(detailView, animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(HomeMedia.self)
            .bind(with: self) { owner, movie in
                owner.viewModel.action(.trendCellTap(movie))
            }
            .disposed(by: disposeBag)
        
        viewModel.output.searchedMovieData
            .bind(to: collectionView.rx.items(cellIdentifier: VerticalCollectionViewCell.id, cellType: VerticalCollectionViewCell.self)) { index, movie, cell in
                cell.configureData(movie.posterPath)
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
        
        collectionView.rx
            .modelSelected(SearchMedia.self)
            .bind(with: self) { owner, movie in
                owner.viewModel.action(.movieCellTap(movie))
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            searchBar.rx.text.orEmpty,
            viewModel.searched,
            viewModel.output.searchedMovieData
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] query, searched, movies in
            guard let self = self else { return }
            if query.isEmpty {
                self.tableView.isHidden = false
                self.collectionView.isHidden = true
                self.noResultsLabel.isHidden = true
            } else {
                self.tableView.isHidden = true
                if searched {
                    self.collectionView.isHidden = movies.isEmpty
                    self.noResultsLabel.isHidden = !movies.isEmpty
                } else {
                    self.noResultsLabel.isHidden = true
                }
            }
        })
        .disposed(by: disposeBag)
        
        collectionView.rx
            .didScroll
            .withLatestFrom(collectionView.rx.contentOffset)
            .filter { [weak self] offset in
                guard let self else { return false }
                let position = offset.y + self.collectionView.frame.size.height
                return position >= self.collectionView.contentSize.height
            }
            .map { _ in }
            .bind(to: viewModel.input.loadNextPage)
            .disposed(by: disposeBag)
    }
}

// CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeader.id, for: indexPath) as! SearchHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
}

extension SearchViewController {
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        noResultsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.width
        let itemsInRow: CGFloat = 3
        let spacing: CGFloat = 4
        let totalSpacing = spacing * (itemsInRow - 1)
        let itemWidth = (screenWidth - totalSpacing) / itemsInRow
        let itemHeight = itemWidth * 1.48
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 44)
        
        return layout
    }
    
    private func configureTableViewHeader() {
        let headerContainer = UIView()
        headerContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        
        let headerLabel = UILabel()
        headerLabel.text = "추천 시리즈 & 영화"
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.textColor = .label
        headerLabel.textAlignment = .left
        
        headerContainer.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        tableView.tableHeaderView = headerContainer
    }
}

