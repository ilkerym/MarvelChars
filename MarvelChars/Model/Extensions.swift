//
//  Extensions.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 23.04.2022.
//

import Foundation

extension ComicList {
    var urlComics: String? {
        if let path = collectionURI   {
            return "\(path.replacingOccurrences(of: "http", with: "https"))"
        } else {
            return nil
        }
    }
}


extension Image {
    var url: String? {
        if let path = path, let thumbnailExtension = imgExt  {
            return "\(path.replacingOccurrences(of: "http", with: "https")).\(thumbnailExtension)"
        } else {
            return nil
        }
        
    }
}
extension Character {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int?.self, forKey: .id)
        name = try values.decode(String?.self, forKey: .name)
        description = try values.decode(String?.self, forKey: .description)
        resourceURI = try values.decode(String?.self, forKey: .resourceURI)
        thumbnail = try values.decode(Image?.self, forKey: .thumbnail)
        comics = try values.decode(ComicList?.self, forKey: .comics)
        urls = try values.decode([Url]? .self, forKey: .urls)
        
    }
    
}
extension Image {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        path = try values.decode(String?.self, forKey: .path)
        imgExt = try values.decode(String?.self, forKey: .imgExt)
    }
}

extension Character : Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.name == rhs.name
        
    }
  
}
extension ComicSummary : Equatable {
    static func == (lhs: ComicSummary, rhs: ComicSummary) -> Bool {
        return lhs.name == rhs.name && lhs.resourceURI == rhs.resourceURI
    }
    
    
}

extension Array where Element: Equatable {

   // Remove first collection element that is equal to the given `object`:
   mutating func remove(object: Element) {
       guard let index = firstIndex(of: object) else {return}
       remove(at: index)
   }

}
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
