//
//  DetailTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit
import Alamofire

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var comicsLabel: UILabel!
    
    var comicName = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = .pi
        self.tintColor = .darkGray
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var content = defaultContentConfiguration()

        content.text = comicName
        content.textProperties.color = .white
        
        
        var backgroundConfig = backgroundConfiguration
        
        backgroundConfig?.backgroundColor = .darkGray
 
        contentConfiguration = content
        backgroundConfiguration = backgroundConfig
        
    }
    
    
}
