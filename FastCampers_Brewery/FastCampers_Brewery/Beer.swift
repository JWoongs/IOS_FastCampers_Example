//
//  Beer.swift
//  FastCampers_Brewery
//
//  Created by Woong on 2022/06/29.
//

import Foundation
import SwiftUI


// 엔티티 설정
// post 하는 부분이 없으므로 Encodable은 필요가 없지.
struct Beer : Decodable {
    let id : Int?
    let name, taglineString ,description, brewersTips, imageUrl : String?
    let foodPairing : [String]?
    
    var tagLine : String {
        let tags = taglineString?.components(separatedBy: ". ")
        let hashTage = tags?.map{
            "#" + $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: " #")
                
        }
        
        return hashTage?.joined(separator: " ") ?? "" // #good # hello
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name , description
        case taglineString  = "tagline"
        case imageUrl = "image_url"
        case brewersTips = "brewers_tips"
        case foodPairing = "food_pairing"
            
    }
    
}
