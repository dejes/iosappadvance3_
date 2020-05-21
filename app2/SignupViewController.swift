//
//  SignupViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/30.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
   
    
    @IBOutlet weak var EmailLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    @IBOutlet weak var nickNameLabel: UITextField!
    @IBOutlet weak var GenderSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func RegisterBtn(_ sender: Any) {
        if EmailLabel.text?.isEmpty == true	|| PasswordLabel.text?.isEmpty == true || nickNameLabel.text?.isEmpty == true {
           let controller = UIAlertController(title: "Error", message: "There is something you didn't fill in.", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           controller.addAction(okAction)
           present(controller, animated: true, completion: nil)
        }
        else{
            
            let RegisterUserData = RegisterUser(profile:Profile(email: "", login: "12@test.com", nickName: "12", gender: "female"), credentials: Credentials(password: Password(value: "Abcd1234")))
            let encoder = JSONEncoder()
            let RegisterURL = URL(string: "https://dev-108380.okta.com/api/v1/users?activate=true")!
            var urlRequest = URLRequest(url: RegisterURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("SSWS 00-NaG3a4Y-6GkBMSqbamluvV3wsHFX4T85hiXnM3m", forHTTPHeaderField: "Authorization")
            if let data = try?encoder.encode(RegisterUserData){
                urlRequest.httpBody = data
                URLSession.shared.dataTask(with: urlRequest) {(redata, response, error) in
                    guard error == nil else { print(error!.localizedDescription); return }
                    guard let redata = redata else { print("Empty data"); return }
                    let jsondecoder = JSONDecoder()
                    let rdata = try? JSONSerialization.jsonObject(with: redata, options: [])
                    print(rdata)
                    if let resdata = try?jsondecoder.decode(RegisterUserRecieved.self
                        ,from: redata){
                        print(resdata)
                    }
                        
                }.resume()
            }
            
                

            }
           
           /* FuncController.shared.RegisterFunc(registerdata: RegisterUserData) { (RURecieved) in
                if let RURecieved = RURecieved{
                    //if RURecieved.status="STAGED"{}
                    print(RURecieved)
                }
            }*/
        //}
        
        
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
