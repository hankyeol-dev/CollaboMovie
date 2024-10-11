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
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: SearchViewController.layout())
        view.delegate = self
        view.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: VerticalCollectionViewCell.id)
        view.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeader.id)
        return view
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        rxBind()
    }
    
}

// RxBind
extension SearchViewController {
    private func rxBind() {
        let input = SearchViewModel.Input(query: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.movieList
            .drive(collectionView.rx.items(cellIdentifier: VerticalCollectionViewCell.id, cellType: VerticalCollectionViewCell.self)) { (row, movie, cell) in
                cell.configureData(movie.posterPath)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(TMDBMovieResponseDTO.self)
            .subscribe(with: self, onNext: { owner, movie in
                // 디테일뷰
                
            })
            .disposed(by: disposeBag)
    }
}

// CollectionView
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeader.id, for: indexPath) as! SearchHeader
        header.setTitle(with: "영화 & 시리즈")
        return header
    }
}

extension SearchViewController {
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
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
}

