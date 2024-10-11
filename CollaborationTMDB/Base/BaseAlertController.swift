//
//  BaseAlertController.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class BaseAlertController: UIViewController {
   private let disposeBag = DisposeBag()
   var alertMessage: String?
   var alertAction: (() -> Void)?
   
   private let box: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.layer.cornerRadius = 10.0
      view.clipsToBounds = true
      return view
   }()
   private let message: UILabel = {
      let view = UILabel()
      view.font = .systemFont(ofSize: 15.0, weight: .regular)
      view.textColor = .black
      view.textAlignment = .center
      view.numberOfLines = 0
      return view
   }()
   private let button = RoundedButton(
      foregroundColor: .white, backgroundColor: .baseRed, title: "확인")

   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .black.withAlphaComponent(0.6)
      configureHierachy()
      configureLayout()
      bindButtonAction()
      message.text = alertMessage
   }
   
   private func configureHierachy() {
      view.addSubview(box)
      box.addSubviews(message, button)
   }
   
   private func configureLayout() {
      box.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.width.equalTo(350.0)
      }
      message.snp.makeConstraints { make in
         make.top.equalTo(box.safeAreaLayoutGuide).inset(20.0)
         make.horizontalEdges.equalTo(box.safeAreaLayoutGuide).inset(15.0)
      }
      button.snp.makeConstraints { make in
         make.top.equalTo(message.snp.bottom).offset(20.0)
         make.horizontalEdges.bottom.equalTo(box.safeAreaLayoutGuide).inset(15.0)
         make.height.equalTo(45.0)
      }
   }

   private func bindButtonAction() {
      button.rx.tap
         .bind(with: self) { vc, _ in
            vc.alertAction?()
         }
         .disposed(by: disposeBag)
   }
}
