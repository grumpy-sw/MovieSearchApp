//
//  TitleSupplementaryView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import UIKit
import SnapKit
import Then

final class TitleSupplementaryView: UICollectionReusableView {
    static let titleElementKind = "title-element-kind"
    let label = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .title3)
    }
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleSupplementaryView {
    func setSubViews() {
        addSubview(label)
    }
    
    func setLayoutConstraints() {
        let inset = CGFloat(10)
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(inset)
            $0.bottom.trailing.equalToSuperview().inset(-inset)
        }
    }
}
