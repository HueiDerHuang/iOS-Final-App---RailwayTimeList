//
//  StationTableViewController.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/12.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class StationTableViewController: UITableViewController {
    
    var fromWhichButtonString: String?
    var stationTableViewCell = "stationTableViewCell"
    var selectedCity:String?
    var stationsInASelectedPart = [String]()
    var selectedStation:String?
    var originStationSegue = "originStationSegue"
    var destinationStationSegue = "destinationStationSegue"
    
    
    
    func initializeStationArray(_ selectedCity:String) -> [String] {
        switch selectedCity {
        case "臺北地區":
            return TaipeiPart
        case "桃園地區":
            return TaoyuanPart
        case "新竹地區":
            return HsinchuPart
        case "苗栗地區":
            return MiaoliPart
        case "臺中地區":
            return TaichungPart
        case "彰化地區":
            return ChanghuaPart
        case "南投地區":
            return NantouPart
        case "雲林地區":
            return YunlinPart
        case "嘉義地區":
            return ChiayiPart
        case "臺南地區":
            return TainanPart
        case "高雄地區":
            return KaohsiungPart
        case "屏東地區":
            return PingtungPart
        case "臺東地區":
            return TaitungPart
        case "花蓮地區":
            return HualienPart
        case "宜蘭地區":
            return YilanPart
        default:
            return [String]()
        }
    }
    
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedCity = selectedCity {
            stationsInASelectedPart = initializeStationArray(selectedCity)
        }
        
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
        return stationsInASelectedPart.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stationTableViewCell, for: indexPath) as! CityAndStationTableViewCell
        cell.cityAndStationLabel.text = stationsInASelectedPart[indexPath.row]
        
        // Configure the cell...

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStation = stationsInASelectedPart[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
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
        
        let controller = segue.destination as? HomeTableViewController
        if let fromWhichButtonString = fromWhichButtonString {
            if fromWhichButtonString == originStationSegue {
                controller?.originStationButton.setTitle(selectedStation, for: .normal)
                controller?.originStationStringOnButton = selectedStation
            } else if fromWhichButtonString == destinationStationSegue {
                controller?.destinationStationButton.setTitle(selectedStation, for: .normal)
                controller?.destinationStationStringOnButton = selectedStation
            }
        }
        
    }
    

}
