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
    // outlet definitions
    @IBOutlet weak var tableView: UITableView!
    
    //parameter definitions
    private var character = [Character]()
    private var totalChar = Int(), callCount = Int()
    private let apiRequest = APIRequest(offset: 0), newCharRequest = APIRequest(offset: 30)
    private let activityIndicator = UIActivityIndicatorView()
    private var isPaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // assigns protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        // initialize UI
        showSpinner()
        networkRequest(pagination: false)
        
    }
    // spinner functions
    private func showSpinner() {
        activityIndicator.frame = self.view.bounds
        activityIndicator.style = .large
        activityIndicator.color = .black
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        
    }
    private func removeSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    // API request function
    private func networkRequest(pagination: Bool) {
        
        if pagination  {
            if pagination {
                isPaginating = true
            }
            newCharRequest.fetchDataWrapper(with: newCharRequest.parameters) { response in
                self.character.append(contentsOf: response)
                self.isPaginating = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        else {
            apiRequest.fetchDataWrapper(with: apiRequest.parameters) { response in
                self.character.append(contentsOf: response)
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.tableView.reloadData()
                }
            }
        }

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
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if (indexPath.section ==  lastSectionIndex) && (indexPath.row == lastRowIndex) {
           
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            
        }
    }
    
    
}
//MARK: - ScrollView Delegate
extension CharactersViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 50 - scrollView.frame.size.height) {
            
            guard !isPaginating else {
                // already fethcing data
                
                return
            }
            networkRequest(pagination: true)
            
        }
    }
    
    
    
}







