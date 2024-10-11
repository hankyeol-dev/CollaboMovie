//
//  SearchHeader.swift
//  CollaborationTMDB
//
//  Created by J Oh on 10/10/24.
//

import UIKit
import SnapKit

final class SearchHeader: UICollectionReusableView {
    static let id = "SearchHeader"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(with title: String) {
        titleLabel.text = title
    }
}
