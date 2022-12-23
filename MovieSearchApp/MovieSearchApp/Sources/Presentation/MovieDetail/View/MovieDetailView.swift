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
    let recommendationView = DetailRecommendationView()
    
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
        //baseStackView.addArrangedSubview(backdropImageView)
        //baseStackView.addArrangedSubview(infoView)
        //baseStackView.addArrangedSubview(descriptionView)
        //baseStackView.addArrangedSubview(crewView)
        baseStackView.addArrangedSubview(crewView)
        //baseStackView.addArrangedSubview(statusView)
        baseStackView.addArrangedSubview(recommendationView)
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        baseStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setContent(_ movie: MovieDetail) {
        //infoView.setContent(movie.title, movie.releaseDate, movie.runtime, movie.genres, movie.posterPath, movie.voteAverage)
        descriptionView.setContent(movie.tagline, movie.overview)
        //statusView.setContent(movie.status, movie.originalLanguage, movie.budget, movie.revenue)
    }
}
