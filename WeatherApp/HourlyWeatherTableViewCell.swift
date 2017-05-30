//
//  HourlyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Amesten Systems on 30/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell {

    @IBOutlet var hrTempLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var hourWeatherImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
