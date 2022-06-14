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
    private let charRequest = ApiRequest(offset: 0), newCharRequest = ApiRequest(offset: 30)
    private let activityIndicator = UIActivityIndicatorView()
    private var isPaginating = false
    private var searchActive = false
    private var allCharacters = [AllCharacter]()
    private var searchedCharacter = [AllCharacter]()
    
    static var favoriteCharacters = [AllCharacter]()
    
    private var favorite : AllCharacter?
    
    public let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let request : NSFetchRequest<AllCharacter> = AllCharacter.fetchRequest()
    private var predicateForSearchOn : NSPredicate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "characterCell")
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // assigns protocols to ViewController
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // initialize UI
        setSearchBarAppearance()
        //Read from Database
        loadAllCharacters()
        if allCharacters.isEmpty {
            showSpinner()
            networkRequest(pagination: false)
        }
  
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goFavorite))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        if !searchActive {
            predicateForSearchOn = nil // if predicate here is different from nil, by the time going back from favorites view controller, character VC loads all characters, it doesn't matter that characters are favorites or not
            loadAllCharacters()
        } else {
            loadAllCharacters(with: request, predicate: predicateForSearchOn)
        }
        
        
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
        activityIndicator.hidesWhenStopped = true
    }
    // API request function
    private func networkRequest(pagination: Bool) {
        
        if pagination  {
            if pagination {
                isPaginating = true
            }
            newCharRequest.fetchCharacter() { response in
                switch response {
                    
                case .success(let data):
                    self.configureAllCharacters(with: data)
                    self.newCharRequest.offset += 30
                    self.isPaginating = false
                case .failure(let error):
                    print(error)
                }
  
            }
        }
        else {
            charRequest.fetchCharacter() { response in
                print("charRequest.offset\(self.charRequest.offset)")
                switch response {
                    
                case .success(let data):
                    self.configureAllCharacters(with: data)
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        // self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
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
                newCharacter.imgUrl = imageUrl
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
        
        let predicateForSearchOff = NSPredicate(format: "searched = %d", false)
        let predicateForSearchOn = NSPredicate(format: "searched = %d", true)
        
        if let additionalpredicate = predicate {
            print("aadditional workss")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateForSearchOn,additionalpredicate])
        } else {
            
            print("default workss")
            request.predicate = predicateForSearchOff
        }
       // request.sortDescriptors = [NSSortDescriptor(key: "charName", ascending: true)]
        do {
            allCharacters =  try context.fetch(request)
        } catch {
            print("error occurred while loading all characters to UI, error definition \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: -SearchBar Delegate Functions
extension CharactersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = true

        if let typedName = searchBar.searchTextField.text {

            predicateForSearchOn = NSPredicate(format: "charName  BEGINSWITH[c]  %@", typedName)
            loadAllCharacters(with: request, predicate: predicateForSearchOn)
            // all characters returned here are "searched characters" filtered by predicate
            if allCharacters.isEmpty {
                // call search api function
                searchOnMarvel(with: typedName)
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
        searchActive = true
        searchBar.isUserInteractionEnabled = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchOnMarvel(with name: String) {
        let requestForSearch = ApiRequest(offset: 0, nameStartsWith: name)
        requestForSearch.fetchCharacter() { response in
            switch response {
            case .success(let data):
                if data.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        let alertController = UIAlertController(title: "Oops!", message: "The Character you requested is not available", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                            print("cancel tapped")
                        }
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }else {
                    for character in data {
                        guard let searchedID = character.id, let searchedName = character.name, let searchedURL = character.thumbnail?.url, let searchedDescription = character.description  else {return print("error while unwrapping searching character") }
                        
                        let newCharacter = AllCharacter(context: self.context)
                        newCharacter.id = Int64(searchedID)
                        newCharacter.charName = searchedName
                        newCharacter.isStarred = false
                        newCharacter.charDescription = searchedDescription
                        newCharacter.imgUrl = searchedURL
                        newCharacter.searched = true  // searched character
                        self.allCharacters.append(newCharacter)
                        self.saveAllCharacters()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print(error)
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
        cell.character = allCharacters[indexPath.row]
        return cell
    }
}
//MARK: - TableView Delegate Methods
extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard  let  cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {return}
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
    
        if let character = cell.character {
            destinationVC.charLargeImage = cell.charImageView.image // Because the size of image is different, I take image from cell
            destinationVC.characterId = Int(character.id)
            destinationVC.charName = character.charName
            destinationVC.charDescription = character.charDescription
            let comicUrl = "https://gateway.marvel.com/v1/public/characters/\(character.id)/comics"
            destinationVC.urlForComics = comicUrl
        }
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight : CGFloat = 85.0
        return rowHeight
    }
    // Add spinner while fetching data, by the time reaching at the end of the tableview
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
        if let character = cell.character {
            character.isStarred = isStarred
        }
        cell.accessoryView?.tintColor = cell.accessoryIsTapped ? .orange : .gray
        CharactersViewController.favoriteCharacters = allCharacters.filter{ $0.isStarred == true}
        saveAllCharacters()
    }
}



