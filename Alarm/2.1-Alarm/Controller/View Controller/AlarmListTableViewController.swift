//
//  AlarmListTableViewController.swift
//  2.1-Alarm
//
//  Created by Jason Koceja on 9/14/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.loadFromPersistentStorage()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as? SwitchTableViewCell  else {return UITableViewCell()}
        cell.alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlarmSegue" {
            guard let destination = segue.destination as? AlarmDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.alarm = AlarmController.shared.alarms[indexPath.row]
        }
    }
    
    // MARK: - SwitchTableViewCellDelegate
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm else {return}
        AlarmController.shared.toggleEnabled(for: alarm)
        tableView.reloadData()
    }
}
