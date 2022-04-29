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
    @IBOutlet weak var searchBar: UISearchBar!
    //parameter definitions
    private var character = [Character]()
    private let apiRequest = APIRequest(offset: 0), newCharRequest = APIRequest(offset: 30)
    let requestNew = APIRequest(offset: 0, nameStartsWith: "", comicsDetailRequested: true)
    private let activityIndicator = UIActivityIndicatorView()
    private var isPaginating = false
    
    var allCharacters = [MarvelCharacter](), searchedCharacter = [MarvelCharacter]()
    static var  favoriteCharacters = [MarvelCharacter]()
    var searchActive = false
    var favChars = [FavoriteCharacters]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "characterCell")
        
        // assigns protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // initialize UI
        setSearchBarAppearance()
        showSpinner()
        networkRequest(pagination: false)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear called")
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillappear called")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goFavorite))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
            //.init(barButtonSystemItem: .play, target: self, action: #selector(goFavorite))
        
    }
    @objc func goFavorite() {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "FavoriteTableViewController") as! FavoriteTableViewController
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    func setSearchBarAppearance() {
        searchBar.showsCancelButton = false
        searchBar.barTintColor = .black
        searchBar.tintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Search Character"
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        
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
    
   
   
    // spinner configuration function
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
                
                self.configureAllCharacters(with: response)
                self.newCharRequest.offset += 30
                self.isPaginating = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        else {
            apiRequest.fetchDataWrapper(with: apiRequest.parameters) { response in
                self.configureAllCharacters(with: response)
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    func configureAllCharacters(with responseData: [Character]) {
        
        for character in responseData {
            
            if let id = character.id, let name = character.name, let url = character.thumbnail?.url, let description = character.description {
                self.allCharacters.append(MarvelCharacter(id: id, nameOfCharacter: name, characterImageURL: url, description: description, character: character ))
            }
            
            
        }
        
    }
    
}

// MARK: -SearchBar Delegate Functions
extension CharactersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        if let typedName = searchBar.searchTextField.text {
            // call search api function
            searchActive = true
            searchOnMarvel(with: typedName)
        }
        searchBar.searchTextField.text = "Tap cancel to view characters"
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .clear
        searchBar.resignFirstResponder()  // after this line, keyboard should be disappear.
        
 
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        
        searchBar.tintColor = .darkGray
        
        return true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .darkGray
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.tintColor = .clear
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchActive = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text != "" {
            
        } else {
            searchBar.placeholder = "Search Character"
            
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.isUserInteractionEnabled = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchOnMarvel(with name: String) {
        
        let requestForSearch = APIRequest(offset: 0, nameStartsWith: name)
        
        requestForSearch.fetchDataWrapper(with: requestForSearch.parameters) { response in
            if response.isEmpty {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    let alertController = UIAlertController(title: "Oops!", message: "The character you requested is not available", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                        print("cancel tapped")
                        
                    }
                    
                    alertController.addAction(cancelAction)
                   self.present(alertController, animated: true, completion: nil)
                }
                
            }else {
                for item in response {
                    guard let searchedID = item.id, let searchedName = item.name, let url = item.thumbnail?.url, let description = item.description  else {return print("error while searching character") }
                    
                    self.searchedCharacter.append(MarvelCharacter(id: searchedID, nameOfCharacter: searchedName, characterImageURL: url, isStarred: false, description: description, character: item))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
         
        }
        
        searchedCharacter = [MarvelCharacter]()
    }
    
}
// MARK: - TableView Data Source Methods
extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return searchActive ? searchedCharacter.count : allCharacters.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell
        
        cell.delegate = self
        
        cell.marvelCharacter = searchActive ? searchedCharacter[indexPath.row] : allCharacters[indexPath.row]
        
        
        return cell
        
    }
}
//MARK: - TableView Delegate Methods
extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard  let  cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {return}
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        guard let data = cell.marvelCharacter else {return print("error")}
        if let comics = data.character.comics?.items {
            destinationVC.comicsSummary = comics
        }
        
        destinationVC.charLargeImage = cell.charImage
        destinationVC.charName = cell.marvelCharacter?.name
        destinationVC.selectedCharacter = cell.marvelCharacter
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowHeight : CGFloat = 85.0
        
        return rowHeight
    }
    
    // Adding spinner while fetching data when reaching at the end of tableview
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
//MARK: - ScrollView Delegate Functions
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
//MARK: - CharacterCell Delegate Functions
extension CharactersViewController: CharacterCellDelegate {
    
    
    func cellDidTapped(cell: CharacterTableViewCell) {
        // guard let indexPath = tableView.indexPath(for: cell) else {return}
        
    }
    
    func accessoryViewDidTapped(cell: CharacterTableViewCell, isStarred: Bool) {
        
        // guard let indexPath = tableView.indexPath(for: cell) else {return print("error while tapping cell")}
        cell.marvelCharacter?.isStarred = cell.accessoryIsTapped
        cell.accessoryImageView.tintColor = cell.accessoryIsTapped ? .orange : .gray
        
        
        guard let character = cell.marvelCharacter else {return print("error while unwrapping cell character")}
        if cell.accessoryIsTapped {
            if CharactersViewController.favoriteCharacters.contains(character) {
                return
            } else {
                
                
                CharactersViewController.favoriteCharacters.append(character)
            }
            
        } else {
            
            if let index = CharactersViewController.favoriteCharacters.firstIndex(of: character) {
                CharactersViewController.favoriteCharacters.remove(at: index)
            }
        }
        
       
        
    }
    
}







