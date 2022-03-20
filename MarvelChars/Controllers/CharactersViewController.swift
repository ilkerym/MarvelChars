//
//  ViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 18.02.2022.
//

import UIKit
import Alamofire
import AlamofireImage
import CryptoKit

class CharactersViewController: UIViewController{
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let apiRequest = APIRequest(offset: 0)
    private var character = [Character]()
    private let alert = UIAlertController(title: "Please wait", message: "Loading Characters", preferredStyle: .alert)
    
   private var totalChar = Int()
   private var callCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // assigns protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.async {
            self.present(self.alert, animated: true, completion: nil)
            self.activityIndicator.startAnimating()
            
        }
        
        networkRequest()
        
    }
    
    
    private func networkRequest() {
        apiRequest.fetchDataWrapper(with: apiRequest.parameters) { [self] response in
            
            guard let data = response.data else {return print("error while getting Wrapper")}
            
            callCount = data.count!   // The total number of results returned by this call
            totalChar = data.total!   // The total number of Characters
           
            for offset in stride(from:0, through: totalChar, by: 100) {
                
                let request = APIRequest(offset: offset)
                
                request.fetchDataWrapper(with: request.parameters) {  response in
                    
                    guard let data = response.data else {return print("error while getting Wrapper") }
                    
                    let newCharacters = data.results!
                    print(newCharacters.last?.name! as Any)
                    self.character.append(contentsOf: newCharacters)
                    
                    if character.count == totalChar {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            alert.dismiss(animated: true, completion: nil)
                            activityIndicator.stopAnimating() // stop animating after getting characters
                            activityIndicator.hidesWhenStopped = true
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
}

// MARK: - TableView Data Source Methods

extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return character.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterTableViewCell
        
        let selectedRow = character[indexPath.row]
        
        cell.character = selectedRow
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate Methods

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard  let  cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {return}
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        print(character[indexPath.row].comics?.urlComics as Any)
        if let summmary = character[indexPath.row].comics?.items {
            destinationVC.comicsSummary = summmary
        }
        destinationVC.charLargeImage = cell.charImage
        destinationVC.selectedCharacter = character[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        
        
    }
    
    
}







