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
    // parameter definitions
    var accessoryIsTapped  = false
    var delegate: CharacterCellDelegate?
    var character : AllCharacter?
    var charImage = UIImage()
    var charImageView = UIImageView()
    let starFillImage = UIImage(named: "star.fill")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var accessoryImageView : UIImageView {
            let accessory = UIImageView(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
            accessory.image = starFillImage
            accessory.isUserInteractionEnabled = true
            return accessory
        }
        accessoryView = accessoryImageView
        // Accessory View Configuration and Actions
        /* let cellGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))*/
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessoryViewTapped))
        accessoryView?.addGestureRecognizer(gestureRecognizer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        if let char = character, let imgUrl = character?.imgUrl {
            charImageView.af.setImage(withURL: URL(string: imgUrl)!,
                                      placeholderImage: UIImage(systemName: "photo")!,
                                      completion:  { response in
                if let image = response.value {
                    // Applying Image Filter
                    let size = CGSize(width: 85.0, height: 85.0)
                    let aspectScaledToFillImage = image.af.imageAspectScaled(toFill: size)
                    let roundedImage = aspectScaledToFillImage.af.imageRounded(withCornerRadius: 5.0)
                    // Cell Content Configuration
                    var content = self.defaultContentConfiguration().updated(for: state)
                    content.image = roundedImage
                    content.text = char.charName
                    self.contentConfiguration = content
                }
            })
        }
        guard let character = character else {return}
        accessoryView?.tintColor = character.isStarred ? .orange : .gray
    }
    @objc func accessoryViewTapped() {
        self.accessoryIsTapped = !accessoryIsTapped
        delegate?.accessoryViewDidTapped(cell: self, isStarred : accessoryIsTapped)
    }
    @objc func cellTapped() {
        delegate?.cellDidTapped(cell: self)
    }
}



















