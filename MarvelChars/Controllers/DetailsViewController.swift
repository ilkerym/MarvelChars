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
    var charName: String? 
    var charDescription : String?
    var comicsSummary = [ComicSummary]()
    
    var urlForComics : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign protocols to controller
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.backgroundColor = .black
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func initUI() {
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = "Details"
        
        charNameLabel.text = charName
        charDescriptionLabel.text = charDescription
        characterImageView.image = charLargeImage
        
        // buraya comicler gelecek
            
//            if selectedCharacter.character.description == "" {
//                charDescriptionLabel.text = "No Available Description"
//            } else {
//                charDescriptionLabel.text = selectedCharacter.character.description
//            }
            
            
//            charDescriptionLabel.text = selectedCharacter.description.isEmpty ? "No Available Description" : selectedCharacter.charDescription
            
       
        
        
        
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
            
            // Sort somics descending order
            comicsSummary.sort{
                $0.name!.compare($1.name!, options: .numeric) == .orderedDescending
            }
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel()
        headerLabel.text = "Comics List"
        headerLabel.textColor = .systemBlue

        return headerLabel
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}






