//
//  SearchHistoryCell.swift
//  BookLog
//
//  Created by 박현렬 on 5/9/24.
//

import UIKit
import SnapKit
import Then

class ViewHistoryCell: UICollectionViewCell {
    
    static let identifier = "ViewHistoryCell"
    
    let historyLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        contentView.addSubview(historyLabel)
        
        historyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(with history: String) {
        historyLabel.text = history
    }
}
