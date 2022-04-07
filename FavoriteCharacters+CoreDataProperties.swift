//
//  FavoriteCharacters+CoreDataProperties.swift
//  
//
//  Created by İlker Yasin Memişoğlu on 6.04.2022.
//
//

import Foundation
import CoreData


extension FavoriteCharacters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCharacters> {
        return NSFetchRequest<FavoriteCharacters>(entityName: "FavoriteCharacters")
    }

    @NSManaged public var character: String?
    @NSManaged public var isStarred: Bool

}
