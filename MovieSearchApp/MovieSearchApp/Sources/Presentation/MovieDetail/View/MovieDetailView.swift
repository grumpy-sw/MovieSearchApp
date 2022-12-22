//
//  MovieDetailView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/21.
//

import UIKit
import SnapKit
import Then

final class MovieDetailView: UIView {
    
    let baseStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let backdropImageView = UIImageView()
    
    let infoView = DetailInfoView()
    let descriptionView = DetailDescriptionView()
    let crewView = DetailCrewView()
    let statusView = DetailStatusView()
    let recommandationView = DetailRecommandationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailView {
    
    private func setSubViews() {
        baseStackView.addArrangedSubview(backdropImageView)
        baseStackView.addArrangedSubview(infoView)
        baseStackView.addArrangedSubview(descriptionView)
        baseStackView.addArrangedSubview(crewView)
        baseStackView.addArrangedSubview(statusView)
        baseStackView.addArrangedSubview(recommandationView)
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func setContent(_ movie: Movie) {
        
    }
}
