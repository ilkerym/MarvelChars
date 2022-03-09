//
//  DetailsViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit
import Alamofire
import SDWebImage

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var charDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var charNameLabel: UILabel!
    
    var selectedCharacter : Character?
    var comicsSummary = [ComicSummary]()
    var comicsSum : ComicSummary?
    var charImage: UIImage?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        
        if let marvelCharacter = selectedCharacter {
            charNameLabel.text = marvelCharacter.name
            
            if marvelCharacter.description == "" {
                charDescriptionLabel.text = "No Available Description"
            } else {
                charDescriptionLabel.text = marvelCharacter.description
            }
            
        }
        characterImageView.image = charImage
        
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let year2005 = formatter.date(from: "2005/01/01 00:00")
//        let ts2 = String(Date().timeIntervalSince(year2005!))
        
        self.detailsTableView.reloadData()

        }

}
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if comicsSummary.count == 1 {
            return 1
        } else {
            return comicsSummary.count
        }
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailsTableViewCell
        
        let selectedRow = comicsSummary[indexPath.row]
        
        cell.configureDetailCell(with: selectedRow)

        return cell
    }
    
    
    
    
    
}
extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsTableView.deselectRow(at: indexPath, animated: true)
    }

}





