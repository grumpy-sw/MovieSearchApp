//
//  CrewCollectionViewCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/23.
//

import Foundation

import UIKit

final class CrewCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    
    let jobLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
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

extension CrewCollectionViewCell {
    func setSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobLabel)
    }
    
    func setLayoutConstraints() {
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
