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
    var selectedCharacter : CharInfoMain?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllChars()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addFooterToTableView()
        }

    }
    
    // Adding footer to tableView
    
    func addFooterToTableView () {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width:tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .lightGray
        
        let previousPageButton = UIButton(frame: CGRect(x: 0, y: 0, width: footerView.frame.size.width/2, height: 50))
        previousPageButton.setTitle("Previous", for: .normal)
        
        //previousPageButton.addTarget(self, action: Selector(("previousTapped")), for: .touchUpInside)
        
        let nextPageButton = UIButton(frame: CGRect(x: footerView.frame.size.width/2, y: 0, width: footerView.frame.size.width/2, height: 50))
        nextPageButton.setTitle("Next", for: .normal)
        
        // nextPageButton.addTarget(self, action: Selector(("nextTapped")), for: .touchUpInside)
        
        footerView.addSubview(nextPageButton)
        footerView.addSubview(previousPageButton)
        tableView.tableFooterView = footerView
        
    }
    
    // API request
    let url = "https://gateway.marvel.com:443/v1/public/characters"
    
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{String(format: "%02hhx", $0)}.joined()
        
    }
    
    func parameters (limit: Int = 30, offset: Int = 0) -> [String: Any] {
        let apiKey = "6bc760706a50feb51400ffff42782383"
        let privateKey = "629391ddc039d9f9615e10b323fb22984f145016"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data:"\(ts)\(privateKey)\(apiKey)")
        return  ["apikey":apiKey,"ts": ts,"hash": hash,"limit": limit,"offset": offset]
    }
    func fetchAllChars() {
        AF.request(url, parameters: parameters(limit: 30, offset: 0)).validate().responseDecodable(of: CharacterDataWrapper.self) { (response) in
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
        print("hello--->\(displayedCharsInfo.count)")
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "segueForDetails", sender: self)
        
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        return 70
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
      
        tableView.footerView(forSection: section)
    }

    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let destinationVC = segue.destination as! DetailsViewController
    //        if let indexPath = tableView.indexPathForSelectedRow {
    //            destinationVC.charInfoForDetails = displayedCharsInfo[indexPath.row]
    //
    //        }
    //    }
    
    
    
    
}







