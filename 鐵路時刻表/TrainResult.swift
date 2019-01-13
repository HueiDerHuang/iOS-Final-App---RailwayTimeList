//
//  TrainInfos.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/8.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

struct TrainResult: Codable {
    struct TrainInfo: Codable {
        var Train: String?
        var CarClass: String?
        var BreastFeed: String?
        var Cripple: String?
        var Dinning: String?
        var Note: String?
        var OverNightStn: String?
        var TimeInfos: [TimeInfo]
    }
    struct TimeInfo: Codable {
        var Station: String?
        var Order: String?
        var DepTime: String?
        var ArrTime: String?
    }
    var TrainInfos: [TrainInfo]
}

    
    
//    var type: String?
//    var Train: String?          // 列車種類
//    var BreastFeed: String?     // 哺乳車間
//    var Route: String?
//    var Package: String?        // 辦理托運
//    var OverNightStn: String?
//    var LineDir: String?
//    var Line: String?
//    var Dining: String?         // 餐車
//    var Cripple: String?        // 殘障車
//    var CarClass: String?
//    var Bike: String?           // 腳踏車車間
//    var Note: String?           // 備註
//    var NoteEng: String?
//    var TimeInfos: [TimeInfos]?
//
//    struct TimeInfos: Codable {
//        var Route: String?
//        var Station: String?    // 車站代碼
//        var Order: String?      // 班次
//        var DepTime: String?    // 離開時間
//        var ArrTime: String?    // 到達時間
//
//    }


