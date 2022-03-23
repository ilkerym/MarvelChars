//
//  DetailsViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit
import Alamofire


class DetailsViewController: UIViewController {
    
    // outlet definitions
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var charDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var charNameLabel: UILabel!
    // other parameters definitions
    var charLargeImage: UIImage?
    var selectedCharacter : Character?
    var comicsSummary = [ComicSummary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign protocols to controller
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        
        initializeUI()
        
    }
    
    private func initializeUI() {
        if let marvelCharacter = selectedCharacter {
            charNameLabel.text = marvelCharacter.name
            navigationItem.title = "Details"
            if marvelCharacter.description == "" {
                charDescriptionLabel.text = "No Available Description"
            } else {
                charDescriptionLabel.text = marvelCharacter.description
            }
            
        }
        
        characterImageView.image = charLargeImage
        
    }
    
}

// MARK: - Details Table View Data Source Method
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comicsSummary.isEmpty ? 1 : comicsSummary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailsTableViewCell
        
        if comicsSummary.isEmpty {
            cell.comicName = "No Available Comic"
        } else {
            let selectedRow = comicsSummary[indexPath.row]
            cell.comicName = selectedRow.name!
        }
        
        return cell
    }
    
}

// MARK: - Details Table View Delegate Methods
extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // to make tableview cells non-selectable
        return nil
    }
}





