//
//  CharacterTableViewCell.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 14.03.2022.
//

import UIKit
import Alamofire
import AlamofireImage
import SystemConfiguration

protocol CharacterCellDelegate {
    func accessoryViewDidTapped(cell: CharacterTableViewCell, isStarred: Bool)
    func cellDidTapped(cell: CharacterTableViewCell)
}

class CharacterTableViewCell: UITableViewCell {
    
    
    var delegate: CharacterCellDelegate?
    var characterManager : CharacterManager?
    var charImage = UIImage()
    var accessoryIsTapped  = false
    var favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var accessoryImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25 , height: 25))
    
    let starImage = UIImage(named: "star")
    let starFillImage = UIImage(named: "star.fill")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
       
        if let character = characterManager {

            // Image Response Serializers
            AF.request(String((characterManager?.character.thumbnail?.url)!)).responseImage { response in
                
                guard let data = response.data else {return print("error while fetching character image")}
               
                self.charImage = UIImage(data: data) ?? UIImage(systemName: "pencil")!
                
                //apply image filter
                let size = CGSize(width: 85.0, height: 85.0)
                
                let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 5)
               
                let filteredCharImage = imageFilter.filter(self.charImage)
                
                var content = self.defaultContentConfiguration().updated(for: state)

                content.image = filteredCharImage
                
                content.text = character.character.name
                self.contentConfiguration = content
                
                
                
            }
        }
        accessoryImageView.image = starFillImage
       
        accessoryImageView.isUserInteractionEnabled = true
       // let cellGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessoryViewTapped))
        
        accessoryImageView.addGestureRecognizer(gestureRecognizer)
        accessoryView = accessoryImageView
        accessoryView?.tintColor = characterManager!.isStarred ? .orange : .gray
   
    }

    
    @objc func accessoryViewTapped() {
        
        self.accessoryIsTapped = !accessoryIsTapped
         
        
        delegate?.accessoryViewDidTapped(cell: self, isStarred : accessoryIsTapped)
    }
    @objc func cellTapped() {
        
        
        delegate?.cellDidTapped(cell: self)
    }

}























