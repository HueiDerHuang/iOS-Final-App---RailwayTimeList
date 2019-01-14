//
//  FavoriteTableViewController.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/13.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class FavoriteLineListTableViewController: UITableViewController {
    
    var favoriteCellIdentifier = "favoriteCellIdentifier"
    var favoriteLineLists = [FavoriteLineList]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favoriteLineLists = FavoriteLineList.readFromFile() {
            self.favoriteLineLists = favoriteLineLists
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
        return favoriteLineLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCellIdentifier, for: indexPath) as! FavoriteLineListTableViewCell
        cell.originStationLabel.text = favoriteLineLists[indexPath.row].OriginStation
        cell.destinationStationLabel.text = favoriteLineLists[indexPath.row].DestinationStation

        // Configure the cell...

        return cell
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favoriteLineLists.remove(at: indexPath.row)
            FavoriteLineList.saveToFile(favoriteLineLists: favoriteLineLists)
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
        controller?.favoriteLineLists = favoriteLineLists
    }
    

}
