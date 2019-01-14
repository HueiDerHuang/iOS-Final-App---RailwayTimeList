//
//  FavoriteLists.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/14.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

struct FavoriteLineList: Codable {
    var OriginStation: String
    var DestinationStation: String
    
    static func readFromFile() -> [FavoriteLineList]? {
        let propertyDecoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "favoriteLineList"), let favoriteLineList = try? propertyDecoder.decode([FavoriteLineList].self, from: data) {
            return favoriteLineList
        } else {
            return nil
        }
    }
    
    static func saveToFile(favoriteLineLists: [FavoriteLineList]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(favoriteLineLists) {
            UserDefaults.standard.set(data, forKey: "favoriteLineList")
        }
    }
}
