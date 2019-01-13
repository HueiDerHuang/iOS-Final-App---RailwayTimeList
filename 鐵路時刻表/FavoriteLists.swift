//
//  FavoriteLists.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/14.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

struct FavoriteList: Codable {
    var Train: String
    var CarClass: String
    var CarClassAndTrain: String
    var BreastFeed: String
    var Cripple: String
    var Dinning: String
    var Note: String
    var OverNightStn: String
    var DepTime: String
    var ArrTime: String
    var CostTime: String
    var Cost: String
    var OriginStation: String
    var DestinationStation: String
    
    static func readFromFile() -> [FavoriteList]? {
        let propertyDecoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "favoriteList"), let favoriteList = try? propertyDecoder.decode([FavoriteList].self, from: data) {
            return favoriteList
        } else {
            return nil
        }
    }
    
    static func saveToFile(favoriteLists: [FavoriteList]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(favoriteLists) {
            UserDefaults.standard.set(data, forKey: "favoriteList")
        }
    }
}
