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
    
    var charId : Int
    var charName : String
    var charImage : Image
    var description : String
    var comics : ComicList
}

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var displayedCharsInfo = [CharInfo]()
    var marvelChars = [Character]()
    var selectedCharacter : CharInfo?
    var imageURL : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        getAllChars()
    }
    
    let url = "https://gateway.marvel.com:443/v1/public/characters"
    
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{String(format: "%02hhx", $0)}.joined()
        
    }
    
    func parameters (limit: Int = 100, offset: Int = 0) -> [String: Any] {
        let apiKey = "6bc760706a50feb51400ffff42782383"
        let privateKey = "629391ddc039d9f9615e10b323fb22984f145016"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data:"\(ts)\(privateKey)\(apiKey)")
        return  ["apikey":apiKey,"ts": ts,"hash": hash,"limit": limit,"offset": offset]
    }
    func getAllChars() {
        AF.request(url, parameters: parameters(limit: 1, offset: 0)).validate().responseDecodable(of: CharacterDataWrapper.self) { (response) in
            guard let numberOfTotalChar = response.value?.data?.total
            else {return}
            self.getCharacters(totalCharacters: numberOfTotalChar)
        }
    }
    func getCharacters(totalCharacters: Int){
        var offset = 0
        var requestedCharacters = 0
        
        //        while (requestedCharacters <= totalCharacters) {
        AF.request(url, parameters: parameters(limit: 30, offset: offset)).validate().responseDecodable(of: CharacterDataWrapper.self) { (response) in
            guard let apiResponse = response.value?.data?.results
            else {return}
            
            self.marvelChars.append(contentsOf: apiResponse)
            
            for (_,item) in self.marvelChars.enumerated() {
                
                var data = CharInfo(charId: item.id ?? 0 , charName: item.name ?? "", charImage: item.thumbnail!, description: item.description!, comics: item.comics!)
                
                
                
                self.displayedCharsInfo.append(data)
                
                print(data.charImage.url)
                
            }
            
            self.tableView.reloadData()
            
            //            }
            //            offset += 100
            //            requestedCharacters += 100
            
            
        }
        
    }
    
}
//MARK: - TV Data Source Methods

extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayedCharsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CharacterTableViewCell
        
        cell.charNameLabel.text = displayedCharsInfo[indexPath.row].charName
        
        
        guard let imageURL = displayedCharsInfo[indexPath.row].charImage.url else { return cell }
        
        cell.charImageView.load(url: imageURL)
        
        
        return cell
        
    }
    
    
    
}



//MARK: - Char TableView Delegate Methods

extension CharactersViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueForDetails", sender: self)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.charInfoForDetails = displayedCharsInfo[indexPath.row]
            
        }
    }

    
 
    
}







