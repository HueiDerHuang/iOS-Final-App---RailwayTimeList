//
//  TrainAndTimeInfosTableViewCell.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/11.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class TrainAndTimeInfosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainInfoLabel: UILabel!
    @IBOutlet weak var originStationDepTimeLabel: UILabel!
    @IBOutlet weak var destinationStationArrTimeLabel: UILabel!
    @IBOutlet weak var costTimeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet var imageViews: [UIImageView]!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
