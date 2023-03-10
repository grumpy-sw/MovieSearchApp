//
//  DetailRecommendationView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailRecommendationView: UIView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    private let noRecommendationsLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailRecommendationView {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(280), heightDimension: .absolute(186))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 80, trailing: 20)
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: TitleSupplementaryView.titleElementKind, alignment: .topLeading)
            
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func setSubViews() {
        addSubview(collectionView)
        addSubview(noRecommendationsLabel)
        noRecommendationsLabel.isHidden = true
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(spacing)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        noRecommendationsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.top).inset(80)
            $0.leading.trailing.equalToSuperview().inset(spacing)
        }
    }
    
    func showNoRecommendations(for title: String) {
        noRecommendationsLabel.text = "We don't have enough data to suggest any movies based on \(title)."
        noRecommendationsLabel.isHidden = false
    }
}
