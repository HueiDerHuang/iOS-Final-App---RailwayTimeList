//
//  RecordList.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/14.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

struct RecordList: Codable {
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
    var Date: String
    
    static func readFromFile() -> [RecordList]? {
        let propertyDecoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "recordList"), let recordList = try? propertyDecoder.decode([RecordList].self, from: data) {
            return recordList
        } else {
            return nil
        }
    }
    
    static func saveToFile(recordLists: [RecordList]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(recordLists) {
            UserDefaults.standard.set(data, forKey: "recordList")
        }
    }
}
