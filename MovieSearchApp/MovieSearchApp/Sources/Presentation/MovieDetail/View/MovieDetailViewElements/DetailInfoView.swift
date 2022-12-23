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
    
    let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
    }
    
    let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textColor = .white
    }
    let infoLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.textColor = .white
    }
    let genreLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.textColor = .white
    }
    
    let userScoreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .trailing
    }
    
    let userScoreStaticLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.text = "User Score"
        $0.textAlignment = .right
        $0.textColor = .white
    }
    
    let userScoreStaticImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
    }
    
    let userScoreLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.textAlignment = .right
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cornflowerBlue
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailInfoView {
    private func setSubViews() {
        userScoreStackView.addArrangedSubview(userScoreStaticLabel)
        userScoreStackView.addArrangedSubview(userScoreStaticImageView)
        userScoreStackView.addArrangedSubview(userScoreLabel)
        
        baseStackView.addArrangedSubview(titleLabel)
        baseStackView.addArrangedSubview(infoLabel)
        baseStackView.addArrangedSubview(genreLabel)
        addSubview(userScoreStackView)
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        
        baseStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(spacing)
        }
        
        userScoreStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.trailing.equalToSuperview().inset(spacing)
        }
    }
    
    func setContent(_ title: String, _ releaseDate: String, _ runtime: Int, _ genres: [Genre], _ posterPath: String, _ vote: Double) {
        titleLabel.text = title
        infoLabel.text = "\(releaseDate) · \(runtime) m"
        genreLabel.text = genres.map{ $0.id.desciption }.joined(separator: ", ")
        userScoreLabel.text = String(Int(vote * 10)) + "%"
    }
    

}
