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

class CharitiesViewController: UITableViewController {
    
    var user = User.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get facebook user details
        getUserData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func displayCharities() {
        
        // read from hadoop export file
        let path = Bundle.main.path(forResource: "hadoopData", ofType: "txt")
        var hadoopData = ""
        do {
            hadoopData = try String(contentsOfFile: path!)
        } catch let error as NSError {
            print("Failed reading from URL: \(String(describing: path)), Error: " + error.localizedDescription)
        }
        
        print("raw hometown: \(String(describing: self.user.hometown))")
    }
    
    // Get user data and output it to a file
    func getUserData() {
        struct MyProfileRequest: GraphRequestProtocol {
            struct Response: GraphResponseProtocol {
                
                var name: String?
                var id: String?
                var likes: Dictionary<String, Any>?
                var hometown: Dictionary<String, Any>?
                var profilePictureUrl: String?
                var friends: String?
                
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
                    
                    if let likes = response["likes"] as? Dictionary<String, Any> {
                        self.likes = likes
                    }
                    
                    if let friends = response["friends"] as? String {
                        self.friends = friends
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
            var parameters: [String : Any]? = ["fields": "id, name, hometown, likes"]
            var accessToken = AccessToken.current
            var httpMethod: GraphRequestHTTPMethod = .GET
            var apiVersion: GraphAPIVersion = .defaultVersion
        }
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response): // on completion and result sucessfully returned (asynchronous)
                
                print("Custom Graph Request Succeeded: \(response)")
                
                // set values returned from graph
                self.user.setHometown(h: response.hometown!)
                
                // carry on with processing
                self.displayCharities()
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
