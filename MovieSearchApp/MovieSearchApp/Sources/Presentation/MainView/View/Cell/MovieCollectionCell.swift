//
//  MovieCollectionCell.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/19.
//

import UIKit

final class MovieCollectionCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    // MARK: - UI Elements
    private let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.backgroundColor = UIColor.cornflowerBlue
    }
    private let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    private let genreLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    
    // MARK: - Class Properties
    private var moviePage: MoviePage!
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

extension MovieCollectionCell {
    private func setSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(10)
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(spacing * 2)
            $0.bottom.equalToSuperview().offset(-spacing)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(spacing)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func fill(with moviePage: MoviePage, posterImageRepository: ImageRepository?) {
        self.moviePage = moviePage
        self.posterImageRepository = posterImageRepository
        
        titleLabel.text = moviePage.title
        genreLabel.text = moviePage.genreIds.compactMap{ GenreCategory(rawValue: $0) }.map{ $0.desciption }.joined(separator: ",")
        updateImage()
    }
    
    private func updateImage() {
        self.imageView.image = nil
        
        guard !moviePage.posterPath.isEmpty else {
            return
        }
        
        posterImageRepository?.fetchImage(with: moviePage.posterPath, width: Constants.posterWidth) { [weak self] result in
            if case let .success(data) = result {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

fileprivate extension Constants {
    static let posterWidth = 300
}
