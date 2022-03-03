//
//  ViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 18.02.2022.
//

import UIKit
import Alamofire
import CryptoKit



class CharactersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var displayedCharsInfo = [CharInfoMain]()
    var limitValue = 30
    var offsetValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllChars(with: getParameters(limit: limitValue, offset: offsetValue))
   
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addFooterToTableView()
        }
      
    }
    
    // Adding footer to tableView
    
    func addFooterToTableView () {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width:tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .systemRed
        
        let previousPageButton = UIButton(frame: CGRect(x: 0, y: 0, width: footerView.frame.size.width/2, height: 50))
        previousPageButton.setTitle("Previous", for: .normal)
        previousPageButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        let nextPageButton = UIButton(frame: CGRect(x: footerView.frame.size.width/2, y: 0, width: footerView.frame.size.width/2, height: 50))
        nextPageButton.setTitle("Next", for: .normal)
        nextPageButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        footerView.addSubview(nextPageButton)
        footerView.addSubview(previousPageButton)
        
        tableView.tableFooterView = footerView
        
    }
    // Button Actions for TableView's FooterView
    @objc func nextTapped() {
        //limitValue = 0
        offsetValue += 30
        print("limit value ->\(limitValue)\toffsetvalue ->\(offsetValue)")
        
        fetchAllChars(with: getParameters(limit: limitValue, offset: offsetValue))
        
    }
    @objc func previousTapped() {
        //limitValue -= 30
        offsetValue -= 30
        fetchAllChars(with: getParameters(limit: limitValue, offset: offsetValue))
        
    }
    
    // MARK: - API request
    
    let url = "https://gateway.marvel.com:443/v1/public/characters"
    
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{String(format: "%02hhx", $0)}.joined()
    }
    func getParameters (limit: Int, offset: Int) -> [String: Any] {
        let apiKey = "6bc760706a50feb51400ffff42782383"
        let privateKey = "629391ddc039d9f9615e10b323fb22984f145016"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data:"\(ts)\(privateKey)\(apiKey)")
        return  ["apikey":apiKey,"ts": ts,"hash": hash,"limit": limit,"offset": offset]
    }
    func fetchAllChars(with input : [String: Any]) {
        
        AF.request(url, parameters: getParameters(limit: limitValue, offset: offsetValue)).validate().responseDecodable(of: CharacterDataWrapper.self) { (response) in
            guard let charDatas = response.value?.data?.results else { return }
            
            for (_,item) in charDatas.enumerated() {
                
                if let id = item.id, let name = item.name, let thumbnail = item.thumbnail, let descript = item.description, let comics = item.comics {
                    
                    let data = CharInfoMain(charId: id, charName: name, charImage: thumbnail, description: descript, comics: comics)
                    self.displayedCharsInfo.append(data)
                    
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
}

//MARK: - TableView Data Source Methods

extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayedCharsInfo.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CharacterTableViewCell
        
        cell.charNameLabel.text = displayedCharsInfo[indexPath.row].charName
        
        // image API request
        
        AF.request(displayedCharsInfo[indexPath.row].charImage.url!,method: .get).response { response in
            
            switch response.result {
                
            case .success(let responseData):
                cell.charImageView.image = UIImage(data: responseData!, scale:1)
                
                           
                
            case .failure(let error):
                print("error once getting image",error)
            }
        }
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate Methods

extension CharactersViewController: UITableViewDelegate {
    
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        destinationVC.selectedCharacter = displayedCharsInfo[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
//      performSegue(withIdentifier: "segueForDetails", sender: self)
        
     }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueForDetails" {
//            let destinationVC = segue.destination as! DetailsViewController
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//
//
//                destinationVC.isim = "ilker"
//                print(destinationVC.isim as Any)
//
//            }
//        }
//
//
//    }

}







