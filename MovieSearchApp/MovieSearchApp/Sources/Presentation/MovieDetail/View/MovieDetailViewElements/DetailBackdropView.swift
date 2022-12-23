//
//  DetailBackdropView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/24.
//

import UIKit
import SnapKit
import Then

final class DetailBackdropView: UIView {
    
    private let backdropImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailBackdropView {
    private func setSubViews() {
        addSubview(backdropImageView)
    }
    
    private func setLayoutConstraints() {
        backdropImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func updateBackdropImage(_ image: Data?) {
        guard let image = image else {
            return
        }
        backdropImageView.image = UIImage(data: image)
    }
}
