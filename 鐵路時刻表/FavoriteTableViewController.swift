//
//  FavoriteTableViewController.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/13.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var favoriteCellIdentifier = "favoriteCellIdentifier"
    var favoriteLists = [FavoriteList]()
    let breastFeedImage = UIImage(named: "breastFeed.png")
    let crippleImage = UIImage(named: "cripple.png")
    let overNightStnImage = UIImage(named: "overNightStn.png")
    
    
    
    // Get CarClass
    func trainToString(_ train: String?) -> String? {
        /*
         1100                自強(DMU2800、2900、3000型柴聯及 EMU型電車自強號) Tze-Chiang Limited Express
         1101                自強(推拉式自強號)      Tze-Chiang Limited Express
         1102                自強(太魯閣)  Tze-Chiang Limited Express(Tarko)
         1103                自強(DMU3100型柴聯自強號) Tze-Chiang Limited Express
         1107                自強(普悠瑪) Tze-Chiang Limited Express(Puyuma)
         1108                自強(推拉式自強號且無自行車車廂)  Tze-Chiang Limited Express
         1109                自強(PP親障)  有身障位
         110A                自強(PP障12)  有身障位
         110B                自強(E12)
         110C                自強(E3)
         110D                自強(D28)
         110E                自強(D29)
         110F                自強(D31障)   有身障位
         1110                莒光(無身障座位)  Chu-Kuang Express
         1111                莒光(有身障座位)  Chu-Kuang Express
         1114                莒光(無身障座位 ,有自行車車廂) Chu-Kuang Express
         1115                莒光(有身障座位 ,有自行車車廂) Chu-Kuang Express
         1120                復興        Fu-Hsing Semi Express
         1131                區間車    Local Train
         1132                區間快    Fast Local Train
         1140                普快車    Ordinary train
         */
        let TzeChiang = "自強號"
        let Tarko = "太魯閣"
        let Puyuma = "普悠瑪"
        let ChuKuang = "莒光號"
        let FuHsing = "復興號"
        let LocalTrain = "區間車"
        let fastLocalTrain = "區間快"
        switch train {
        case "1100", "1101", "1103", "1108", "1109", "110A", "110B", "110C", "110D", "110E", "110F":
            return TzeChiang
        case "1102":
            return Tarko
        case "1107":
            return Puyuma
        case "1110", "1111", "1114", "1115":
            return ChuKuang
        case "1120":
            return FuHsing
        case "1131":
            return LocalTrain
        case "1132":
            return fastLocalTrain
        default:
            return nil
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favoriteLists = FavoriteList.readFromFile() {
            self.favoriteLists = favoriteLists
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
        return favoriteLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCellIdentifier, for: indexPath) as! FavoriteTableViewCell
        cell.originStationLabel.text = favoriteLists[indexPath.row].OriginStation
        cell.destinationStationLabel.text = favoriteLists[indexPath.row].DestinationStation
        cell.depTimeLabel.text = favoriteLists[indexPath.row].DepTime
        cell.arrTimeLabel.text = favoriteLists[indexPath.row].ArrTime
        cell.noteLabel.text = favoriteLists[indexPath.row].Note
        print("favoriteLists[indexPath.row].CarClassAndTrain: \(favoriteLists[indexPath.row].CarClassAndTrain)")
        cell.trainInfoLabel.text = "\(favoriteLists[indexPath.row].CarClassAndTrain)"
        if favoriteLists[indexPath.row].CarClass == "區間車" || favoriteLists[indexPath.row].CarClass == "區間快" {
            cell.trainInfoLabel.backgroundColor = UIColor(red: 3/255, green: 121/255, blue: 251/255, alpha: 0.5)
        } else {
            cell.trainInfoLabel.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 0.5)
        }
        var indexForImage = 0
        if favoriteLists[indexPath.row].BreastFeed == "Y" {
            cell.imageViews[indexForImage].image = breastFeedImage
            indexForImage += 1
        }
        if favoriteLists[indexPath.row].Cripple == "Y" {
            cell.imageViews[indexForImage].image = crippleImage
            indexForImage += 1
        }
        if favoriteLists[indexPath.row].OverNightStn == "Y" {
            cell.imageViews[indexForImage].image = overNightStnImage
        }
        indexForImage = 0

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favoriteLists.remove(at: indexPath.row)
            FavoriteList.saveToFile(favoriteLists: favoriteLists)
            tableView.reloadData()
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        controller?.favoriteLists = favoriteLists
    }
    

}
