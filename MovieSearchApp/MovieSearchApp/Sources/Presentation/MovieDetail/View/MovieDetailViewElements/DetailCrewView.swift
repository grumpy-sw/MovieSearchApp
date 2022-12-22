//
//  DetailCrewView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailCrewView: UIView {
    
    private let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    lazy var productionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createProductionLayout())
    
    lazy var castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCastLayout())
    
    lazy var crewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCrewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailCrewView {
    private func createProductionLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func createCastLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func createCrewLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout.init()
    }
    
    private func setSubViews() {
        baseStackView.addArrangedSubview(productionCollectionView)
        baseStackView.addArrangedSubview(castCollectionView)
        baseStackView.addArrangedSubview(crewCollectionView)
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(spacing)
        }
    }
    
    func setContent(_ productionCompanies: [ProductionCompany], _ credits: CreditsDTO) {
        
    }
}
