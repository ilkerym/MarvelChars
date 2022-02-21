//
//  ViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 18.02.2022.
//

import UIKit
import Alamofire
import CryptoKit

struct CharInfo {
    var charId = [Int]()
    var charName = [String]()
    var charImage = [Image]()
}

class CharactersViewController: UIViewController {
   
    var marvelChars = CharInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let apiKey = "6bc760706a50feb51400ffff42782383"
        let privateKey = "629391ddc039d9f9615e10b323fb22984f145016"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data:"\(ts)\(privateKey)\(apiKey)")
       // let baseURL = "https://gateway.marvel.com:443/v1/public/characters"
        let url = "https://gateway.marvel.com:443/v1/public/characters?ts=\(ts)&apikey=\(apiKey)&hash=\(hash)"
        //let parameters: Parameters = ["apikey": apiKey,"ts": ts,"hash": hash]
        func MD5(data: String) -> String {
            let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
            return hash.map{String(format: "%02hhx", $0)}.joined()
            
        }
        
        AF.request(url).responseDecodable(of: CharacterDataWrapper.self) { response in
            if let error = response.error {
                print(error)
            } else {
                if let jsonData = response.value{
                    
                    guard let data = jsonData.data?.results else {return print(response.error!)}
                    
//                    for (index, item) in data.enumerated() {
//
//                        self.marvelChars.charName.append(item.name!)
//                        self.marvelChars.charId.append(item.id!)
//                        self.marvelChars.charImage.append(item.thumbnail!)
//
//                    }
                    print(data.count)
                
            }
            
        }
        
        
       
    }
    
        
}





//                    let decoder = JSONDecoder()
//                    guard let json = try? decoder.decode(CharacterDataWrapper.self, from: response.data!) else { print("Unable to parse JSON"); return }


//        func performRequest(with urlString: String) {
//            if let url = URL(string: urlString ) {
//                let session = URLSession(configuration: .default)
//                let task = session.dataTask(with: url) { (data, response, error) in
//                    if error != nil {
//                        print(error)
//                        return
//                    }
//                    if let safeData = data {
//                        if let character = self.parseJSON(safeData) {
//                            print(character.id)
//                            print(character.name)
//                        }
//                    }
//                }
//                task.resume()
//            }
//        }
//
//        performRequest(with: url)


//    func parseJSON(_ jsonData: Data) -> CharInfo? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(CharacterDataWrapper.self, from: jsonData)
//            let id = decodedData.data?.results![0].id
//            let name = (decodedData.data?.results![0].name)!
//            let charImage = decodedData.data?.results![0].thumbnail?.url
//            let char = CharInfo(id: id!, name: name, charImage: charImage!)
//
//            return char
//
//        } catch {
//            print(error)
//            return nil
//        }
//
    }
