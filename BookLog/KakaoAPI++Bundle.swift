//
//  KakaoAPI++Bundle.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import Foundation

extension Bundle{
    
    var apiKey: String {
        guard let file = self.path(forResource: "KakaoPlist", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let apiKey = resource["API_KEY"] as? String else { fatalError("KakaoPlist에 API_KEY를 등록해주세요.") }
        
        return apiKey
    }
}
