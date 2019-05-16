//
//  DonateViewController.swift
//  DBDonates
//
//  Created by Freddie Leadsom on 01/03/2018.
//  Copyright © 2018 CS301. All rights reserved.
//

import UIKit
import FacebookCore
import SQLite3
import Foundation

class DonateViewController: UIViewController {

    @IBOutlet weak var profile_picture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var saving_amount: UILabel!
    
    @IBOutlet weak var donate: UIButton!
    
    var db: OpaquePointer?
    
    var savings = Float(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get data from logged in Facebook user - function also stores user and calculates saving amount when request is returned
        getUserData()
    }
    
    func displayProfilePicture(ppurl: String) {
        
        var image = UIImage()
    
        let pictureURL = URL(string: ppurl)!
        
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading profile picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded profile picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        image = UIImage(data: imageData)!
                        self.profile_picture.image = image
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    // Get user data and output it to a file
    func getUserData() {
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
                
                print("Custom Graph Request Succeeded")
                print(response)
                
                // display user name
                self.username.text = response.name
                
                // display profile picture
                self.displayProfilePicture(ppurl: response.profilePictureUrl!)
                
                // Get the saving amount for the user with this facebook ID
                self.getSavingAmount(id: response.id)
                
                // create database
                self.newDatabase()
                
                // save users friends to the database
                for friend in response.friends! {
                    let user = friend as? Dictionary<String, Any>
                    let idstring = user!["id"] as? String
                    let url = "http://graph.facebook.com/" + idstring! + "/picture?type=large"
                    self.saveData(id: user!["id"] as? Int, name: user!["name"] as? String, ppurl: url)
                }
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func getSavingAmount(id: String?) {
        
        var entries = [String]()
        
        // read class data from transactions file
        let path = Bundle.main.path(forResource: "transactions", ofType: "csv")
        do {
            let transactions = try String(contentsOfFile: path!)
            entries = transactions.components(separatedBy: .newlines)
            //TextView.text = myStrings.joined(separator: ", " )
            
        } catch let error as NSError {
            print("Failed reading from URL: \(String(describing: path)), Error: " + error.localizedDescription)
        }
        
        // calculate savings amount
        for (i, entry) in entries.enumerated() { // for each transaction entry
            if entry != "transactionId,reference,from,amount" { // skip the title line
                let columns = entries[i].components(separatedBy: ",")
                for (columnNo, field) in columns.enumerated() { // for each field in this transaction
                    if columnNo == 2 {
                        // pointing to current userId in 'reference' field
                        if field == id {
                            // element is id number
                            
                            // store transaction amount
                            let amount = Float(columns[3])!
                            
                            // round up to £1
                            let remainder = amount.truncatingRemainder(dividingBy: 1)
                            let save = 1 - remainder
                            
                            // increment user's savings by the difference between this and the roundup amount
                            self.savings += save
                        }
                    }
                }
            }
        }
        self.saving_amount.text = "£" + String(format: "%.2f", self.savings)
    }
    
    // create SQLite database
    func newDatabase() {
        
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UsersDatabase.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // Comment out above and uncomment below to drop table
        if sqlite3_exec(db, "DROP TABLE Users", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, profile_url TEXT, friends_list TEXT)",
                        nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        print("database created successfully")
    }
    
    func saveData(id: Int?, name: String?, ppurl: String?) {
        
        // trim values
        let name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        let ppurl = ppurl?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //validating that values are not empty
        if(name?.isEmpty)!{
            return
        }
        if(ppurl?.isEmpty)!{
            return
        }
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Users (name, profile_url) VALUES (?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, ppurl, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding ppurl: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting user: \(errmsg)")
            return
        }
        
        //displaying a success message
        print("User saved successfully, User: \(String(describing: name))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
