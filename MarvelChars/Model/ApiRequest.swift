//
//  APIRequest.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 19.02.2022.
//

import UIKit
import Alamofire
import CryptoKit

class ApiRequest {
    
    var offset : Int
    var nameStartsWith : String
    var limit : Int
    init(offset : Int, limit: Int = 30, nameStartsWith: String = "") {
        self.limit = limit
        self.offset = offset
        self.nameStartsWith = nameStartsWith
    }
    // parameters for API request
    let baseUrl: String = "https://gateway.marvel.com:443/v1/public/characters"
    let ts: String = String(Date().timeIntervalSince1970)
    let apiKey : String = "6bc760706a50feb51400ffff42782383"
    let privateKey :String = "629391ddc039d9f9615e10b323fb22984f145016"
    var hash : String {
        return MD5(data: "\(ts)\(privateKey)\(apiKey)")
    }
    var parametersForCharacter: [String : Any] {
        if nameStartsWith != ""  {
            return ["apikey": apiKey, "ts": ts, "hash": hash, "limit": limit, "offset": offset, "nameStartsWith": nameStartsWith]
        } else {
            return ["apikey":apiKey,"ts": ts,"hash": hash,"limit": limit,"offset": offset]
        }
    }
    var parametersForComic : [String : Any] {
        return ["apikey": apiKey, "ts": ts, "hash": hash, "limit": limit, "offset": offset]
    }
    // MD5 Conversion
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{String(format: "%02hhx", $0)}.joined()
    }
    // API request for Character
    func fetchCharacter(completionHandler: @escaping (Result<[Character],AFError>) -> Void)  {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        AF.request(baseUrl, parameters: parametersForCharacter).responseDecodable(of: CharacterDataModel.self, decoder: decoder) { response in
            switch response.result {
            case .success(let responseData):
                if let data = responseData.data {
                    if let result = data.results {
                        completionHandler(.success(result))
                    }
                }
            case .failure(let error):
                print("error description -- \(error)")
            }
        }
    }
    // API request for Comic
    func fetchComics(Url: String, onComplete : @escaping (Result<[Comic], AFError>) -> Void){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(Url, parameters: parametersForComic ).responseDecodable(of: ComicDataModel.self, decoder: decoder) { response in
            switch response.result {
            case .success(let responseData):
                if let result = responseData.data?.results {
                    onComplete(.success(result))
                }
            case .failure(let error):
                onComplete(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
}
