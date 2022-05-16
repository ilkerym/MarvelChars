//
//  FavoriteTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 26.04.2022.
//

import UIKit
import Alamofire
import AlamofireImage

protocol FavoriteCellDelegate
{
    func accessoryViewDidTapped(cell: FavoriteTableViewCell, isStarred: Bool)
    func cellDidTapped(cell: FavoriteTableViewCell)
}

class FavoriteTableViewCell: UITableViewCell {
    
    var delegate: FavoriteCellDelegate?
    var favoriteCharacter : AllCharacter?
//    let welcomeCharacter = MarvelCharacter(id: 0, name: "No favorite character added yet", description: "", isStarred: false, imageURL: "")
    
   
    var charImage = UIImage()
    var emptyImage = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
  
    let starFillImage = UIImage(named: "star.fill")
    var accessoryIsTapped  = true
    var accessoryImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25 , height: 25))
    var welcomeMessage : String?
    
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
        
        
        
        if let character = favoriteCharacter {
            
            // Image Response Serializers
            AF.request(character.imageURL!).responseImage { response in
                
                guard let data = response.data else {return print("error while fetching character image")}
                
                self.charImage = UIImage(data: data) ?? UIImage(systemName: "photo")!
                
                //apply image filter
                let size = CGSize(width: 85.0, height: 85.0)
                
                let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 5)
                
                let filteredCharImage = imageFilter.filter(self.charImage)
                
                var favoriteContent = self.defaultContentConfiguration().updated(for: state)
                
               
                    favoriteContent.image = filteredCharImage
                    
                favoriteContent.text = self.favoriteCharacter?.charName
                
                
                self.contentConfiguration = favoriteContent
                
            }
            accessoryImageView.image = starFillImage
            accessoryImageView.isUserInteractionEnabled = true
            accessoryView = accessoryImageView
            // let cellGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessoryViewTapped))
            
            accessoryImageView.addGestureRecognizer(gestureRecognizer)
            
            guard let characterInFavorites = favoriteCharacter else {return print("error while updating, marking cell star")}
            accessoryImageView.tintColor = characterInFavorites.isStarred ? .orange : .gray
        } else {

            var welcomeContent = defaultContentConfiguration().updated(for: state)
            welcomeContent.image = emptyImage
           // welcomeContent.text = welcomeCharacter.name
            contentConfiguration = welcomeContent
            
            accessoryImageView.image = starFillImage
            accessoryImageView.isUserInteractionEnabled = false
            accessoryView = accessoryImageView
            accessoryImageView.tintColor = .gray
        }
        
    }
   
    @objc func accessoryViewTapped() {
        
        self.accessoryIsTapped = !accessoryIsTapped
        
        delegate?.accessoryViewDidTapped(cell: self, isStarred : accessoryIsTapped)
        
    }
    @objc func cellTapped() {
        delegate?.cellDidTapped(cell: self)
    }
    
}
