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

class SearchListCell: UICollectionViewCell{
        
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
            $0.numberOfLines = 3
        }
        
        let status = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = .gray
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    func setupUI(){
        contentView.addSubview(thumbnail)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(publisher)
        contentView.addSubview(price)
        contentView.addSubview(salePrice)
        contentView.addSubview(contents)
        contentView.addSubview(status)
        
        thumbnail.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(thumbnail.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        author.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.equalTo(title.snp.leading)
        }
        
        publisher.snp.makeConstraints {
            $0.top.equalTo(author.snp.bottom).offset(10)
            $0.leading.equalTo(title.snp.leading)
        }
        
        price.snp.makeConstraints {
            $0.top.equalTo(publisher.snp.bottom).offset(10)
            $0.leading.equalTo(title.snp.leading)
        }
        
        salePrice.snp.makeConstraints {
            $0.top.equalTo(price.snp.bottom).offset(10)
            $0.leading.equalTo(title.snp.leading)
        }
        
        contents.snp.makeConstraints {
            $0.top.equalTo(salePrice.snp.bottom).offset(10)
            $0.leading.equalTo(title.snp.leading)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        status.snp.makeConstraints {
            $0.top.equalTo(contents.snp.bottom).offset(10)
            $0.leading.equalTo(title.snp.leading)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureCell(book: Book){
        title.text = book.title
        author.text = book.authors.map{String($0)}.joined(separator: ", ")
        publisher.text = book.publisher
        price.text = String(book.price)
        salePrice.text = String(book.salePrice == -1 ? book.price : book.salePrice)
        contents.text = book.contents
        status.text = book.status
        
        if let url = URL(string: book.thumbnail){
            thumbnail.kf.setImage(with: url)
        }
    }
}
