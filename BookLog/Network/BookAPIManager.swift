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
    let REST_API_KEY = Bundle.main.apiKey
    
    private init(){}
    
    func searchBookData(esearchText: String, page: Int, completion: @escaping (Result<SearchBookModel, Error>) -> Void){
        let url = "https://dapi.kakao.com/v3/search/book"
        
        let headers : HTTPHeaders = [
            "Authorization" : "KakaoAK \(REST_API_KEY)"
        ]
        
        let parameters : [String: Any] = [
            "query": esearchText,
            "page": page
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: SearchBookModel.self) { response in
            switch response.result{
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

