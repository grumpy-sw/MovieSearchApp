//
//  DetailRecommandationView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailRecommandationView: UIView {
    let recommandationStaticLabel = UILabel()
    lazy var recommandationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createRecommandationLayout())
}

extension DetailRecommandationView {
    private func createRecommandationLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
}
