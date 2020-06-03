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
        FuncController.shared.getProfile(userid: userid!) { (receiving) in
            switch receiving{
            case .success (let ProfileData):
                DispatchQueue.main.async{
                     self.NicknameLabel.text = ProfileData?.profile.nickName
                     let controller = self.children[0] as? ProfileTableViewController
                    print(ProfileData)
                    controller?.profileDetail[0].text=ProfileData?.profile.email
                    controller?.profileDetail[1].text=ProfileData?.profile.gender
                    controller?.profileDetail[2].text=ProfileData?.profile.nickName
                    controller?.selfpage=ProfileData
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
                          let AController=UIAlertController(title: "This email has been used!", message: "Please use another email account to sign up or to sign in.", preferredStyle: .alert)
                          let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                          AController.addAction(okAction)
                          self.present(AController, animated: true, completion: nil)
                     }
                }
            }
            
        }
        /*print("1234")
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
            
        }.resume()*/
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

