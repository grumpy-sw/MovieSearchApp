//
//  UIViewController+.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/26.
//

import UIKit

protocol Alertable {}
extension Alertable where Self: UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(
            title: Constants.errorAlertTitle,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: Constants.okActionTitle,
            style: .default
        )
        alertController.addAction(okAction)
        
        if let presentedVC = presentedViewController {
            presentedVC.present(alertController, animated: true, completion: nil)
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}
