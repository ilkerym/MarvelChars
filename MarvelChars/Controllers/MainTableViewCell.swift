//
//  MainTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 26.04.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
   
    
    var title = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var mainContent = defaultContentConfiguration()

        mainContent.text = title
        mainContent.textProperties.color = .black
        
        var backgroundConfig = backgroundConfiguration
        backgroundConfig?.backgroundColor = .systemRed
        
        contentConfiguration = mainContent
        backgroundConfiguration = backgroundConfig
       
        
        self.accessoryType = .disclosureIndicator
        self.accessoryView?.tintColor = .black
        
    }
    

}
