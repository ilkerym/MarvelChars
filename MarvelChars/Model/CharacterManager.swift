//
//  CharacterManager.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 15.03.2022.
//

import UIKit
import Alamofire
import AlamofireImage


struct CharacterData : Codable {
    var id = Int()
    var name = String()
    var description = String()
    var thumbnail: Image?
    var comics: ComicList?
}


