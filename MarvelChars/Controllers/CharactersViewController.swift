//
//  ViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 18.02.2022.
//

import UIKit
import Alamofire
import SDWebImage
import CryptoKit

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let previousPageButton = UIButton()
    private let nextPageButton = UIButton()
    private let footerView = UIView()
    private let networkRequest = NetworkRequest()
    var character = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assigning protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest.fetchAllChars(with: networkRequest.getParameters(limit: networkRequest.limitValue, offset: networkRequest.offsetValue, ts: networkRequest.ts)) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let data):
                self.character = data as! [Character]
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addFooterToTableView()
        }
        
    }
    
    //MARK: - Adding footer to tableView
    
    private func addFooterToTableView () {
        
        // FooterView Configuration
        footerView.frame = CGRect(x: 0, y: 0, width:tableView.frame.size.width, height: 50)
        footerView.backgroundColor = .black
        
        // Previous Page button configuration
        previousPageButton.frame = CGRect(x: 0, y: 0, width: footerView.frame.size.width/2, height: 50)
        previousPageButton.setTitle("Previous", for: .normal)
        previousPageButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        // Next Page button configuration
        nextPageButton.frame = CGRect(x: footerView.frame.size.width/2, y: 0, width: footerView.frame.size.width/2, height: 50)
        nextPageButton.setTitle("Next", for: .normal)
        nextPageButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        footerView.addSubview(nextPageButton)
        footerView.addSubview(previousPageButton)
        
        tableView.tableFooterView = footerView
        
    }
    //MARK: - Button Actions for TableView's FooterView
    
    @objc func nextTapped() {
        
        character = []
        networkRequest.offsetValue += 30
        print("limit value ->\(networkRequest.limitValue)\toffsetvalue ->\(networkRequest.offsetValue)")
        
        networkRequest.fetchAllChars(with: networkRequest.getParameters(limit: networkRequest.limitValue, offset: networkRequest.offsetValue, ts: networkRequest.ts)) { result in
            
            
            switch result {
            case .failure(let err):
                print(err.localizedDescription)
            case.success(let data):
                self.character = data as! [Character]
                self.tableView.reloadData()
            }
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
        }
        
        
    }
    
    @objc func previousTapped() {
        if networkRequest.offsetValue <= 0 {
            previousPageButton.isSelected = false
            return
            
        } else {
            character = []
            networkRequest.offsetValue -= 30
            
            networkRequest.fetchAllChars(with: networkRequest.getParameters(limit: networkRequest.limitValue, offset: networkRequest.offsetValue, ts: networkRequest.ts)) { result in
                switch result {
                case .failure(let err):
                    print(err.localizedDescription)
                case.success(let data):
                    self.character = data as! [Character]
                    
                    self.tableView.reloadData()
                }
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)            }
        }
        
        
    }
}


//MARK: - TableView Data Source Methods

extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return character.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CharacterTableViewCell
        
        let selectedRow = character[indexPath.row]
        
        cell.configureCell(with: selectedRow)
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate Methods

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {return}
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if let summmary = character[indexPath.row].comics?.items {
            destinationVC.comicsSummary = summmary
        }
        
        destinationVC.selectedCharacter = character[indexPath.row]
        destinationVC.charImage = cell.charImageView.image
        
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
}







