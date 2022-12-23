//
//  CastCollectionViewCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/23.
//

import UIKit
import SnapKit
import Then

final class CastCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    let imageView = UIImageView()
    let nameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    let characterLabel = UILabel().then {
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

extension CastCollectionViewCell {
    func setSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
    }
    
    func setLayoutConstraints() {
        let spacing = CGFloat(10)
        
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.55)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        characterLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func updateImage(_ posterPath: String) {
        self.imageView.image = nil
        let provider = APIProvider()
        let endpoint = EndpointStorage.fetchImageAPI(posterPath, 200).endpoint
        provider.request(endpoint: endpoint) { [weak self] result in
            if case let .success(data) = result {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
