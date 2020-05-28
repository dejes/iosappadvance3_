//
//  PersonalPageViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/29.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class PersonalPageViewController: UIViewController {
    var userid:String?
    @IBOutlet weak var NicknameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .fullScreen

        print("1234")
        print(userid!)
        let ProfileURL = URL(string: "https://dev-108380.okta.com/api/v1/users/" + userid! )!
        var urlRequest = URLRequest(url: ProfileURL)
        urlRequest.httpMethod="GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS " + apiToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){(redata, response, error) in
            let qqdata = try? JSONSerialization.jsonObject(with: redata!, options: [])
            
            print("**********")
            print(qqdata)
            print("**********")
            let decoder = JSONDecoder()
            if let rrdata = try? decoder.decode(SelfPage.self, from: redata!)
            {
                DispatchQueue.main.async {
                    self.NicknameLabel.text = rrdata.profile.nickName
                    let controller = self.children[0] as? ProfileTableViewController
                    controller?.EmailLabel.text=rrdata.profile.email
                    controller?.GenderLabel.text=rrdata.profile.gender
                }
            }
            else{
                print(error?.localizedDescription)
            }
            
        }.resume()
        // Do any additional setup after loading the view.
    }
    /*func GetProfile(){
        print("123")
        
    }*/
/*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
*/
}

