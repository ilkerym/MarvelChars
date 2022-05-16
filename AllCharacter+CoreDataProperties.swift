//
//  AllCharacter+CoreDataProperties.swift
//  
//
//  Created by İlker Yasin Memişoğlu on 10.05.2022.
//
//

import Foundation
import CoreData


extension AllCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllCharacter> {
        return NSFetchRequest<AllCharacter>(entityName: "AllCharacter")
    }

    @NSManaged public var charDescription: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var isStarred: Bool
    @NSManaged public var name: String?

}
