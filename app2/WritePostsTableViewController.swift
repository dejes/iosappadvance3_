//
//  WritePostsTableViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/6/23.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import Combine

class WritePostsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var cancellable: AnyCancellable?
    var mypost:PostsThings?
    var changePic=[false,false]
    let userDefault = UserDefaults()
    var userid:String?
    //@Published var img:imgurreturn?
    @IBOutlet weak var PostTextView: UITextView!
    @IBOutlet var UploadImages: [UIButton]!
    var imageArr = [UIImage] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefault.value(forKey: "userid") != nil {
            userid = userDefault.value(forKey: "userid") as? String
        }
        
        UploadImages[0].imageView?.contentMode = .scaleAspectFit
        UploadImages[1].imageView?.contentMode = .scaleAspectFit
        
        UploadImages[1].isUserInteractionEnabled=false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
    @IBOutlet weak var testimage: UIImageView!
    @IBAction func Topost(_ sender: Any) {
        let currentDate = Date()
         let dataFormatter = DateFormatter() //實體化日期格式化物件
         dataFormatter.dateFormat = "YYYY-MM-dd hh:mm a"
         let stringDate = dataFormatter.string(from: currentDate)
         let PostTexts = PostTextView.text
         
         let P1=imgurPost(image: UploadImages[0].imageView!.image!)
         let P2=imgurPost(image: UploadImages[1].imageView!.image!)
        
         if PostTexts != ""{
             if changePic[0]==true && changePic[1]==true {
                
                cancellable=Publishers.Zip(P1,P2).receive(on:DispatchQueue.main).sink(receiveCompletion: { (ouo) in
                    
                     print("ouo")
                     
                 }, receiveValue: { [weak self](values) in
                     if let link1 = values.0.data.link, let link2 = values.1.data.link{
                        self!.upsheetDB(Mypost: PostsThings(data: PostsThings.data(posts: PostTexts, pic1:link1.absoluteString , pic2: link2.absoluteString, Location: "", Time: stringDate, userid: self?.userid)))
                        
                        self!.performSegue(withIdentifier: "backsegue", sender: nil)
                     }
                    })
                print("0.0")
                
             }
             else if changePic[0]==true{
                 cancellable = P1.receive(on: DispatchQueue.main).sink(receiveCompletion: { (finisg) in
                     print("finish")

                 }, receiveValue: {[weak self] (values) in
                     if let link1 = values.data.link{
                         self!.upsheetDB(Mypost: PostsThings(data: PostsThings.data(posts: PostTexts, pic1:link1.absoluteString , pic2: "", Location: "", Time: stringDate, userid: self?.userid)))
                     }
                    self!.performSegue(withIdentifier: "backsegue", sender: nil)
                 })
             }
             else if changePic[0]==false{
                 upsheetDB(Mypost: PostsThings(data: PostsThings.data(posts: PostTexts, pic1: "" , pic2: "", Location: "", Time: stringDate, userid: self.userid)))
                self.performSegue(withIdentifier: "backsegue", sender: nil)
             }
             
         }
         else{
             if changePic[0]==true && changePic[1]==true {
                 cancellable=Publishers.Zip(P1,P2).receive(on:DispatchQueue.main).sink(receiveCompletion: { (ouo) in
                     print(ouo)
                 }, receiveValue: { [weak self](values) in
                     if let link1 = values.0.data.link, let link2 = values.1.data.link{
                         self!.upsheetDB(Mypost: PostsThings(data: PostsThings.data(posts: PostTexts, pic1:link1.absoluteString , pic2: link2.absoluteString, Location: "", Time: stringDate, userid: self?.userid)))
                     }
                    self!.performSegue(withIdentifier: "backsegue", sender: nil)
                     })
                 //performSegue(withIdentifier: "backsegue", sender: nil)
             }
             else if changePic[0]==true{
                 cancellable = P1.receive(on: DispatchQueue.main).sink(receiveCompletion: { (finisg) in
                     print("finish")
                 }, receiveValue: {[weak self] (values) in
                     if let link1 = values.data.link{
                         self!.upsheetDB(Mypost: PostsThings(data: PostsThings.data(posts: PostTexts, pic1:link1.absoluteString , pic2: "", Location: "", Time: stringDate, userid: self?.userid)))
                     }
                    self!.performSegue(withIdentifier: "backsegue", sender: nil)
                 })
                // performSegue(withIdentifier: "backsegue", sender: nil)
             }
                 
             else if changePic[0]==false{
                 DispatchQueue.main.async {
                      let AController=UIAlertController(title: "Error", message: "Type something to share your feeling!", preferredStyle: .alert)
                      let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                      AController.addAction(okAction)
                      self.present(AController, animated: true, completion: nil)
                 }
             }
             
         }
    }
    
    func upsheetDB(Mypost:PostsThings) {
        let url = URL(string: "https://sheetdb.io/api/v1/6etdv766znrsc")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod="POST"
        let encoder=JSONEncoder()
        let data = try? encoder.encode(Mypost)
        urlRequest.httpBody = data
        if let data = data ,let json = try? JSONSerialization.jsonObject(with: data, options: []){
            print(json)
        }
        URLSession.shared.dataTask(with: urlRequest){(data,response,error) in
            if let data = data ,let json = try? JSONSerialization.jsonObject(with: data, options: []){
                print(json)
            }
            let decoder = JSONDecoder()
            if let rdata = try? decoder.decode(sheetDBreturn.self, from: data!){
                print(rdata)
            }
        }.resume()
    }
    
    //func upsheetDBPublisher
    func imgurPost(image:UIImage) -> AnyPublisher<UploadImageResult,Error>{
        //let base64Image:String = imageToBase64String(image)!
        let imageData = image.pngData()
        let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
        // Create our url
        
        var url = URL(string: "https://api.imgur.com/3/image")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Client-ID 1d4d94a1c93e933", forHTTPHeaderField: "Authorization")

        // Build our multiform and add our base64 image
        let boundary = NSUUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append(base64Image!.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data

        // Begin the session request
        let decoder=JSONDecoder()
        return
            URLSession.shared.dataTaskPublisher(for: request).map{$0.data}.decode(type: UploadImageResult.self, decoder: decoder).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    //weak open var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    var btntag:Int = 0
    let photopicker = UIImagePickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        print(btntag)
        changePic[btntag]=true
        UploadImages[btntag].setImage(image, for: .normal)
        if changePic[0]==true{
            UploadImages[1].isUserInteractionEnabled=true
        }
        
        photopicker.dismiss(animated: true, completion: nil)
        
        

    }
    @IBAction func imagePicker(_ sender: UIButton) {
        photopicker.sourceType = .photoLibrary
        photopicker.delegate = self
        btntag = sender.tag
        self.present(photopicker,animated: true)
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

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier="backsegue"{
            let controller = segue.destination as! MyPostsTableViewController
            
        }
    }*/
    

}
