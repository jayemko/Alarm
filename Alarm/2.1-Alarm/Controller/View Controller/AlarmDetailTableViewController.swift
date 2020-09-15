//
//  AlarmDetailTableViewController.swift
//  2.1-Alarm
//
//  Created by Jason Koceja on 9/14/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmLabelTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm : Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()

    }
    
    private func updateViews(){

        guard let alarm = alarm else {
            enabledButtonProperties(for: false)
            return
        }
        alarmDatePicker.date = alarm.fireDate
        alarmLabelTextField.text = alarm.name
        alarmIsOn = alarm.enabled
        enabledButtonProperties(for: alarmIsOn)
    }
    
    func enabledButtonProperties(for isEnabled: Bool) {
        alarmIsOn = isEnabled
        enableButton.setTitle(alarmIsOn ? "Disable" : "Enable", for: .normal)
        enableButton.setTitleColor(.white, for: .normal)
        enableButton.backgroundColor = alarmIsOn ? .red : .green
    }
    
    @IBAction func saveAlarmButtonTapped(_ sender: Any){
        guard let alarmText = alarmLabelTextField.text else {return}
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: alarmDatePicker.date, name: alarmText, enabled: alarmIsOn)
        }else {
            let alarm = AlarmController.shared.addAlarm(fireDate: alarmDatePicker.date, name: alarmText, enabled: alarmIsOn)
            print(alarm.name)
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else {return}
        alarm.enabled = !alarm.enabled
        print("alarmIsOn: \(alarmIsOn ? "Disable" : "Enable")")
        updateViews()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
