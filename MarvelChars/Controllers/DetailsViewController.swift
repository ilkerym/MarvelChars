//
//  DetailsViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var charDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var charNameLabel: UILabel!
    
    var selectedCharacter : CharInfoMain?
    var isim : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        detailsTableView.dataSource = self
        // Do any additional setup after loading the view.
        charNameLabel.text = selectedCharacter?.charName
        //characterImageView.image = charInfoForDetails.
        charDescriptionLabel.text = selectedCharacter?.description
       
        if let imageURL = URL(string: (selectedCharacter?.charImage.url!)!) {
            characterImageView.load(url: imageURL)
        }
        

        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        charNameLabel.text = selectedCharacter?.charName
//       // characterImageView.image = charInfoForDetails.
//        charDescriptionLabel.text = selectedCharacter?.description
    }
    
    
 
}
//extension DetailsViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//}
  



