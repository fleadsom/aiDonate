//
//  CharitiesViewController.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 03/02/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import UIKit
import FacebookCore
import Foundation
import SQLite3

class CharitiesTableViewController: UITableViewController {
    
    // class stores user details
    var user = User.sharedInstance
    
    var hometown: String!
    
    // Charity Properties
    var charities = [String]()
    var areas = [AreaGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // read in hadoop file
        readLocalCharities()
        
        // set user hometown
        self.hometown = getUserData(requested: "hometown")
        
    }
    
    func readLocalCharities() {
        
        // read class data from hadoop export file
        do {
            let path = Bundle.main.path(forResource: "local_charities", ofType: "txt")
            let classData = try String(contentsOfFile: path!)
            let lines = classData.components(separatedBy: .newlines)
            
            for line in lines {
                let splitarea = line.components(separatedBy: "[") // split area from charities
                if splitarea.count > 1 { // if string is as expected
                    let area = splitarea[0].replacingOccurrences(of: "\t", with: "") // store area and remove tabs
                    let charities = splitarea[1].components(separatedBy: ",") // store charities if line is valid
                    let area_group = AreaGroup(area: area, charities: charities) // group them together
                    self.areas.append(area_group) // store globally
                }
            }
            
        } catch {
            print("Error reading from hadoop export file, Error: " + error.localizedDescription)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return 20
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharityTableViewCell", for: indexPath)
            as? CharityTableViewCell else {
            fatalError("The dequeued cell is not an instance of CharityTableViewCell.")
        }
        
        // set data for this cell
        if self.hometown != nil {
            let splitHometown = self.hometown.components(separatedBy: ",")
            var town = splitHometown[0].replacingOccurrences(of: "Optional(", with: "")
            town = town.replacingOccurrences(of: ")", with: "")
            let index = getAreaIndex(areaSet: self.areas, userHometown: town)
            let charity = self.areas[index[0]]
            cell.charityName.text = charity.charities[indexPath.row]
        }
        return cell
    }
    
    func getAreaIndex(areaSet: [AreaGroup], userHometown: String) -> [Int] {
        var indices = [Int]()
        for (index, area) in areaSet.enumerated() {
            if area.area.lowercased().contains(userHometown.lowercased()) { // ** SELECT AREA CONDITION **
                indices.append(index)
            }
        }
        return indices
    }
    
    // Get user data and output it to a file
    func getUserData(requested data:String) -> String {
        
        var returnable = ""
        
        struct MyProfileRequest: GraphRequestProtocol {
            struct Response: GraphResponseProtocol {
                
                var name: String?
                var id: String?
                var hometown: Dictionary<String, Any>?
                var profilePictureUrl: String?
                var friends: NSArray?
                
                init(rawResponse: Any?) {
                    // Decode JSON from rawResponse into other properties here.
                    guard let response = rawResponse as? Dictionary<String, Any> else {
                        return
                    }
                    
                    if let name = response["name"] as? String {
                        self.name = name
                    }
                    
                    if let id = response["id"] as? String {
                        self.id = id
                    }
                    
                    if let friends = response["friends"]! as? Dictionary<String, Any> {
                        if let data = friends["data"]! as? NSArray {
                            self.friends = data
                        }
                    }
                    
                    if let hometown = response["hometown"] as? Dictionary<String, Any> {
                        self.hometown = hometown
                    }
                    
                    if let picture = response["picture"] as? Dictionary<String, Any> {
                        
                        if let data = picture["data"] as? Dictionary<String, Any> {
                            if let url = data["url"] as? String {
                                self.profilePictureUrl = url
                            }
                        }
                    }
                }
            }
            var graphPath = "/me"
            var parameters: [String : Any ]? = ["fields": "id, name, picture.type(large), hometown, friends"]
            var accessToken = AccessToken.current
            var httpMethod: GraphRequestHTTPMethod = .GET
            var apiVersion: GraphAPIVersion = .defaultVersion
        }
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response): // on completion and result sucessfully returned (asynchronous)
                
                print("Custom Graph Request Succeeded: \(response)")
                
                switch data {
                case "hometown":
                    returnable = String(describing: response.hometown!["name"])
                default: print("no valid data requested")
                }
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
        return returnable
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
