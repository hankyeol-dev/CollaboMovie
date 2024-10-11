//
//  BaseAlertBuilder.swift
//  CollaborationTMDB
//
//  Created by 강한결 on 10/11/24.
//

import UIKit

final class BaseAlertBuilder {
   private let viewController: UIViewController
   private let alertController: BaseAlertController
   
   private var message: String?
   private var alertAction: (() -> Void)?
   
   init(
      viewController: UIViewController,
      alertController: BaseAlertController = .init()
   ) {
      self.viewController = viewController
      self.alertController = alertController
   }
   
   func setMessage(_ message: String) -> BaseAlertBuilder {
      self.message = message
      return self
   }
   
   func setAction(
      action: (() -> Void)? = nil
   ) -> BaseAlertBuilder {
      alertAction = action
      return self
   }
   
   func displayAlert() {
      alertController.modalPresentationStyle = .overFullScreen
      alertController.modalTransitionStyle = .crossDissolve
      
      alertController.alertMessage = message
      alertController.alertAction = alertAction
      
      viewController.present(alertController, animated: true)
   }
}
