//
//  LoginViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/26.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var UserNameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func LoginBtn(_ sender: Any) {
        
        FuncController.shared.LoginFunc(Email: trylogin.username, Password: trylogin.password) { (recieving) in
            if let recieving=recieving{
                print(recieving)
                if recieving.status=="SUCCESS"{
                   DispatchQueue.main.async {
                       let storyboard=UIStoryboard(name: "Main", bundle: nil)
                       let vc = storyboard.instantiateViewController(identifier: "PPageView") as! UIViewController
                       vc.modalPresentationStyle = .fullScreen
                       self.present(vc, animated: true, completion: nil)
                   }
               }
               else {
                   DispatchQueue.main.async {
                       let AController=UIAlertController(title: "Login Failed", message: "Please try again.", preferredStyle: .alert)
                       let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                       AController.addAction(okAction)
                       self.present(AController, animated: true, completion: nil)
                   }
               }
            }
        }
        /*let LoginURL = URL(string: "https://dev-108380.okta.com/api/v1/authn")!
        var urlRequest = URLRequest(url: LoginURL)
        
        let trylogin2=LoginDetails(username: UserNameTF.text!, password: PasswordTF.text!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder=JSONEncoder()
        if let data=try?jsonEncoder.encode(trylogin){
            //print(LoginData)
            urlRequest.httpBody=data

            URLSession.shared.dataTask(with: urlRequest) { (rdata, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let rdata = rdata else { print("Empty data"); return }
                let jsondecoder = JSONDecoder()
                /*if let str = String(data: rdata, encoding: .utf8) {
                    print(str)
                }*/
                if let resdata = try?jsondecoder.decode(retd.self, from: rdata) {
                    print(resdata.status)
                    if resdata.status=="SUCCESS"{
                        DispatchQueue.main.async {
                            let storyboard=UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(identifier: "PPageView") as! UIViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            //(navcon, animated: true, completion: nil)
 
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            let AController=UIAlertController(title: "Login Failed", message: "Please try again.", preferredStyle: .alert)
                            let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                            AController.addAction(okAction)
                            self.present(AController, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
                
                
            }.resume()
            print("123")
            
        
            
        }*/
       
        
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
