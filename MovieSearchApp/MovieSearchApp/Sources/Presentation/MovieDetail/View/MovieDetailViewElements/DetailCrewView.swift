//
//  DetailCrewView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailCrewView: UIView {
    let productionStaticLabel = UILabel()
    lazy var productionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createProductionLayout())
    
    let castStaticLabel = UILabel()
    lazy var castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCastLayout())
    
    let crewStaticLabel = UILabel()
    lazy var crewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCrewLayout())
}

extension DetailCrewView {
    private func createProductionLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func createCastLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func createCrewLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
}
