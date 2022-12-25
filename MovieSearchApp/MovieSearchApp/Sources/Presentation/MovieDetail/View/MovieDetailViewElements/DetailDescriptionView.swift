//
//  DetailDescriptionView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailDescriptionView: UIView {
    
    private let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
    }
    private let taglineLabel = UILabel().then {
        $0.font = .italicPreferredFont(for: .body)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    private let overviewStaticLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.text = "Overview"
    }
    private let overviewLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
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

extension DetailDescriptionView {
    private func setSubViews() {
        baseStackView.addArrangedSubview(taglineLabel)
        baseStackView.addArrangedSubview(overviewStaticLabel)
        baseStackView.addArrangedSubview(overviewLabel)
        
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(spacing)
        }
    }
    
    func setContent(_ tagline: String, _ overview: String) {
        taglineLabel.text = tagline
        overviewLabel.text = overview
    }
}
