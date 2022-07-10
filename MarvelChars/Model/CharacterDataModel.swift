//
//  CharacterData.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 18.02.2022.
//

import Foundation

struct CharacterDataModel: Codable {
    let code : Int? //The HTTP status code of the returned result.,
    let status : String? //(string, optional): A string description of the call status.,
    let copyright: String? //(string, optional): The copyright notice for the returned result.,
    let attributionText: String? //(string, optional): The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.,
    let attributionHTML: String? //(string, optional): An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
    let data : CharacterDataContainer?  //(CharacterDataContainer, optional): The results returned by the call.,
    let etag : String? //(string, optional): A digest value of the content returned by the call.
}
struct CharacterDataContainer : Codable {
    let offset:Int?// (int, optional): The requested offset (number of skipped results) of the call.,
    let limit:Int?// (int, optional): The requested result limit.,
    let total: Int? //(int, optional): The total number of resources available given the current filter set.,
    let count: Int? //(int, optional): The total number of results returned by this call.,
    let results: [Character]? //(Array[Character], optional): The list of characters returned by the call.
}
struct Character : Codable {
    var id: Int? // (int, optional): The unique ID of the character resource.,
    var name: String? // (string, optional): The name of the character.,
    var description: String? // (string, optional): A short bio or description of the character.,
    var modified: Date? //(Date, optional): The date the resource was most recently modified.,
    var resourceURI : String?// (string, optional): The canonical URL identifier for this resource.,
    var urls: [Url]? // (Array[Url], optional): A set of public web site URLs for the resource.,
    var thumbnail: Image? //(Image, optional): The representative image for this character.,
    var comics: ComicList? // (ComicList, optional): A resource list containing comics which feature this character.,

    
    enum CodingKeys: String, CodingKey {
        case id, name
        case description = "description"
        case modified, resourceURI, urls, thumbnail, comics
    }
    
}
struct Url : Codable  {
    let type: String? // (string, optional): A text identifier for the URL.,
    let url: String? //(string, optional): A full URL (including scheme, domain, and path).
}
struct Image : Codable {
    let path: String? // (string, optional): The directory path of to the image.,
    let imgExt : String? //(string, optional): The file extension for the image.
    
    enum CodingKeys: String, CodingKey {
        case path
        case imgExt = "extension"
    }
    
}
struct ComicList : Codable {
    let available: Int? //(int, optional): The number of total available issues in this list. Will always be greater than or equal to the "returned" value.,
    let returned: Int? // (int, optional): The number of issues returned in this collection (up to 20).,
    let collectionURI: String? // (string, optional): The path to the full list of issues in this collection.,
    let items: [ComicSummary]? //(Array[ComicSummary], optional): The list of returned issues in this collection.
}
struct ComicSummary : Codable  {
    let resourceURI: String? //(string, optional): The path to the individual comic resource.,
    let name:String? //(string, optional): The canonical name of the comic.
}








