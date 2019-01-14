//
//  TimeListTableViewController.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/9.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class TimeListTableViewController: UITableViewController {
    
    var currentDateTrainInfos = [TrainInfo]()
    var currentStationInfos = [StationInfo]()
    var originStationString: String?
    var destinationStationString: String?
    var selectedDateString: String?
    var selectedTimeString: String?
    var trainInfosInTimeLists = [TrainInfosInTimeList]()
    let breastFeedImage = UIImage(named: "breastFeed.png")
    let crippleImage = UIImage(named: "cripple.png")
    let overNightStnImage = UIImage(named: "overNightStn.png")
    let dailyImage = UIImage(named: "daily.png")
    var recordLists = [RecordList]()
    var favoriteLineLists = [FavoriteLineList]()
    var selectedDateStringOriginal: String?
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        var repeatLineIsTrue = false
        let alertController = UIAlertController(title: "是否要加入最愛路線？", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "是", style: .default) { (UIAlertAction) in
            if let originStationString = self.originStationString, let destinationStationString = self.destinationStationString {
                for line in self.favoriteLineLists {
                    if line.OriginStation == originStationString && line.DestinationStation == destinationStationString {
                        repeatLineIsTrue = true
                    }
                }
                if !repeatLineIsTrue {
                    self.favoriteLineLists.append(FavoriteLineList(
                        OriginStation: originStationString,
                        DestinationStation: destinationStationString
                    ))
                    FavoriteLineList.saveToFile(favoriteLineLists: self.favoriteLineLists)
                    self.tableView.reloadData()
                }
            }
        }
        let action2 = UIAlertAction(title: "否", style: .default, handler: nil)
        alertController.addAction(action2)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    
    func getJsonDataFromUrl() {
        // JSON
        // StationInfos
        if let stationUrlString = "https://raw.githubusercontent.com/HueiDerHuang/StationJson/master/StationJson".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stationUrlString) {
            print(stationUrlString)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data {
                    do {
                        let stationResult = try decoder.decode(StationResult.self, from: data)
                        for station in stationResult.Stations {
                            self.currentStationInfos.append(StationInfo(id: station.id, name: station.name))
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
        // TrainInfos
        var combineUrlAndDateString = ""
        selectedDateStringOriginal = selectedDateString
        if let dateString = date(selectedDateString) {
            combineUrlAndDateString = "https://raw.githubusercontent.com/HueiDerHuang/TrainInfosJson/master/" + dateString
        } else {
            print("error: combineUrlAndDateString\n")
        }
        if let urlString = combineUrlAndDateString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data {
                    do {
                        let trainResult = try decoder.decode(TrainResult.self, from: data)
                        let timeInfo = try decoder.decode(TrainResult.TimeInfo.self, from: data)
                        for train in trainResult.TrainInfos {
                            self.currentDateTrainInfos.append(
                                TrainInfo(
                                    Train: train.Train,
                                    CarClass: train.CarClass,
                                    BreastFeed: train.BreastFeed,
                                    Cripple: train.Cripple,
                                    Dinning: train.Dinning,
                                    Note: train.Note,
                                    OverNightStn: train.OverNightStn,
                                    TimeInfos:  [TimeInfo(Station: timeInfo.Station, Order: timeInfo.Order, DepTime: timeInfo.DepTime, ArrTime: timeInfo.ArrTime)]
                                )
                            )
                            self.getTrainInfosArrayInTableViewCell(train)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.quickSort(startIndex: 0, endIndex: self.trainInfosInTimeLists.count-1)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    // Get a trainInfo and its timeInfos to present on a tableViewCell
    func getTrainInfosArrayInTableViewCell(_ train: TrainResult.TrainInfo) {
        var originStationFoundOut = false         // Find out origin station
        var destinationStationFoundOut = false    // Find out destination station
        var getOriginStationDepTime = ""
        var getDestinationStationArrTime = ""
        // Each train's timeInfo descript which passes through every station
        for timeInfo in train.TimeInfos {
            // Select original station and destination station in sequance
            // , so both are different timeInfo but in the same trainInfo
            if !originStationFoundOut &&
                stationIdToName(timeInfo.Station) == originStationString &&
                compareTiming(splitTimeStringToInt(timeInfo.DepTime), splitTimeStringToInt(selectedTimeString)) {
                originStationFoundOut = true
                if let depTime = timeInfo.DepTime {
                    getOriginStationDepTime = depTime
                }
            }
            if originStationFoundOut &&
                !destinationStationFoundOut &&
                stationIdToName(timeInfo.Station) == destinationStationString &&
                compareTiming(splitTimeStringToInt(timeInfo.ArrTime), splitTimeStringToInt(getOriginStationDepTime)) {
                destinationStationFoundOut = true
                if let arrTime = timeInfo.ArrTime {
                    getDestinationStationArrTime = arrTime
                }
            }
            if originStationFoundOut && destinationStationFoundOut {
                originStationFoundOut = false
                destinationStationFoundOut = false
                trainInfosInTimeLists.append(
                    TrainInfosInTimeList(
                        Train: optionalToString(train.Train),
                        CarClass: optionalToString(trainToString(train.CarClass)),
                        BreastFeed: optionalToString(train.BreastFeed),
                        Cripple: optionalToString(train.Cripple),
                        Dinning: optionalToString(train.Dinning),
                        Note: optionalToString(train.Note),
                        OverNightStn: optionalToString(train.OverNightStn),
                        DepTime: optionalToString(timeToString(splitTimeStringToInt(getOriginStationDepTime))),
                        ArrTime: optionalToString(timeToString(splitTimeStringToInt(getDestinationStationArrTime))),
                        CostTime: optionalToString(countCostMinutes(splitTimeStringToInt(getDestinationStationArrTime), splitTimeStringToInt(getOriginStationDepTime))),
                        Cost: ""
                    )
                )
                break
            }
        }
    }
    
    
    
    // QuickSort
    func quickSort(startIndex: Int, endIndex: Int) -> Void {
        if startIndex > endIndex {
            return
        }
        let pivot = partition(startIndex: startIndex, endIndex: endIndex)
        quickSort(startIndex: startIndex, endIndex: pivot - 1)
        quickSort(startIndex: pivot + 1, endIndex: endIndex)
    }
    func partition(startIndex: Int, endIndex: Int) -> Int {
        var i = startIndex
        for index in startIndex...endIndex {
            if splitTimeStringToInt(trainInfosInTimeLists[index].DepTime) < splitTimeStringToInt(trainInfosInTimeLists[endIndex].DepTime) {
                if i != index {
                    self.trainInfosInTimeLists.swapAt(i, index)
                }
                i += 1
            }
        }
        if i != endIndex {
            self.trainInfosInTimeLists.swapAt(i, endIndex)
        }
        return i
    }
    
    
    
    func date(_ date: String?) -> String? {
        var string = ""
        if let date = date {
            let array = date.split(separator: ".")
            for i in 0..<array.count {
                string = String(array[i])
            }
        }
        return string
    }
    
    
    
    func optionalToString(_ string: String?) -> String {
        if let string = string {
            return string
        }
        return ""
    }
    
    
    
    // Get station name
    func stationIdToName(_ trainStation: String?) -> String? {
        for station in currentStationInfos {
            if let trainStationString = trainStation, let trainStationId = Int(trainStationString) {
                if station.id == trainStationId {
                    return station.name
                }
            }
        }
        return nil
    }
    
    
    
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
    
    
    
    
    // Four functions are about timeInfos
    func splitTimeStringToInt(_ timeString: String?) -> Int {
        var minutes = 0
        if let timeString = timeString {
            let timeArray = timeString.split(separator: ":")
            if let hour = Int(timeArray[0]), let minute = Int(timeArray[1]) {
                minutes = hour * 60 + minute
            }
        }
        return minutes
    }
    func timeToString(_ minutes: Int) -> String? {
        return "\(String(format: "%02d", minutes / 60)):\(String(format: "%02d", minutes % 60))"
    }
    func compareTiming(_ afterTime: Int, _ beforeTime: Int) -> Bool {
        return afterTime > beforeTime ? true : false
    }
    func countCostMinutes(_ afterTime: Int, _ beforeTime: Int) -> String {
        return String(afterTime - beforeTime)
    }
    
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(TimeListTableViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl?.tintColor = UIColor.gray
        
        getJsonDataFromUrl()
        
        if let favoriteLineLists = FavoriteLineList.readFromFile(), let recordLists = RecordList.readFromFile() {
            self.favoriteLineLists = favoriteLineLists
            self.recordLists = recordLists
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trainInfosInTimeLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainAndTimeInfosCell", for: indexPath) as! TrainAndTimeInfosTableViewCell
        cell.trainInfoLabel.text = "\(String(describing: trainInfosInTimeLists[indexPath.row].CarClass))\n\(String(describing: trainInfosInTimeLists[indexPath.row].Train))"
        let carclass = String(describing: trainInfosInTimeLists[indexPath.row].CarClass)
        if carclass == "區間車" || carclass == "區間快" {
            cell.trainInfoLabel.backgroundColor = UIColor(red: 3/255, green: 121/255, blue: 251/255, alpha: 0.5)
        } else {
            cell.trainInfoLabel.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 0.5)
        }
        cell.originStationDepTimeLabel.text = trainInfosInTimeLists[indexPath.row].DepTime
        cell.destinationStationArrTimeLabel.text = trainInfosInTimeLists[indexPath.row].ArrTime
        cell.noteLabel.text = trainInfosInTimeLists[indexPath.row].Note
        cell.costTimeLabel.text = trainInfosInTimeLists[indexPath.row].CostTime + "分"
        var indexForImage = 0
        if trainInfosInTimeLists[indexPath.row].BreastFeed == "Y" {
            cell.imageViews[indexForImage].image = breastFeedImage
            indexForImage += 1
        }
        if trainInfosInTimeLists[indexPath.row].Cripple == "Y" {
            cell.imageViews[indexForImage].image = crippleImage
            indexForImage += 1
        }
        if trainInfosInTimeLists[indexPath.row].OverNightStn == "Y" {
            cell.imageViews[indexForImage].image = overNightStnImage
        }
        indexForImage = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var repeatListIsTrue = false
        for record in self.recordLists {
            if record.Train == trainInfosInTimeLists[indexPath.row].Train {
                repeatListIsTrue = true
            }
        }
        if !repeatListIsTrue {
            let alertController = UIAlertController(title: "是否紀錄搭乘車次？", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "是", style: .default, handler: { (UIAlertAction) in
                let carClassAndTrain = "\(String(describing: self.trainInfosInTimeLists[indexPath.row].CarClass))\n\(String(describing: self.trainInfosInTimeLists[indexPath.row].Train))"
                print("carClassAndTrain: \(carClassAndTrain)")
                self.recordLists.append(RecordList(
                    Train: self.trainInfosInTimeLists[indexPath.row].Train,
                    CarClass: self.trainInfosInTimeLists[indexPath.row].CarClass,
                    CarClassAndTrain: carClassAndTrain,
                    BreastFeed: self.trainInfosInTimeLists[indexPath.row].BreastFeed,
                    Cripple: self.trainInfosInTimeLists[indexPath.row].Cripple,
                    Dinning: self.trainInfosInTimeLists[indexPath.row].Dinning,
                    Note: self.trainInfosInTimeLists[indexPath.row].Note,
                    OverNightStn: self.trainInfosInTimeLists[indexPath.row].OverNightStn,
                    DepTime: self.trainInfosInTimeLists[indexPath.row].DepTime,
                    ArrTime: self.trainInfosInTimeLists[indexPath.row].ArrTime,
                    CostTime: self.trainInfosInTimeLists[indexPath.row].CostTime,
                    Cost: self.trainInfosInTimeLists[indexPath.row].Cost,
                    OriginStation: self.originStationString!,
                    DestinationStation: self.destinationStationString!,
                    Date: self.selectedDateStringOriginal!
                ))
                RecordList.saveToFile(recordLists: self.recordLists)
                tableView.reloadData()
            })
            alertController.addAction(action)
            alertController.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "此車次已記錄", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "是", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
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
        controller?.favoriteLineLists = favoriteLineLists
        
    }
    

}
