//
//  LikeViewModel.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class LikeViewModel {
    private let disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    init() {
        transform()
    }
}

extension LikeViewModel {
    struct Input {
        var viewDidLoad = PublishRelay<Void>()
        var deleteMedia = PublishRelay<Int>()
        var modelSelect = PublishRelay<MovieTable>()
    }
    
    struct Output {
        var likeMedias = PublishRelay<Results<MovieTable>>()
        var moveDetail = PublishRelay<MovieTable>()
    }
}

extension LikeViewModel {
    private func transform() {
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                let medias = DatabaseRepository.movies
                owner.output.likeMedias.accept(medias)
            }
            .disposed(by: disposeBag)
        
        input.deleteMedia
            .bind(with: self) { owner, index in
                let media = DatabaseRepository.movies[index]
                ImageFileManager.removeImage(filename: media.imageName)
                DatabaseRepository.removeMovie(movie: media)
                
                let medias = DatabaseRepository.movies
                owner.output.likeMedias.accept(medias)
            }
            .disposed(by: disposeBag)
        
        input.modelSelect
            .bind(with: self) { owner, data in
                owner.output.moveDetail.accept(data)
            }
            .disposed(by: disposeBag)
    }
}

extension LikeViewModel {
    enum Action {
        case viewDidLoad
        case deleteMedia(_ index: Int)
        case modelSelect(_ data: MovieTable)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            input.viewDidLoad.accept(())
        case .deleteMedia(let index):
            input.deleteMedia.accept(index)
        case .modelSelect(let data):
            input.modelSelect.accept(data)
        }
    }
}
