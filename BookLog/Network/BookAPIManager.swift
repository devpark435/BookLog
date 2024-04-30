//
//  BookApiManager.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import Foundation
import Alamofire

class BookAPIManager{
    
    static let shared = BookAPIManager()
    let REST_API_KEY = ""
    
    private init(){}
    
    func searchBookData(esearchText: String, completion: @escaping (Result<SearchBookModel, Error>) -> Void){
        let url = "https://dapi.kakao.com/v3/search/book"
        
        let headers : HTTPHeaders = [
            "Authorization" : "KakaoAK \(REST_API_KEY)"
        ]
    }
    
}

