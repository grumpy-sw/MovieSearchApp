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
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = UIColor.cornflowerBlue
    }
    
    private let baseLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }
    
    private let overviewLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 3
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

extension MoviesListItemCell {
    func setSubViews() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(releaseDateLabel)
        baseLabelStackView.addArrangedSubview(titleStackView)
        baseLabelStackView.addArrangedSubview(overviewLabel)
        
        contentView.addSubview(imageView)
        contentView.addSubview(baseLabelStackView)
    }
    
    func setLayoutConstraints() {
        let spacing = CGFloat(20)
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(spacing)
            $0.width.equalToSuperview().multipliedBy(0.25)
        }
        
        baseLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview().inset(spacing)
        }
    }
    
    func updateImage(_ posterPath: String) {
        self.imageView.image = nil
        let provider = APIProvider()
        let endpoint = EndpointStorage.fetchImageAPI(posterPath, 200).endpoint
        provider.request(endpoint: endpoint) { [weak self] result in
            if case let .success(data) = result {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func updateCell(with Item: Movie) {
        guard let posterPath = Item.posterPath else {
            return
        }
        updateImage(posterPath)
        titleLabel.text = Item.title
        releaseDateLabel.text = Item.releaseDate
        overviewLabel.text = Item.overview
        
    }
}
