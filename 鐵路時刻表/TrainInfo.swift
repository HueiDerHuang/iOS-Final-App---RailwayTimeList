//
//  TrainInfos.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/9.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

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

