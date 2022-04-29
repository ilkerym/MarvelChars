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
    let characterImageURL : String
    var isStarred : Bool
    let description : String
    let character : Character
   
     
    
    init(id: Int, nameOfCharacter: String,characterImageURL : String, isStarred: Bool = false, description : String, character: Character) {
        self.id = id
        self.name = nameOfCharacter
        self.isStarred = isStarred
        self.description = description
        self.characterImageURL = characterImageURL
        self.character = character
    }
    
}


extension MarvelCharacter: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
        hasher.combine(characterImageURL)
        hasher.combine(isStarred)
        hasher.combine(description)
        
        
        
    }
  
}


//extension MarvelCharacter: Comparable {
//    static func < (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
//        return lhs.name < rhs.name
//    }
//    
//    
//}
extension MarvelCharacter: Equatable {
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs === rhs
        
    }
}

