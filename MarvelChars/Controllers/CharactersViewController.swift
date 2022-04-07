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
import CoreData


class CharactersViewController: UIViewController{
    // outlet definitions
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    //parameter definitions
    
    private var characters = [Character]()
    private var totalChar = Int(), callCount = Int()
    private let apiRequest = APIRequest(offset: 0), newCharRequest = APIRequest(offset: 30)
    private let activityIndicator = UIActivityIndicatorView()
    private var isPaginating = false
    
    var favoriteCharacters = [CharacterManager]()
    var allCharacters = [CharacterManager]()
    
    var favChars = [FavoriteCharacters]()
    
    var tappedIndexPath: IndexPath?
    var favoriteIndexArray = [Int]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // assigns protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        favoriteSwitch.isOn = false
        
        // initialize UI
        showSpinner()
        networkRequest(pagination: false)
        
    }
    
    //    func loadFavoriteCharacters() {
    //
    //        let request : NSFetchRequest<FavoriteCharacters> = FavoriteCharacters.fetchRequest()
    //
    //        do {
    //            favChars =  try context.fetch(request)
    //        } catch {
    //
    //            print("error occurred while loading favorite character to UI, error definition \(error)")
    //        }
    //
    //        tableView.reloadData()
    //
    //    }
    //    func saveFavorites(){
    //        do {
    //            try context.save()
    //        }
    //        catch {
    //            print("error occured while saving new character, error definition \(error)")
    //        }
    //
    //        self.tableView.reloadData()
    //
    //
    //    }
    
    
    @IBAction func favoriteSwitchToggled(_ sender: UISwitch) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
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
                //self.characters.append(contentsOf: response)
                
                for item in response {
                    
                    self.allCharacters.append(CharacterManager(character: item, isStarred: false))
                }
                self.newCharRequest.offset += 30
                self.isPaginating = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        else {
            apiRequest.fetchDataWrapper(with: apiRequest.parameters) { response in
                // self.characters.append(contentsOf: response)
                
                for item in response {
                    
                    self.allCharacters.append(CharacterManager(character: item, isStarred: false))
                }
                
                
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
        
        if favoriteSwitch.isOn {
            return favoriteCharacters.count
        } else {
            return allCharacters.count
        }
        
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterTableViewCell
        
        print("Hello")
        if favoriteSwitch.isOn {
            cell.characterManager = favoriteCharacters[indexPath.row]
        } else {
            cell.characterManager = allCharacters[indexPath.row]
        }
        
        //cell.accessoryView?.tintColor = allCharacters[indexPath.row].isStarred ? .orange : .gray
        cell.delegate = self
        
        print("Bye bye")
        
        return cell
        
    }
}

//MARK: - TableView Delegate Methods

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        guard  let  cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {return}
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        if let summmary = allCharacters[indexPath.row].character.comics?.items {
            destinationVC.comicsSummary = summmary
        }
        destinationVC.charLargeImage = cell.charImage
        destinationVC.selectedCharacter = allCharacters[indexPath.row].character
        navigationController?.pushViewController(destinationVC, animated: true)
        self.tappedIndexPath = indexPath
        self.tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var rowHeight : CGFloat = 85.0
     
        return rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if (indexPath.section ==  lastSectionIndex) && (indexPath.row == lastRowIndex) {
            
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            tableView.tableFooterView = spinner
            
            if favoriteSwitch.isOn {
                tableView.tableFooterView?.isHidden = true
            } else{
                tableView.tableFooterView?.isHidden = false
            }
            
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
extension CharactersViewController: CharacterCellDelegate {
    
    
    func cellDidTapped(cell: CharacterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        
    }
    
    func accessoryViewDidTapped(cell: CharacterTableViewCell, isStarred: Bool) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        
        allCharacters[indexPath.row].isStarred = !allCharacters[indexPath.row].isStarred
        
        
        cell.accessoryView?.tintColor = self.allCharacters[indexPath.row].isStarred ? .orange : .gray
        
        favoriteCharacters = allCharacters.filter{ $0.isStarred == true }
        let  nonfavorite = allCharacters.filter{ $0.isStarred == false }
        
        
        print("fav\(favoriteCharacters.count) - nonfav\(nonfavorite.count) ")
        
        
        
        
    }
}








