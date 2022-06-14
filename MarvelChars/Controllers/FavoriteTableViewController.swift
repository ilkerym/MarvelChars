//
//  FavoriteTableViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 26.04.2022.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {
    
    // Outlet Parameter Definitions
    @IBOutlet var favoriteTableView: UITableView!
    // Other Parameter Definitions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var favorites = CharactersViewController.favoriteCharacters
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        navigationItem.title = "Favorites"
        navigationItem.leftBarButtonItem?.tintColor = .black
        //Read from Database
        loadFavorites()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
    }
    //MARK: - Core Data CRUD Functions
    
    func saveFavorites() {
        do {
            try  context.save()
        }
        catch {
            print("error occured while saving data , error definition \(error)")
        }
    }
    func loadFavorites() {
        let request : NSFetchRequest<AllCharacter> = AllCharacter.fetchRequest()
        let predicate = NSPredicate(format: "isStarred = %d", true)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "charName", ascending: true)]
        
        do {
            favorites =  try context.fetch(request)
        } catch {
            print("error occurred while loading favorite character to UI, error definition \(error)")
        }
        favoriteTableView.reloadData()
    }
    // MARK: -  TableView Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  favorites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        cell.delegate = self
        // Configure the cell...
        cell.favoriteCharacter = favorites[indexPath.row]
        return cell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight : CGFloat = 85.0
        return rowHeight
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard  let  cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell else {return}
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        guard let character = cell.favoriteCharacter else {return print("error")}
        destinationVC.charLargeImage = cell.favCharImageView.image
        destinationVC.charName = character.charName
        destinationVC.charDescription = character.charDescription
        
        let comicUrl = "https://gateway.marvel.com/v1/public/characters/\(character.id)/comics"
        destinationVC.urlForComics = comicUrl
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favorites[indexPath.row].isStarred = false
            //Save DB
            saveFavorites()
            //Remove from array
            favorites.remove(at: indexPath.row)
            // Remove from UI
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
//MARK: - FavoriteCellDelegate Methods
extension FavoriteTableViewController : FavoriteCellDelegate {
    func accessoryViewDidTapped(cell: FavoriteTableViewCell, isStarred: Bool) {
        
        guard let character = cell.favoriteCharacter else {return print("error while unwrapping cell character")}
        let alert = UIAlertController(title: "Warning!", message: "The character will be removed from favorites. Would you like to continue ? ", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            print("cancel tapped")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { deleteAction in
            character.isStarred = false
            self.saveFavorites()
            self.favorites.remove(object: character)
            // User Interface side
            if let indexPath = self.favoriteTableView.indexPath(for: cell) {
                self.favoriteTableView.deleteRows(at: [indexPath], with: .top)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    func cellDidTapped(cell: FavoriteTableViewCell) {
    }
}









