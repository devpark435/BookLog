//
//  SearchBookModel.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import Foundation

struct SearchBookModel: Decodable {
    let meta: Meta
    let documents: [Book]
}

struct Meta: Decodable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

struct Book: Decodable {
    let authors: [String]
    let contents: String
    let datetime: String
    let isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String
    let review: String?
    
    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher, status, thumbnail, title, translators, url, review
        case salePrice = "sale_price"
    }
}
