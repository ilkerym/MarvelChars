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
    let requestForComics = APIRequest(offset: 0)
    private let activityIndicator = UIActivityIndicatorView()
    private var isPaginating = false
    private var searchActive = false
    var allCharacters = [AllCharacter]()
    var searchedCharacter = [AllCharacter]()
    
    static var favoriteCharacters = [AllCharacter]()
    
    var favorite = AllCharacter()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let request : NSFetchRequest<AllCharacter> = AllCharacter.fetchRequest()
    var predicateForSearch : NSPredicate? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "characterCell")
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // assigns protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // initialize UI
        setSearchBarAppearance()
        loadAllCharacters()
        if allCharacters.isEmpty {
            showSpinner()
            networkRequest(pagination: false)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillappear called")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goFavorite))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        loadAllCharacters(with: request, predicate: predicateForSearch)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear called")
        
        
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
                
                
            }
        }
        else {
            apiRequest.fetchDataWrapper(with: apiRequest.parameters) { response in
                self.configureAllCharacters(with: response)
                DispatchQueue.main.async {
                    self.removeSpinner()
                    // self.tableView.reloadData()
                }
            }
        }
        
    }
    func configureAllCharacters(with characters: [Character]) {
        
        for item in characters {
            
            if let id = item.id, let name = item.name, let imageUrl = item.thumbnail?.url, let description = item.description {
                
                
                let newCharacter = AllCharacter(context: self.context)
                newCharacter.id = Int64(id)
                newCharacter.charName = name
                newCharacter.isStarred = false
                newCharacter.imageURL = imageUrl
                newCharacter.charDescription = description
                newCharacter.searched = false
                allCharacters.append(newCharacter)
                
                saveAllCharacters()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }
    //MARK: - CRUD Functions
    
    //Create or Save Character
    
    func saveAllCharacters() {
        
        do {
            try  context.save()
        }
        catch {
            print("error occured while saving data , error definition \(error)")
        }
        
        
    }
    
    
    
    
    
    // READ from DB
    func loadAllCharacters(with request: NSFetchRequest<AllCharacter> = AllCharacter.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let predicateSearchOff = NSPredicate(format: "searched = %d", false)
        let predicateSearchOn = NSPredicate(format: "searched = %d", true)
        
        if let additionalpredicate = predicate {
            print("aadditional workss")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateSearchOn,additionalpredicate])
        } else {
            
            print("default workss")
            request.predicate = predicateSearchOff
        }
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "charName", ascending: true)]
        
        
        //            request.predicate = searchActive ? predicateSearchOn : predicateSearchOff
        
        do {
            
            allCharacters =  try context.fetch(request)
            
            
        } catch {
            
            print("error occurred while loading all characters to UI, error definition \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}

// MARK: -SearchBar Delegate Functions
extension CharactersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        if let typedName = searchBar.searchTextField.text {
            
            searchActive = true

            predicateForSearch = NSPredicate(format: "charName  BEGINSWITH[c]  %@ ", typedName)
            
            loadAllCharacters(with: request, predicate: predicateForSearch)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("searchedCharacter.count---\(allCharacters.count)")
            
            // all characters returned here are searched characters filtering via predicate
            if allCharacters.isEmpty {
                // call search api function
                searchOnMarvel(with: typedName)
            }
            
            if !searchActive {
                predicateForSearch = nil // if predicate here different from nil when going back from favorites view controller, character VC loads all characters, it doesn't matter true or false
            }
            
            
            
        }
        
        searchBar.searchTextField.text = "Tap cancel for all characters"
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
        loadAllCharacters()
        
        
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
                for character in response {
                    guard let searchedID = character.id, let searchedName = character.name, let searchedURL = character.thumbnail?.url, let searchedDescription = character.description  else {return print("error while searching character") }
                    
                    let newCharacter = AllCharacter(context: self.context)
                    newCharacter.id = Int64(searchedID)
                    newCharacter.charName = searchedName
                    newCharacter.isStarred = false
                    newCharacter.charDescription = searchedDescription
                    newCharacter.imageURL = searchedURL
                    newCharacter.searched = true  // searched character
                    self.allCharacters.append(newCharacter)
                    self.saveAllCharacters()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
// MARK: - TableView Data Source Methods
extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return allCharacters.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell
        
        cell.delegate = self
        cell.marvelCharacter = allCharacters[indexPath.row]
        
        return cell
        
    }
}
//MARK: - TableView Delegate Methods
extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard  let  cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {return}
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        guard let character = cell.marvelCharacter else {return print("error")}
        destinationVC.charLargeImage = cell.charImage // Due to the size of image different, I take image from cell
        destinationVC.charName = character.charName
        destinationVC.charDescription = character.charDescription
        
        
        
        navigationController?.pushViewController(destinationVC, animated: true)
        
        print(character.id)
        
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
        
        //      guard let indexPath = tableView.indexPath(for: cell) else {return print("error while tapping cell")}
        cell.marvelCharacter?.isStarred = isStarred
        cell.accessoryImageView.tintColor = cell.accessoryIsTapped ? .orange : .gray
        
        saveAllCharacters()
        CharactersViewController.favoriteCharacters = allCharacters.filter{ $0.isStarred == true}
        
        
        
    }
    
}



