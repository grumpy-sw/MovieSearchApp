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
    private let imageView = UIImageView()
    private let nameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // MARK: - Class Properties
    private var company: ProductionCompany!
    private var logoImageRepository: ImageRepository?
    
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
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(10)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.55)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func fill(with company: ProductionCompany, logoImageRepository: ImageRepository?) {
        self.company = company
        self.logoImageRepository = logoImageRepository
        
        nameLabel.text = company.name
        updateImage()
    }
    
    private func updateImage() {
        self.imageView.image = nil
        guard let logoPath = company?.logoPath, !logoPath.isEmpty else {
            return
        }
        
        logoImageRepository?.fetchImage(with: logoPath, width: Constants.logoWidth) { [weak self] result in
            if case let .success(data) = result {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

fileprivate extension Constants {
    static let logoWidth = 154
}

