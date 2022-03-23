//
//  APIRequest.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 19.02.2022.
//

import UIKit
import Alamofire
import CryptoKit
import SwiftUI

final class APIRequest {
    
    var offset : Int
    
    init(offset : Int ) {
        self.offset = offset
    }
    
    let url = "https://gateway.marvel.com:443/v1/public/characters"
    let apiKey = "6bc760706a50feb51400ffff42782383"
    let privateKey = "629391ddc039d9f9615e10b323fb22984f145016"
    let ts  = String(Date().timeIntervalSince1970)
    var limit = 30
    var hash : String {
        return MD5(data:"\(ts)\(privateKey)\(apiKey)")
    }
    
    // parameters for API request
    var parameters: [String : Any] {
        return ["apikey":apiKey,"ts": ts,"hash": hash,"limit": limit,"offset": offset]
    }
    // MD5 Conversion
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{String(format: "%02hhx", $0)}.joined()
    }
    // function for API request
    func fetchDataWrapper(with input : [String: Any], completionHandler: @escaping ([Character]) -> Void)  {
            
            AF.request(url, parameters: parameters).responseDecodable(of: CharacterDataWrapper.self) { response in
                switch response.value {
                    
                case .none:
                    print("error while fetching Character Data Wrapper")
                case .some(let wrapper):
                    if let characterDatas = wrapper.data?.results {
                        completionHandler(characterDatas)
                    }
                    
                }
            }
    
    }

}


