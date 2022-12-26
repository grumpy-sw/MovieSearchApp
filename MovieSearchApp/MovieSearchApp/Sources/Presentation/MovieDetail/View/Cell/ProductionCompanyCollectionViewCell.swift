//
//  ProductionCompanyCollectionViewCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/23.
//

import UIKit
import SnapKit
import Then

final class ProductionCompanyCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        String(describing: Self.self)
    }
    
    // MARK: - UI Elements
    private let nameLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
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

extension ProductionCompanyCollectionViewCell {
    private func setSubViews() {
        contentView.addSubview(nameLabel)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(10)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(spacing)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func fill(with company: ProductionCompany) {
        nameLabel.text = company.name
    }
}
