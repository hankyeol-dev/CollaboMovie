//
//  DetailViewModel.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/10/24.
//

import Foundation

import RxSwift

final class DetailViewModel {
   private let disposeBag: DisposeBag = .init()
   private let networkRepository: TMDBRepository = .shared
   
   private var detailViewInput: DetailViewInput
   
   struct Input {
      var didLoadInput: PublishSubject<Void> = .init()
      var saveButtonInput: PublishSubject<Void> = .init()
   }
   
   struct Output {
      var didLoadDetailViewOutput: PublishSubject<DetailViewInput> = .init()
      var didLoadCastOutput: PublishSubject<[DetailCastAndDirect]> = .init()
      var didLoadDirectOutput: PublishSubject<[DetailCastAndDirect]> = .init()
      var didLoadSimilarOutput: PublishSubject<[DetailViewInput]> = .init()
      var saveButtonOutput: PublishSubject<Bool> = .init()
   }
   
   var input = Input()
   var output = Output()
   
   init(detailViewInput: DetailViewInput) {
      self.detailViewInput = detailViewInput
      transform()
   }
}

extension DetailViewModel {
   func transform() {
      input
         .didLoadInput
         .bind(with: self) { vm, _ in
            vm.output.didLoadDetailViewOutput.onNext(vm.detailViewInput)
            vm.bindCastAndDirect()
            vm.bindSimilar()
         }
         .disposed(by: disposeBag)
            
      input
         .saveButtonInput
         .subscribe(with: self) { vm, _ in
            vm.validateExistMedia()
         }
         .disposed(by: disposeBag)
   }
}

extension DetailViewModel {
   func bindDidLoad() {
      input.didLoadInput.onNext(())
   }
   
   func bindSaveButtonInput() {
      input.saveButtonInput.onNext(())
   }
   
   private func bindCastAndDirect() {
      guard let mediaType = detailViewInput.mediaType else {
         fetchCastAndDirect(.movie) { [weak self] in
            guard let self else { return }
            fetchCastAndDirect(.tv)
         }
         return
      }
      
      switch mediaType {
      case .movie:
         fetchCastAndDirect(.movie)
      case .tv:
         fetchCastAndDirect(.tv)
      }
   }
   
   private func fetchCastAndDirect(
      _ mediaType: DetailViewInput.MediaType,
      errorHandler: (() -> Void)? = nil
   ) {
      networkRepository.requestCredit(
         mediaId: detailViewInput.id,
         mediaType: mediaType
      ) {
         [weak self] cast, direct in
         guard let self else { return }
         output.didLoadCastOutput.onNext(cast)
         output.didLoadDirectOutput.onNext(direct)
      } errorHandler: { [weak self] in
         guard let self else { return }
         if let errorHandler {
            errorHandler()
         } else {
            output.didLoadCastOutput.onNext([])
            output.didLoadDirectOutput.onNext([])
         }
      }
   }
   
   private func bindSimilar() {
      guard let mediaType = detailViewInput.mediaType else {
         fetchSimilar(.tv) { [weak self] in
            self?.fetchSimilar(.tv)
         }
         return
      }
      
      switch mediaType {
      case .movie:
         fetchSimilar(.movie)
      case .tv:
         fetchSimilar(.tv)
      }
   }
   
   private func fetchSimilar(
      _ mediaType: DetailViewInput.MediaType,
      errorHandler: (() -> Void)? = nil
   ) {
      switch mediaType {
      case .movie:
         networkRepository.requestSimilarMovie(
            movieId: detailViewInput.id
         ) { [weak self] similar in
            guard let self else { return }
            output.didLoadSimilarOutput.onNext(similar)
         } errorHandler: { [weak self] in
            if let errorHandler {
               errorHandler()
            } else {
               self?.output.didLoadSimilarOutput.onNext([])
            }
         }
      case .tv:
         networkRepository.requestSimilarTV(
            seriesId: detailViewInput.id
         ) { [weak self] similar in
            guard let self else { return }
            output.didLoadSimilarOutput.onNext(similar)
         } errorHandler: { [weak self] in
            if let errorHandler {
               errorHandler()
            } else {
               self?.output.didLoadSimilarOutput.onNext([])
            }
         }
      }
   }
   
   private func validateExistMedia() {
      let isExist = DatabaseRepository.existMovie(movieId: detailViewInput.id)
      
      if isExist {
         output.saveButtonOutput.onNext(true)
      } else {
         ImageFileManager.addImage(
            urlString: ImageURL.tmdb(image: detailViewInput.backdropPath).urlString,
            filename: detailViewInput.title
         ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(filePath):
               DispatchQueue.main.async { [weak self] in
                  guard let self else { return }
                  // TODO: DB 스키마 수정으로 -> 로직 수정 필요.
                  DatabaseRepository.addMovie(
                     movie: .init(
                        id: detailViewInput.id,
                        title: detailViewInput.title,
                        imageName: filePath,
                        overview: detailViewInput.overview ?? "",
                        voteAverage: detailViewInput.voteAverage ?? 0.0
                     )
                  )
               }
            case .failure(let failure):
               print(failure)
            }
         }
         output.saveButtonOutput.onNext(false)
      }
   }
}
