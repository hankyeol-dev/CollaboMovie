//
//  SearchViewModel.swift
//  CollaborationTMDB
//
//  Created by J Oh on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    private let tmdbRepository: TMDBRepository
    private let disposeBag: DisposeBag
    private let searchPage = BehaviorRelay<Int>(value: 1)
    
    var input = Input()
    var output = Output()
    
    var isLastPage = false
    var searched = BehaviorRelay<Bool>(value: false)
    
    init() {
        self.tmdbRepository = TMDBRepository.shared
        self.disposeBag = DisposeBag()
        transform()
    }
}
    
extension SearchViewModel {
    struct Input {
        var viewDidLoad = PublishRelay<Void>()
        var searchQuery = PublishRelay<String>()
        var loadNextPage = PublishRelay<Void>()
        var movieCellTap = PublishRelay<SearchMedia>()
        var trendCellTap = PublishRelay<HomeMedia>()
    }
    
    struct Output {
        var searchedMovieData = BehaviorRelay<[SearchMedia]>(value: [])
        var trendMovieData = PublishRelay<[HomeMedia]>()
        var movieCellTapData = PublishRelay<DetailViewInput>()
        var trendCellTapData = PublishRelay<DetailViewInput>()
    }
    
    func transform() {
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                owner.fetchTrendData()
            }
            .disposed(by: disposeBag)
        
        input.searchQuery
            .distinctUntilChanged()
            .bind(with: self) { owner, _ in
                owner.searched.accept(false)
            }
            .disposed(by: disposeBag)
        
        input.searchQuery
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, query in
                owner.isLastPage = false
                owner.searched.accept(false)
                owner.fetchSearchData(query: query, page: 1)
            }
            .disposed(by: disposeBag)
        
        input.loadNextPage
            .withLatestFrom(input.searchQuery)
            .filter { [weak self] _ in
                guard let self else { return false }
                return self.isLastPage == false
            }
            .bind(with: self) { owner, query in
                let nextPage = owner.searchPage.value + 1
                owner.searchPage.accept(nextPage)
                owner.fetchSearchData(query: query, page: nextPage)
            }
            .disposed(by: disposeBag)
        
        input.movieCellTap
            .bind(with: self) { owner, movie in
                var detailViewInput: DetailViewInput = .init(
                    id: movie.id,
                    title: movie.title,
                    backdropPath: movie.backdropPath,
                    voteAverage: movie.voteAverage,
                    overview: movie.overview,
                    mediaType: .movie)
                detailViewInput.mapIsSavedMedia()
                owner.output.movieCellTapData.accept(detailViewInput)
            }
            .disposed(by: disposeBag)
        
        input.trendCellTap
            .bind(with: self) { owner, movie in
                var detailViewInput: DetailViewInput = .init(
                    id: movie.id,
                    title: movie.title,
                    backdropPath: movie.backdropPath,
                    voteAverage: movie.voteAverage,
                    overview: movie.overview,
                    mediaType: .movie)
                detailViewInput.mapIsSavedMedia()
                owner.output.trendCellTapData.accept(detailViewInput)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewModel {
    enum Action {
        case viewDidLoad
        case movieCellTap(_ movie: SearchMedia)
        case trendCellTap(_ movie: HomeMedia)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            input.viewDidLoad.accept(())
        case .movieCellTap(let movie):
            input.movieCellTap.accept(movie)
        case .trendCellTap(let movie):
            input.trendCellTap.accept(movie)
        }
    }
}

extension SearchViewModel {
    private func fetchSearchData(query: String, page: Int) {
        tmdbRepository.requestSearchMovie(query: query, page: page)
            .asDriver(onErrorJustReturn: .failure(.badRequest))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let data):
                    let currentData = page == 1 ? [] : owner.output.searchedMovieData.value
                    owner.output.searchedMovieData.accept(currentData + data.results)
                    owner.searched.accept(true)
                    if data.page >= data.totalPage {
                        owner.isLastPage = true
                    }
                case .failure(let error):
                    print("fetchMovie", error)
                    owner.searched.accept(true)
                }
            } onCompleted: { _ in
                print("searchMovie onCompleted")
            } onDisposed: { _ in
                print("searchMovie onDisposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchTrendData() {
        tmdbRepository.requestTrendingMovie()
            .asDriver(onErrorJustReturn: .failure(.badRequest))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let data):
                    owner.output.trendMovieData.accept(data)
                case .failure(let error):
                    print("fetchMovie", error)
                }
            } onCompleted: { _ in
                print("fetchMovie onCompleted")
            } onDisposed: { _ in
                print("fetchMovie onDisposed")
            }
            .disposed(by: disposeBag)
    }
}
