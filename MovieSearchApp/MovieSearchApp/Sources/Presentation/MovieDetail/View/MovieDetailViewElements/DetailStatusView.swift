//
//  DetailStatusView.swift
//  MovieSearchApp
//
//  Created by 박세웅 on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailStatusView: UIView {
    
    private lazy var baseStackView = verticalStackView(20)
    
    private lazy var statusStackView = verticalStackView(5)
    private lazy var statusStaticLabel = staticLabel("Status")
    private lazy var statusLabel = variableLabel()
    
    private lazy var originalLanguageStackView = verticalStackView(5)
    private lazy var originalLanguageStaticLabel = staticLabel("Original Language")
    private lazy var originalLanguageLabel = variableLabel()
    
    private lazy var budgetStackView = verticalStackView(5)
    private lazy var budgetStaticLabel = staticLabel("Budget")
    private lazy var budgetLabel = variableLabel()
    
    private lazy var revenueStackView = verticalStackView(5)
    private lazy var revenueStaticLabel = staticLabel("Revenue")
    private lazy var revenueLabel = variableLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailStatusView {
    
    private func verticalStackView(_ spacing: CGFloat) -> UIStackView {
        return UIStackView().then {
            $0.axis = .vertical
            $0.spacing = spacing
            $0.distribution = .fillEqually
        }
    }
    
    private func staticLabel(_ text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = .preferredFont(for: .body, weight: .bold)
        }
    }
    
    private func variableLabel() -> UILabel {
        return UILabel().then {
            $0.font = .preferredFont(forTextStyle: .body)
        }
    }
    
    private func setSubViews() {
        statusStackView.addArrangedSubview(statusStaticLabel)
        statusStackView.addArrangedSubview(statusLabel)
        originalLanguageStackView.addArrangedSubview(originalLanguageStaticLabel)
        originalLanguageStackView.addArrangedSubview(originalLanguageLabel)
        budgetStackView.addArrangedSubview(budgetStaticLabel)
        budgetStackView.addArrangedSubview(budgetLabel)
        revenueStackView.addArrangedSubview(revenueStaticLabel)
        revenueStackView.addArrangedSubview(revenueLabel)
        
        baseStackView.addArrangedSubview(statusStackView)
        baseStackView.addArrangedSubview(originalLanguageStackView)
        baseStackView.addArrangedSubview(budgetStackView)
        baseStackView.addArrangedSubview(revenueStackView)
        
        addSubview(baseStackView)
    }
    
    private func setLayoutConstraints() {
        let spacing = CGFloat(20)
        baseStackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(spacing)
        }
    }
    
    func setContent(_ status: String, _ originalLanguage: String, _ budget: Int, _ revenue: Int) {
        
    }
}
