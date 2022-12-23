//
//  DetailInfoView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailInfoView: UIView {
    
    let baseLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
    }
    
    let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    let infoLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
    }
    let genreLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
    }
    
    let basePosterStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
    }
    
    let posterImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.backgroundColor = UIColor.cornflowerBlue
    }
    
    let userScoreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    let userScoreStaticLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.text = "User Score"
    }
    
    let userScoreStaticImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
    }
    
    let userScoreLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
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

extension DetailInfoView {
    private func setSubViews() {
        baseLabelStackView.addArrangedSubview(titleLabel)
        baseLabelStackView.addArrangedSubview(infoLabel)
        baseLabelStackView.addArrangedSubview(genreLabel)
        
        userScoreStackView.addArrangedSubview(userScoreStaticLabel)
        userScoreStackView.addArrangedSubview(userScoreStaticImageView)
        userScoreStackView.addArrangedSubview(userScoreLabel)
        
        basePosterStackView.addArrangedSubview(posterImageView)
        basePosterStackView.addArrangedSubview(userScoreStackView)
        addSubview(baseLabelStackView)
        addSubview(basePosterStackView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        
        baseLabelStackView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(spacing)
        }
        
        basePosterStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(spacing)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(spacing * 2)
        }
    }
    
    func setContent(_ title: String, _ releaseDate: String, _ runtime: Int, _ genres: [Genre], _ posterPath: String, _ vote: Double) {
        titleLabel.text = title
        infoLabel.text = "\(releaseDate) | \(runtime) m"
        genreLabel.text = genres.map{ $0.id.desciption }.joined(separator: ", ")
        userScoreLabel.text = String(Int(vote * 10))
    }
    
    func updatePosterImage(_ image: Data?) {
//        guard let image = image else {
//            return
//        }
//        posterImageView.image = UIImage(data: image)
    }
}
