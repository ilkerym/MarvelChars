//
//  FavoriteCharacter+CoreDataProperties.swift
//  
//
//  Created by İlker Yasin Memişoğlu on 10.05.2022.
//
//

import Foundation
import CoreData


extension FavoriteCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCharacter> {
        return NSFetchRequest<FavoriteCharacter>(entityName: "FavoriteCharacter")
    }

    @NSManaged public var charDescription: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var isStarred: Bool
    @NSManaged public var name: String?

}
