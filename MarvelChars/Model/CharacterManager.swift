//
//  CharacterManager.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 31.03.2022.
//

import Foundation


struct CharacterManager: Equatable {
    static func == (lhs: CharacterManager, rhs: CharacterManager) -> Bool {
        return lhs.character == rhs.character && lhs.isStarred == rhs.isStarred
    }

    let character : Character
    var isStarred : Bool = false
    
    
    init(character: Character, isStarred: Bool) {
        
        self.character = character
        self.isStarred = isStarred
        
    }
    
}
