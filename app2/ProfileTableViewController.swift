//
//  ProfileTableViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/30.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    @IBOutlet var profileDetail: [UILabel]!
    var userid:String?
    var selfpage:SelfPage?
  /*  @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var GenderLabel: UILabel!*/
    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIAlertController(title: "Edit", message: nil  , preferredStyle: .alert)
        
        if indexPath.row == 3{
            controller.addTextField { (textfield) in
                textfield.placeholder = "Old Password"
            }
            controller.addTextField { (textfield) in
                textfield.placeholder = "New Password"
            }
        }
        else{
            controller.addTextField { (textfield) in
            }
        }
        let okaction = UIAlertAction(title: "OK", style: .default) { (alertaction) in
            print(controller.textFields?[0].text)
            switch indexPath.row{
            case 0:
                self.selfpage=SelfPage(profile: SelfPage.profiledecode(email: controller.textFields![0].text, login: controller.textFields![0].text))
                FuncController.shared.updateprofile(selfpage: self.selfpage!, userid: self.userid!) { (receiveing) in
                    switch receiveing{
                    case .success(let Profiledata):
                        DispatchQueue.main.async {
                            self.profileDetail[0].text = Profiledata?.profile.email
                            //self.profileDetail[2].text = Profiledata?.profile.nickName
                        }
                    case .failure(let networkError):
                        switch networkError {
                         case .invalidUrl:
                             print("invalid url")
                         case .requestFailed(let error):
                             print(error)
                         case .invalidData:
                             print(networkError)
                         case .invalidResponse:
                             print(networkError)
                             DispatchQueue.main.async {
                                  let AController=UIAlertController(title: "error", message: nil, preferredStyle: .alert)
                                  let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                                  AController.addAction(okAction)
                                  self.present(AController, animated: true, completion: nil)
                             }
                        }
                    }
                }
                break
            case 2:
                self.selfpage=SelfPage(profile: SelfPage.profiledecode(nickName: controller.textFields![0].text))
                FuncController.shared.updateprofile(selfpage: self.selfpage!, userid: self.userid!) { (receiveing) in
                    switch receiveing{
                    case .success(let Profiledata):
                        DispatchQueue.main.async {
                           // self.profileDetail[0].text = Profiledata?.profile.email
                            self.profileDetail[2].text = Profiledata?.profile.nickName
                        }
                    case .failure(let networkError):
                        switch networkError {
                         case .invalidUrl:
                             print("invalid url")
                         case .requestFailed(let error):
                             print(error)
                         case .invalidData:
                             print(networkError)
                         case .invalidResponse:
                             print(networkError)
                             DispatchQueue.main.async {	
                                  let AController=UIAlertController(title: "error", message: nil, preferredStyle: .alert)
                                  let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                                  AController.addAction(okAction)
                                  self.present(AController, animated: true, completion: nil)
                             }
                        }
                    }
                }
            case 3:
                controller.addTextField { (textfield) in }
                controller.addTextField { (textfield) in }
                let cpwd = changepassword(oldPassword: controller.textFields![0].text, newPassword: controller.textFields![1].text)
                FuncController.shared.changepasswordfunc(change: cpwd, userid: self.userid!) { (receiveing) in
                    switch receiveing{
                    case .success(let Profiledata):
                        DispatchQueue.main.async {
                            let AController=UIAlertController(title: "Yeah!", message: "Your password has successfully changed!", preferredStyle: .alert)
                            let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                            AController.addAction(okAction)
                            self.present(AController, animated: true, completion: nil)
                        }
                    case .failure(let networkError):
                        switch networkError {
                         case .invalidUrl:
                             print("invalid url")
                         case .requestFailed(let error):
                             print(error)
                         case .invalidData:
                             print(networkError)
                         case .invalidResponse:
                             print(networkError)
                             DispatchQueue.main.async {
                                  let AController=UIAlertController(title: "error", message: nil, preferredStyle: .alert)
                                  let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                                  AController.addAction(okAction)
                                  self.present(AController, animated: true, completion: nil)
                             }
                        }
                    }
                }
                
                
                
            default:
                break;
            }
            
            
        }
        let cancelaction = UIAlertAction(title: "cancel", style: .default) { (alertaction) in
        }
        controller.addAction(okaction)
        controller.addAction(cancelaction)
        present(controller, animated: true, completion: nil)
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
