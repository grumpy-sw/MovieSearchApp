//
//  MoviesListItemCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/20.
//

import UIKit
import SnapKit
import Then

final class MoviesListItemCell: UICollectionViewListCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    // MARK: - UI Elements
    private let baseStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.layer.masksToBounds = false
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: Constants.defaultPosterImage)
    }
    
    private let baseLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.numberOfLines = 2
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    // MARK: - Class Properties
    private var movieCard: MovieCard!
    private var posterImageRepository: ImageRepository?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviesListItemCell {
    func setSubViews() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(releaseDateLabel)
        baseLabelStackView.addArrangedSubview(titleStackView)
        baseLabelStackView.addArrangedSubview(overviewLabel)
        
        baseStackView.addArrangedSubview(imageView)
        baseStackView.addArrangedSubview(baseLabelStackView)
        
        contentView.addSubview(baseStackView)
    }
    
    func setLayoutConstraints() {
        let innerSpacing = CGFloat(15)
        let spacing = CGFloat(20)
        let imgWidthRatio = 0.25
        
        baseLabelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(spacing)
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(innerSpacing)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(innerSpacing)
        }
        
        
        baseStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(spacing / 2)
        }
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(imgWidthRatio)
        }
    }
    
    func fill(with movieCard: MovieCard, posterImageRepository: ImageRepository?) {
        self.movieCard = movieCard
        self.posterImageRepository = posterImageRepository
        
        titleLabel.text = movieCard.title
        releaseDateLabel.text = movieCard.releaseDate
        overviewLabel.text = movieCard.overview
        updateImage()
    }
    
    private func updateImage() {
        self.imageView.image = UIImage(named: Constants.defaultPosterImage)
        
        guard !movieCard.posterPath.isEmpty else {
            return
        }
        
        posterImageRepository?.fetchImage(with: movieCard.posterPath, width: Constants.posterWidth) { [weak self] result in
            if case let .success(data) = result {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

fileprivate extension Constants {
    static let posterWidth = 200
}
