//
//  DetailTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var comicsLabel: UILabel!
    
    var comicName = String()
    
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
        
        var content = defaultContentConfiguration()
        
        content.text = comicName
        
        
        contentConfiguration = content
        
        
    }
    
    func configureDetailCell(with selectedRow: ComicSummary) {
        
        
    }
    
}
