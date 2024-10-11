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
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> SingleOutput {
        let result = input.query
            .distinctUntilChanged()
            .flatMap { [weak self] query in
                guard let self else { return Single<SearchMovieResponseDTO>.never() }
                return self.requestSearchSingle(query: query, page: 1)
                    .catch { _ in
                        return Single<SearchMovieResponseDTO>.never()
                    }
            }
            .asDriver(onErrorJustReturn: SearchMovieResponseDTO(page: 1, results: [], totalPage: 1))
            .debug("Query changed")
        
        return SingleOutput(movieList: result)
    }
    
    private func requestSearchSingle(query: String, page: Int) -> Single<SearchMovieResponseDTO> {
        return Single.create { observer in
            TMDBRepository.shared.requestSearch(query: query, page: page) { result in
                switch result {
                case .success(let success):
                    observer(.success(success))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
        .debug("requestSearchSingle")
    }
}
 
extension SearchViewModel {
    struct Input {
        let query: ControlProperty<String>
    }
    
    struct SingleOutput {
        let movieList: Driver<SearchMovieResponseDTO>
    }
}

extension SearchMovieResponseDTO: Sequence {
    func makeIterator() -> Array<TMDBMovieResponseDTO>.Iterator {
        return results.makeIterator()
    }
}
