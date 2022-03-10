//
//  DetailTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var comicsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDetailCell(with selectedRow: ComicSummary) {
        if selectedRow.name != nil {
            comicsLabel.text = selectedRow.name
        } else {
            comicsLabel.text = "No Comics List Available"
        }
 
    }
    
}
