//
//  MyTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 21.02.2022.
//

import UIKit
import Alamofire
import SDWebImage


class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var charImageView: UIImageView!
    @IBOutlet weak var charNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        charImageView.layer.cornerRadius = charImageView.frame.size.height/10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(with selectedRow: Character) {
        
        // get the name of label
        charNameLabel.text = selectedRow.name
        
        // get the images of Chars
        
        
        //        let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
        //        let thumbnailSize = CGSize(width: 83 * scale, height: 83 * scale) // Thumbnail will bounds to (83,83) points
        //        self.charImageView.sd_setImage(with: URL(string: selectedRow.charImage.url ?? "No Available Image") , placeholderImage: nil, context: [.imageThumbnailPixelSize : thumbnailSize])
        
        
        // Here we use the new provided sd_setImageWithURL: method to load the web image
        charImageView.sd_setImage(
            with: URL(string: selectedRow.thumbnail?.url ?? "No Available Url")!,
            placeholderImage: UIImage(named: "placeholder")
        )
        
    }
    
    
}
