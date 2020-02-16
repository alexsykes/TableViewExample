//
//  ViewController.swift
//  TableViewExample
//
//  Created by Alex on 15/02/2020.
//  Copyright © 2020 Alex Sykes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let swiftBlogs = ["Alex","Sykes","BL6 5QD","07910 765467", "16, Avonhead Close","alex@alexsykes.net"]
    let textCellIdentifier = "TextCell"
    let IDCellIdentifier = "IDCell"
    
    // Array of trials
    var trialsArray:NSArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let idCell = tableView.dequeueReusableCell(withIdentifier: IDCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        idCell.textLabel?.text = String(row)
        return cell
    }
    
    
    
    /******************************************
     Get data from server using URLSession
     @URL  - "https://android.trialmonster.uk/getResultList.php"
     
     *****************************************/
    func getData(){
        
        let session = URLSession.shared
        let url = URL(string: "https://android.trialmonster.uk/getResultList.php")!
        let task = session.dataTask(with: url)
        { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else
            {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime=="text/html" else {
                print("Wrong MIME type!")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("Success")
                self.trialsArray = json as! NSArray

                DispatchQueue.main.async {
                    self.displayData()
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    func displayData(){
            // let count = trialsArray.count

            for i in 0..<trialsArray.count {
                let trial = trialsArray[i] as! NSDictionary
                let id: Int = trial["id"] as! Int
                let date: String = trial["date"] as! String
                let club: String = trial["club"]  as! String
                let name: String = trial["name"]  as! String
                let location: String = trial["location"]  as! String
               print(id, date, club, name, location)
            }
        }
}

