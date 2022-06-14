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
    var charImage = UIImage()
    var emptyImage = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    private let starFillImage = UIImage(named: "star.fill")
    var accessoryIsTapped  = true
    let favCharImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var accessoryImageView : UIImageView {
            let accessory = UIImageView(frame: CGRect(x: 0, y: 0, width: 27 , height: 27))
            accessory.image = starFillImage
            accessory.isUserInteractionEnabled = true
            return accessory
        }
        accessoryView = accessoryImageView
        // let cellGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessoryViewTapped))
        accessoryView?.addGestureRecognizer(gestureRecognizer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        if let character = favoriteCharacter, let imgUrl = favoriteCharacter?.imgUrl {
            
            favCharImageView.af.setImage(withURL: URL(string: imgUrl)!,
                                         placeholderImage: UIImage(systemName: "photo")!,
                                         completion:  { response in
                if let image = response.value {
                    // Applying image filter
                    let size = CGSize(width: 85.0, height: 85.0)
                    let aspectScaledToFillImage = image.af.imageAspectScaled(toFill: size)
                    let roundedImage = aspectScaledToFillImage.af.imageRounded(withCornerRadius: 5.0)
                    // Cell Content Configuration
                    var content = self.defaultContentConfiguration().updated(for: state)
                    content.image = roundedImage
                    content.text = character.charName
                    self.contentConfiguration = content
                }
            })
            guard let characterInFavorites = favoriteCharacter else {return print("error while updating, marking cell star")}
            accessoryView?.tintColor = characterInFavorites.isStarred ? .orange : .gray
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
