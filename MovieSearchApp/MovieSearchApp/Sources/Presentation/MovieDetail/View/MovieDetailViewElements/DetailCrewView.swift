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
    
    private let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    lazy var productionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createProductionLayout())
    
    lazy var castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCastLayout())
    
    lazy var crewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCrewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailCrewView {
    private func createProductionLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func createCastLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 80, trailing: 20)
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: RecommendationSupplementaryView.recommendationElementKind, alignment: .topLeading)
            
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func createCrewLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func setSubViews() {
        //baseStackView.addArrangedSubview(productionCollectionView)
        baseStackView.addArrangedSubview(castCollectionView)
        //baseStackView.addArrangedSubview(crewCollectionView)
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func setContent(_ productionCompanies: [ProductionCompany], _ credits: Credits) {
        
    }
}
