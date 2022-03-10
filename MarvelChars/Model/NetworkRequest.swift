//
//  NetworkRequest.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 19.02.2022.
//

import UIKit
import Alamofire
import CryptoKit

class NetworkRequest {
    
    let url = "https://gateway.marvel.com:443/v1/public/characters"
    let ts = String(Date().timeIntervalSince1970)
    var limitValue = 100
    var offsetValue = 0
    
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{String(format: "%02hhx", $0)}.joined()
    }
    func getParameters (limit: Int , offset: Int, ts: String ) -> [String: Any] {
        let apiKey = "6bc760706a50feb51400ffff42782383"
        let privateKey = "629391ddc039d9f9615e10b323fb22984f145016"
        let hash = MD5(data:"\(ts)\(privateKey)\(apiKey)")
        return  ["apikey":apiKey,"ts": ts,"hash": hash,"limit": limit,"offset": offset]
    }
    func fetchAllChars(with input : [String: Any], completion: @escaping (Result<Any, AFError>) -> Void) {
        
        AF.request(url, parameters: getParameters(limit: limitValue, offset: offsetValue, ts: ts)).validate().responseDecodable(of: CharacterDataWrapper.self) { response in
            
            switch response.result {
                
            case .success(let charDatas):
                completion(.success((charDatas.data?.results)!))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }

        }
        
    }
    
}



