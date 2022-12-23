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
    
    let baseScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    
    let contentView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let backdropView = DetailBackdropView()
    let infoView = DetailInfoView()
    let descriptionView = DetailDescriptionView()
    let productionView = DetailProductionView()
    let castView = DetailCastView()
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
        contentView.addArrangedSubview(backdropView)
        contentView.addArrangedSubview(infoView)
        contentView.addArrangedSubview(descriptionView)
        contentView.addArrangedSubview(productionView)
        contentView.addArrangedSubview(castView)
        contentView.addArrangedSubview(crewView)
        contentView.addArrangedSubview(statusView)
        contentView.addArrangedSubview(recommendationView)
        
        baseScrollView.addSubview(contentView)
        addSubview(baseScrollView)
    }
    
    private func setLayoutConstraints() {
        baseScrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.width.equalTo(self)
        }
        
        backdropView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
            $0.top.equalTo(contentView) // Top
        }

        infoView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        descriptionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        productionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        castView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(390)
        }
        
        crewView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
            $0.leading.trailing.equalToSuperview()
        }
        
        statusView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(270)
        }
        
        recommendationView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)
            $0.bottom.equalTo(contentView) // Bottom
        }
    }
    
    func setContent(_ movie: MovieDetail) {
        infoView.setContent(movie.title, movie.releaseDate, movie.runtime, movie.genres, movie.posterPath, movie.voteAverage)
        descriptionView.setContent(movie.tagline, movie.overview)
        statusView.setContent(movie.status, movie.originalLanguage, movie.budget, movie.revenue)
    }
    
    func updateBackdropImage(with image: Data?) {
        backdropView.updateBackdropImage(image)
    }
}
