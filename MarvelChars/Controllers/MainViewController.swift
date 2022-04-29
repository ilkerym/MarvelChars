//
//  MainViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 26.04.2022.
//

import UIKit

class MainViewController: UIViewController {

    let mainTitles = ["All", "Favorites"]
    

    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "mainCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
    }

}

extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        cell.title = mainTitles[indexPath.row]
        
        return cell
    }
    

}
extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        var storyboardID = String()
            switch indexPath.row {
            case 0: //For All
                storyboardID = "CharactersViewController"
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: storyboardID) as! CharactersViewController
                navigationController?.pushViewController(destinationVC, animated: true)
            case 1: //For Favorite
                storyboardID = "FavoriteTableViewController"
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: storyboardID) as! FavoriteTableViewController
                navigationController?.pushViewController(destinationVC, animated: true)
            default:
                storyboardID = "MainTableViewController"
            }
        
    }

    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel()
        headerLabel.textColor = .white
        headerLabel.font = .systemFont(ofSize: 20)
        headerLabel.text = "Characters"
        
        return headerLabel
    }
  
  
}



