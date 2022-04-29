//
//  FavoriteTableViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 26.04.2022.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
     
    let characterVC = CharactersViewController()
    
   
    var favorites = [MarvelCharacter]()
    
    @IBOutlet var favoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        favorites = CharactersViewController.favoriteCharacters
        favoriteTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        navigationItem.title = "Favorites"
        navigationItem.leftBarButtonItem?.tintColor = .black
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  favorites.isEmpty ? 1 : favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        cell.delegate = self
        // Configure the cell...
        
        
        if !favorites.isEmpty {
            cell.favoriteCharacter = favorites[indexPath.row]
        }
      

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowHeight : CGFloat = 85.0
        
        return rowHeight
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard  let  cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell else {return}
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        guard let data = cell.favoriteCharacter else {return print("error")}
        if let comics = data.character.comics?.items {
            destinationVC.comicsSummary = comics
        }
        
        destinationVC.charLargeImage = cell.charImage
        destinationVC.charName = cell.favoriteCharacter?.name
        destinationVC.selectedCharacter = cell.favoriteCharacter
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            
            
//            let add = MarvelCharacter(id: 0, nameOfCharacter: "ilker", characterImageURL: "", description: "anything", character: Character())
//            favorites.append(add)
//            tableView.insertRows(at: [indexPath], with: .right)
        }
    }
    
    

}
extension FavoriteTableViewController : FavoriteCellDelegate {
    func accessoryViewDidTapped(cell: FavoriteTableViewCell, isStarred: Bool) {
        cell.favoriteCharacter?.isStarred = cell.accessoryIsTapped
        cell.accessoryImageView.tintColor = cell.accessoryIsTapped ? .orange : .gray
        
        
        guard let character = cell.favoriteCharacter else {return print("error while unwrapping cell character")}
        if cell.accessoryIsTapped {
            if favorites.contains(character) {
                return
            } else {
                favorites.append(character)
            }
            
        } else {
            
            if let index = favorites.firstIndex(of: character) {
                favorites.remove(at: index)
            }
        }
        
        
    
    }
    
    func cellDidTapped(cell: FavoriteTableViewCell) {
        
    }
}


/*
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
}
*/

/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/
