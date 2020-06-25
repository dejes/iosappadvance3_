//
//  MyPostsTableViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/6/23.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit
import Combine


class MyPostsTableViewController: UITableViewController {
    var userid:String?
    var userDefault=UserDefaults()
    var userPost=[sheetDB_GETdata]()
    var cancellable:AnyCancellable?
    var selfpage:SelfPage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        self.tableView.rowHeight = 524

        print("234")
        if userDefault.value(forKey: "userid") != nil {
            userid = userDefault.value(forKey: "userid") as? String
        }
        cancellable = GetSelfPostFromSheetDBPublisher().receive(on: DispatchQueue.main).sink(receiveCompletion: { (finish) in
            print(self.userPost)
        }, receiveValue: { [weak self](values) in
            self!.userPost=values
            self!.tableView.reloadData()
            })
        
        //GetSelfPostFromSheetDB()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func Reload(_ sender: Any) {
        getdata()
        self.tableView.reloadData()
    }
    func getdata(){
        cancellable = GetSelfPostFromSheetDBPublisher().receive(on:DispatchQueue.main).sink(receiveCompletion: { (finish) in

        }, receiveValue: { [weak self](values) in
            self!.userPost=values
            self!.tableView.reloadData()

        })
    }
    // MARK: - Table view data source
    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        cancellable = GetSelfPostFromSheetDBPublisher().sink(receiveCompletion: { (finish) in

        }, receiveValue: { [weak self](values) in
            self!.userPost=values
            self!.tableView.reloadData()

        })
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userPost.count
    }
    func downloadimage(url:URL, imageview:UIImageView){
        URLSession.shared.dataTask(with: url){(data,response,error)
            in
            print(url)
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    imageview.image=image
                }
            }
        }.resume()
    }
    func GetSelfPostFromSheetDBPublisher() -> AnyPublisher<[sheetDB_GETdata],Error>{
        print("1234")
        let url =  URL(string: "https://sheetdb.io/api/v1/6etdv766znrsc/search?userid=" + userid! + "&casesensitive=true")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod="GET"
        let decoder=JSONDecoder()
        return URLSession.shared.dataTaskPublisher(for: urlRequest).map{$0.data}.decode(type: [sheetDB_GETdata].self, decoder: decoder).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    func GetSelfPostFromSheetDB() {
        print("1234")
        var url =  URL(string: "https://sheetdb.io/api/v1/6etdv766znrsc/search?userid=" + userid! + "&casesensitive=true")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod="GET"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let decoder=JSONDecoder()
            if let data = data , let json = try? decoder.decode([sheetDB_GETdata].self, from: data){
                print(json)
            }
        }.resume()
    }
    func GetSelfpage() -> AnyPublisher<SelfPage,Error> {
        let ProfileURL = URL(string: "https://dev-108380.okta.com/api/v1/users/" + userid! )
        var urlRequest = URLRequest(url: ProfileURL!)
        urlRequest.httpMethod="GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS " + apiToken, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest).map{$0.data}.decode(type: SelfPage.self, decoder: JSONDecoder()).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if userPost[indexPath.row].pic1 != "" && userPost[indexPath.row].pic2 != ""{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostStyle2", for: indexPath) as! MyPostsTableViewCell
 
            cell.PoststextView2.text=userPost[indexPath.row].posts
        downloadimage(url: URL(string: userPost[indexPath.row].pic1!)!, imageview: cell.PostImage2a)
        downloadimage(url: URL(string: userPost[indexPath.row].pic2!)!, imageview: cell.PostImage2b)
            cell.TimeLabel2.text=userPost[indexPath.row].Time
            cell.userNameLabel2.text=self.selfpage?.profile.nickName
            
            cancellable = GetSelfpage().receive(on: DispatchQueue.main).sink(receiveCompletion: { (_) in
                
            }, receiveValue: { [weak self](selfdetail) in
                print(selfdetail)
                cell.userNameLabel2.text=selfdetail.profile.nickName
                let url = URL(string: selfdetail.profile.profileImg!)
                self!.downloadimage(url: url!, imageview: cell.selfieImage2.imageView!)
            })
            return cell
        }
        else if userPost[indexPath.row].pic1 != "" && userPost[indexPath.row].pic2 == ""{
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostStyle1", for: indexPath) as! MyPostsTableViewCell
                cell.PoststextView1.text=userPost[indexPath.row].posts
            downloadimage(url: URL(string: userPost[indexPath.row].pic1!)!, imageview: cell.PostImage1)
                 cell.TimeLabel1.text=userPost[indexPath.row].Time
            cancellable = GetSelfpage().receive(on: DispatchQueue.main).sink(receiveCompletion: { (_) in
                
            }, receiveValue: { [weak self](selfdetail) in
                print(selfdetail)
                cell.userNameLabel1.text=selfdetail.profile.nickName
                let url = URL(string: selfdetail.profile.profileImg!)
                self!.downloadimage(url: url!, imageview: cell.selfieImage1.imageView!)
            })
            //setElement(selfie: cell.selfieImage1, nickName: cell.userNameLabel1)
                return cell
        }
            else{
                
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PostStyle0", for: indexPath) as! MyPostsTableViewCell
                    cell.PoststextView.text=userPost[indexPath.row].posts
                     cell.TimeLabel0.text=userPost[indexPath.row].Time
            cancellable = GetSelfpage().receive(on: DispatchQueue.main).sink(receiveCompletion: { (_) in
                print(self.selfpage)
                let url = URL(string: self.selfpage!.profile.profileImg!)
                print(url)
                cell.selfieImage0.imageView!.kf.setImage(with: url)
            }, receiveValue: { [weak self](selfdetail) in
                print(selfdetail)
                self?.selfpage=selfdetail
                cell.userNameLabel.text=selfdetail.profile.nickName
                
                //self!.downloadimage(url: url!, imageview: cell.selfieImage0.imageView!)
            })
          //  setElement(selfie: cell.selfieImage2, nickName: cell.userNameLabel2)
                    return cell
            
            }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostStyle0", for: indexPath) as! MyPostsTableViewCell
        return cell
        // Configure the cell...
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
