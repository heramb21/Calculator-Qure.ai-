//
//  SwitchTableViewCell.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 15/12/23.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet var cellSwitch: UISwitch!
    
    static let identifier = "SwitchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SwitchTableViewCell", bundle: nil)
    }
    
    public func configure(isOn: Bool, colour: UIColor) {
        cellSwitch.isOn = isOn
        cellSwitch.onTintColor = colour
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
