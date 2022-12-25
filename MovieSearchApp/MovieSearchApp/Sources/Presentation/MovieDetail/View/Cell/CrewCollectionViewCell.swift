//
//  CrewCollectionViewCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/23.
//

import UIKit
import SnapKit
import Then

final class CrewCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    // MARK: - UI Elements
    private let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
    }
    private let nameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    private let jobLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
    private func setSubViews() {
        baseStackView.addArrangedSubview(nameLabel)
        baseStackView.addArrangedSubview(jobLabel)
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func fill(with crew: Crew) {
        nameLabel.text = crew.name
        jobLabel.text = crew.job
    }
}
