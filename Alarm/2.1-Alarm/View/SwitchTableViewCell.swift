//
//  SwitchTableViewCell.swift
//  2.1-Alarm
//
//  Created by Jason Koceja on 9/14/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate : AnyObject {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    weak var delegate: SwitchTableViewCellDelegate?
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews(){
        guard let alarm = alarm else {return}
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        if let delegate = delegate {
            delegate.switchCellSwitchValueChanged(cell: self)
        }
    }
}
