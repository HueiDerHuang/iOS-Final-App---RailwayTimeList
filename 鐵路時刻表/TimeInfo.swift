//
//  TimeInfo.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/10.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

struct TimeInfo: Codable {
    var Station: String?
    var Order: String?
    var DepTime: String?
    var ArrTime: String?
}
