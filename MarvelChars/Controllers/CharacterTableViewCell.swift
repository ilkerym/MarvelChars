//
//  CharacterTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 14.03.2022.
//

import UIKit
import Alamofire
import AlamofireImage



class CharacterTableViewCell: UITableViewCell {
    
    
    var character : Character?
    var charImage = UIImage()
    
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
        
       
        if let character = character {

            // Image Response Serializers
            AF.request(String((character.thumbnail?.url)!)).responseImage { response in
                
                guard let data = response.data else {return print("error while fetching character image")}
               
                self.charImage = UIImage(data: data) ?? UIImage(systemName: "pencil")!
                
                //apply image filter
                let size = CGSize(width: 85.0, height: 85.0)
                
                let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 5)
               
                let filteredCharImage = imageFilter.filter(self.charImage)
                
                var content = self.defaultContentConfiguration().updated(for: state)

                content.image = filteredCharImage
                
                content.text = character.name
                
                self.contentConfiguration = content
                
                
                
            }
        }
   
    }
    
  
    
    
}























