//
//  StationInfos.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/8.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import Foundation

struct StationResult: Codable {
    struct StationInfo: Codable {
        var id: Int?
        var name: String?
    }
    var Stations: [StationInfo]
}

