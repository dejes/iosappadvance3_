//
//  SelfpostsTableViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/6/23.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell{
    @IBOutlet weak var Selfie: UIButton!
    @IBOutlet weak var UserNickname: UILabel!
    @IBOutlet weak var PostTextView: UITextView!
}
class SelfpostsTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ooooo", for: indexPath) as! TableViewCellwithCollectionViewCell
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
