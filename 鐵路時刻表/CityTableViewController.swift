//
//  StationTableViewController.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/12.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {
    
    var segueToStationTableViewController = "segueToStationTableViewController"
    var fromWhichButtonString: String?
    var cityTableViewCell = "cityTableViewCell"
    var selectedCtiy: String?
    let citys: [String] = [
        "臺北地區",
        "桃園地區",
        "新竹地區",
        "苗栗地區",
        "臺中地區",
        "彰化地區",
        "南投地區",
        "雲林地區",
        "嘉義地區",
        "臺南地區",
        "高雄地區",
        "屏東地區",
        "臺東地區",
        "花蓮地區",
        "宜蘭地區",
    ]
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityTableViewCell, for: indexPath) as! CityAndStationTableViewCell
        cell.cityAndStationLabel.text = citys[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedCtiy = citys[indexPath.row]
        //performSegue(withIdentifier: segueToStationTableViewController, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    

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
        
        let controller = segue.destination as? StationTableViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            selectedCtiy = citys[row]
            controller?.selectedCity = selectedCtiy
            controller?.fromWhichButtonString = fromWhichButtonString
        }
    }
 

}
