//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/15.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        title = "MovieSearchApp"
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: nil)
    }


}

