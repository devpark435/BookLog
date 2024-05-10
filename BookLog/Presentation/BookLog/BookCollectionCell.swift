//
//  BookCollectionCell.swift
//  BookLog
//
//  Created by 박현렬 on 5/9/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class BookCollectionCell: UICollectionViewCell {
    static let identifier = "BookCell"
    
    let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .white
        $0.textAlignment = .center
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
        self.layer.cornerRadius = 16
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    func setupLayout() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        
        bookImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with book: BookEntityModel) {
        bookImageView.kf.setImage(with: URL(string: book.thumbnail))
        titleLabel.text = book.title
    }
}
