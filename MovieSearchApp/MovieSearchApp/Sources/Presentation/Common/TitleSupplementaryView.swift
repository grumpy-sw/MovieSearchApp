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
    private let label = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(for: .title3, weight: .bold)
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
    private func setSubViews() {
        addSubview(label)
    }
    
    private func setLayoutConstraints() {
        let inset = CGFloat(10)
        label.snp.makeConstraints {
            $0.top.equalToSuperview().inset(inset)
            $0.bottom.equalToSuperview().inset(-inset)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setTitleLabel(_ title: String) {
        self.label.text = title
    }
    
    func setTitleLabel(_ title: String, _ font: UIFont) {
        setTitleLabel(title)
        label.font = font
    }
}
