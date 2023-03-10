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
        $0.contentInsetAdjustmentBehavior = .never
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
        
        contentView.addArrangedSubview(castView)
        contentView.addArrangedSubview(crewView)
        contentView.addArrangedSubview(productionView)
        contentView.addArrangedSubview(recommendationView)
        contentView.addArrangedSubview(statusView)
        
        baseScrollView.addSubview(contentView)
        addSubview(baseScrollView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
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
            $0.height.equalTo(250)
            $0.top.equalToSuperview() // Top
        }

        infoView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(backdropView.snp.bottom).offset(spacing)
        }

        descriptionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(infoView.snp.bottom).offset(spacing)
        }
        
        castView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.46)
            $0.top.equalTo(descriptionView.snp.bottom).offset(spacing)
        }
        
        crewView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(castView.snp.bottom).offset(spacing)
        }
        
        productionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(crewView.snp.bottom).offset(spacing)
        }
        
        recommendationView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.38)
            $0.top.equalTo(productionView.snp.bottom).offset(spacing)
        }
        
        statusView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(recommendationView.snp.bottom).offset(spacing)
            $0.bottom.equalToSuperview() // Bottom
        }
    }
    
    func setContent(_ movie: MovieDetail) {
        infoView.setContent(movie.title, movie.releaseDate, movie.runtime, movie.genres, movie.posterPath, movie.voteAverage)
        descriptionView.setContent(movie.tagline, movie.overview)
        statusView.setContent(movie.status, movie.originalLanguage, movie.budget, movie.revenue)
        
        if !movie.productionCompanies.isEmpty {
            productionView.setContentHeight(rows: (movie.productionCompanies.count))
        }
        
        if let recommendations = movie.recommendations {
            if recommendations.movies.isEmpty {
                recommendationView.showNoRecommendations(for: movie.title)
            }
        }
        
        guard let crew = movie.credits?.crew else {
            return
        }
        crewView.setContentHeight(rows: (crew.count + 1) / 2)
    }
    
    func updateBackdropImage(with image: Data?) {
        backdropView.updateBackdropImage(image)
    }
}
