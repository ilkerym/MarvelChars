//
//  CharacterManager.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 31.03.2022.
//

import Foundation


class MarvelCharacter {

    let id : Int
    let name : String
    let charDescription : String
    var isStarred : Bool
    let imageURL : String


    init(id: Int, name: String, description : String, isStarred: Bool = false, imageURL : String) {
        self.id = id
        self.name = name
        self.charDescription = description
        self.isStarred = isStarred
        self.imageURL = imageURL

    }
}




extension MarvelCharacter: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(charDescription)
        hasher.combine(isStarred)
        hasher.combine(imageURL)

    }

}


extension MarvelCharacter: Comparable {
    static func < (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs.name < rhs.name
    }


}
extension MarvelCharacter: Equatable {
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs === rhs

    }
}

