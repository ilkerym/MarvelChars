//
//  DetailsViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var charDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var charNameLabel: UILabel!
    
    var charInfoForDetails : CharInfoMain? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        detailsTableView.dataSource = self
        // Do any additional setup after loading the view.
        charDescriptionLabel.text = charInfoForDetails?.description
        charNameLabel.text = charInfoForDetails?.charName
        
       
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
  



