//
//  LikeViewController.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LikeViewController: UIViewController {
    private let likeTableView = UITableView()
    private let viewModel = LikeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "내가 찜한 리스트"
        
        view.addSubview(likeTableView)
        likeTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        likeTableView.register(
            ThumbnailTableViewCell.self,
            forCellReuseIdentifier: ThumbnailTableViewCell.id
        )
        likeTableView.delegate = self
        likeTableView.rowHeight = 80
        
        viewModel.output.likeMedias
            .bind(to: likeTableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ThumbnailTableViewCell.id) as? ThumbnailTableViewCell else { return UITableViewCell() }
                
                cell.configrueViewWithLocalData(element)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.output.moveDetail
            .bind(with: self) { owner, media in
                // TODO: Push or Present Detail
            }
            .disposed(by: disposeBag)
        
        viewModel.action(.viewDidLoad)
        
        likeTableView.rx.modelSelected(MovieTable.self)
            .bind(with: self) { owner, media in
                owner.viewModel.action(.modelSelect(media))
            }
            .disposed(by: disposeBag)
    }
}

extension LikeViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, success in
            guard let self else { return }
            viewModel.action(.deleteMedia(indexPath.row))
            success(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
