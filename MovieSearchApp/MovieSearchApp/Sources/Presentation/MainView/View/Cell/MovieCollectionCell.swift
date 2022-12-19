//
//  MovieCollectionCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import Foundation
import UIKit

final class MovieCollectionCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    let imageView = UIImageView().then {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.backgroundColor = UIColor.cornflowerBlue
    }
    let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.adjustsFontForContentSizeCategory = true
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

extension MovieCollectionCell {
    func setSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    func setLayoutConstraints() {
        let spacing = CGFloat(10)
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
}

extension UIColor {
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}
