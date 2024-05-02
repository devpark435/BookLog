//
//  SearchListCell.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit
import SnapKit
import Kingfisher
import Then

class SearchListCell: UITableViewCell{
        
        static let identifier = "SearchListCell"
        
        let thumbnail = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        }
        
        let title = UILabel().then {
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.numberOfLines = 0
            $0.text = "Title"
        }
        
        let author = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = .gray
        }
        
        let publisher = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = .gray
        }
        
        let price = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = .gray
        }
        
        let salePrice = UILabel().then {
            $0.font = UIFont.boldSystemFont(ofSize: 15)
            $0.textColor = .red
        }
        
        let contents = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = .gray
            $0.numberOfLines = 0
        }
        
        let status = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = .gray
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    func setupUI(){
        contentView.addSubview(thumbnail)
        contentView.addSubview(title)
//        contentView.addSubview(author)
//        contentView.addSubview(publisher)
//        contentView.addSubview(price)
//        contentView.addSubview(salePrice)
//        contentView.addSubview(contents)
//        contentView.addSubview(status)
        
        thumbnail.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(thumbnail.snp.top)
            $0.leading.equalTo(thumbnail.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
}
