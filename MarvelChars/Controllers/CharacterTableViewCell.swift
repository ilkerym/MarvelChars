//
//  CharacterTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 14.03.2022.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

protocol CharacterCellDelegate {
    func accessoryViewDidTapped(cell: CharacterTableViewCell, isStarred: Bool)
    func cellDidTapped(cell: CharacterTableViewCell)
}

class CharacterTableViewCell: UITableViewCell {
    
    
    var delegate: CharacterCellDelegate?
    
    var character = AllCharacter()
    var charImage = UIImage()
    var accessoryIsTapped  = false
    var accessoryImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 27 , height: 27))
    let starFillImage = UIImage(named: "star.fill")
    
    

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
       

//            guard let urlForImage = character.imgUrl else {return print("error image URL")}
        if let urlForImage = character.imgUrl {
            // Image Response Serializers
            AF.request(urlForImage).responseImage { response in
                
                guard let imageData = response.data else {return print("error while fetching character image")}
               
                self.charImage = UIImage(data: imageData) ?? UIImage(systemName: "photo")!
                
                //apply image filter
                let size = CGSize(width: 85.0, height: 85.0)
                
                let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 5)
               
                let filteredCharImage = imageFilter.filter(self.charImage)
                
                var content = self.defaultContentConfiguration().updated(for: state)

                content.image = filteredCharImage
                
                content.text = self.character.charName
                
                self.contentConfiguration = content
                
            }
        }
         
        

        
        accessoryImageView.image = starFillImage
        accessoryImageView.isUserInteractionEnabled = true
        accessoryView = accessoryImageView
       // let cellGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessoryViewTapped))
        
        accessoryImageView.addGestureRecognizer(gestureRecognizer)
        
       // guard let characterInManager = character else {return print("error while updating, marking cell star")}
        accessoryImageView.tintColor = character.isStarred ? .orange : .gray
       
    }
  
    
    @objc func accessoryViewTapped() {
        
        self.accessoryIsTapped = !accessoryIsTapped
         
        delegate?.accessoryViewDidTapped(cell: self, isStarred : accessoryIsTapped)
        
    }
    @objc func cellTapped() {
        
        delegate?.cellDidTapped(cell: self)
        
    }

}























