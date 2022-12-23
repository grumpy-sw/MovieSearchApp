//
//  RecommendationSupplementaryView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/23.
//

import UIKit
import SnapKit
import Then

final class RecommendationSupplementaryView: UICollectionReusableView {
    static let RecommendationElementKind = "recommendation-element-kind"
    private let label = UILabel().then {
        $0.text = "Recommendation"
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .title3)
    }
    static let reuseIdentifier = "title-recommendation-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendationSupplementaryView {
    private func setSubViews() {
        addSubview(label)
    }
    
    private func setLayoutConstraints() {
        let inset = CGFloat(10)
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(inset)
            $0.bottom.trailing.equalToSuperview().inset(-inset)
        }
    }
}
