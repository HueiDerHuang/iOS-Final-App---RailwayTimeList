//
//  HomeTableViewController.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/12.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentSixtyDaysStrings = [String]()
    var currentTwentyFourHoursTimeStrings = [String]()
    var selectedDateOrTimeStringInPickerView:String?
    var originStationStringOnButton: String?
    var destinationStationStringOnButton: String?
    var selectedTimeString: String?
    var selectedDateString: String?
    var selectedStation: String?
    var dataInPickerViewStrings = [String]()
    var fromWhichButtonString: String?
    var originStationSegue = "originStationSegue"
    var destinationStationSegue = "destinationStationSegue"
    var segueToTimeListTableViewController = "segueToTimeListTableViewController"
    var segueFromFavorite = "segueFromFavorite"
    var segueFromRecord = "segueFromRecord"
    var recordLists = [RecordList]()
    var favoriteLineLists = [FavoriteLineList]()
    
    
    
    @IBOutlet weak var originStationButton: UIButton!
    @IBOutlet weak var destinationStationButton: UIButton!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeListSearchButtonPressed: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    @IBAction func goBackToHomeTableViewCell(segue: UIStoryboardSegue) {
        
    }
    
    
    
    @IBAction func changeStationButtonPressed(_ sender: Any) {
        var temp: String?
        temp = originStationButton.titleLabel?.text
        originStationButton.titleLabel?.text = destinationStationButton.titleLabel?.text
        destinationStationButton.titleLabel?.text = temp
        temp = originStationStringOnButton
        originStationStringOnButton = destinationStationStringOnButton
        destinationStationStringOnButton = temp
    }
    
    
    
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        let title = "選擇日期"
        dataInPickerViewStrings = currentSixtyDaysStrings
        settingsPickerView(title, dateLabel)
        performSegue(withIdentifier: originStationSegue, sender: nil)
    }
    
    @IBAction func timeButtonPressed(_ sender: Any) {
        let title = "選擇時間"
        dataInPickerViewStrings = currentTwentyFourHoursTimeStrings
        settingsPickerView(title, timeLabel)
        performSegue(withIdentifier: destinationStationSegue, sender: nil)
    }
    
    @IBAction func timeListSearchButtonPressed(_ sender: Any) {
        // Alert
        var alertString = ""
        if originStationStringOnButton == "..." {
            alertString += "出發車站 "
        }
        if destinationStationStringOnButton == "..."{
            alertString += "到達車站 "
        }
        if alertString != "" {
            alertString += "尚未選擇"
            let alertController = UIAlertController(title: "提示", message: alertString, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    // Show stationPickerView in Alert
    func settingsPickerView(_ description: String, _ label: UILabel) {
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 270, height: 200)
        let pickViewFrame = CGRect(x: 0, y: 0, width: 270, height: 200)
        let pickView = UIPickerView(frame: pickViewFrame)
        pickView.dataSource = self
        pickView.delegate = self
        viewController.view.addSubview(pickView)
        let editStationAlert = UIAlertController(title: description, message: "", preferredStyle: UIAlertController.Style.alert)
        editStationAlert.setValue(viewController, forKey: "contentViewController")
        editStationAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (UIAlertAction) in
            label.text = self.selectedDateOrTimeStringInPickerView
        }))
        editStationAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(editStationAlert, animated: true)
    }
    
    
    
    // PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataInPickerViewStrings.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataInPickerViewStrings[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDateOrTimeStringInPickerView = dataInPickerViewStrings[row]
    }
    
    
    
    func initializeDateAndTimeLabel() {
        let date = Date()
        // Set dateLabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        
        // Set current 60 dates strings
        let SixtyDays = Date()
        for i in 0...59 {
            let date = SixtyDays.addingTimeInterval(TimeInterval(86400 * i))
            let SixtyDaysString = dateFormatter.string(from: date)
            currentSixtyDaysStrings.append(SixtyDaysString)
        }
        
        // Set timeStrings in pickerView
        let TwentyFourHoursTimeFormatter = DateFormatter()
        TwentyFourHoursTimeFormatter.dateFormat = "HH"
        for hour in 0...23 {
            let hourString = String(hour)
            currentTwentyFourHoursTimeStrings.append(hourString+":00")
        }
        
        // Set timeLabel
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)
        timeLabel.text = timeString
        
        // Set selectedDateString and selectedTimeString
        self.selectedDateString = dateString
        self.selectedTimeString = timeString
    }
    
    
    
    func date(_ date: String?) -> String? {
        var string = ""
        if let date = date {
            let array = date.split(separator: ".")
            string = String(array[0] + array[1] + array[2])
        }
        return string
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Set borderWidth color
        let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.originStationButton.layer.borderColor = white
        self.destinationStationButton.layer.borderColor = white
        self.timeListSearchButtonPressed.layer.borderColor = white
        
        // Set dateLabel and timeLabel
        initializeDateAndTimeLabel()
        
        if let favoriteLineLists = FavoriteLineList.readFromFile() , let recordLists = RecordList.readFromFile() {
            self.favoriteLineLists = favoriteLineLists
            self.recordLists = recordLists
        }
        
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueToTimeListTableViewController {
            let controller = segue.destination as? TimeListTableViewController
            if let originStationStringOnButton = originStationStringOnButton {
                controller?.originStationString = originStationStringOnButton
            }
            if let destinationStationStringOnButton = destinationStationStringOnButton {
                controller?.destinationStationString = destinationStationStringOnButton
            }
            if let dateLabelText = self.date(dateLabel.text) {
                selectedDateString = dateLabelText
                controller?.selectedDateString = selectedDateString
            }
            if let timeLabelText = timeLabel.text {
                selectedTimeString = timeLabelText
                controller?.selectedTimeString = selectedTimeString
            }
        } else if segue.identifier == segueFromFavorite {
            let controller = segue.destination as? FavoriteLineListTableViewController
            controller?.favoriteLineLists = favoriteLineLists
        } else if segue.identifier == segueFromRecord {
            let controller = segue.destination as? RecordTableViewController
            controller?.recordLists = recordLists
        } else {
            var fromWhichButtonString = ""
            if segue.identifier == originStationSegue {
                fromWhichButtonString = originStationSegue
            } else if segue.identifier == destinationStationSegue {
                fromWhichButtonString = destinationStationSegue
            }
            let controller = segue.destination as? CityTableViewController
            controller?.fromWhichButtonString = fromWhichButtonString
        }
        print("selectedDateString: \(String(describing: selectedDateString))")
    }
}
