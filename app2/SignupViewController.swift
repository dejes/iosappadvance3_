//
//  SignupViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/30.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
   
    var userid:String?
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
            
            let RegisterUserData = RegisterUser(profile:Profile(email: EmailLabel.text!, login: EmailLabel.text!, nickName: nickNameLabel.text!, gender: GenderSegment.titleForSegment(at: GenderSegment.selectedSegmentIndex)!), credentials: Credentials(password: Password(value: PasswordLabel.text!)))
            FuncController.shared.RegisterFunc(registerdata: RegisterUserData) { (receiving) in
                switch receiving{
                case .success(let RegisterReceive):
                    print(RegisterReceive)
                    DispatchQueue.main.async {
                         let AController=UIAlertController(title: "Sign up successfully!", message: "Please sign in next page.", preferredStyle: .alert)
                         let okAction=UIAlertAction(title: "ok", style: .default, handler: nil)
                         self.userid=RegisterReceive?.id
                         self.performSegue(withIdentifier: "ToPPageSignup", sender: nil)
                        
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
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       if segue.identifier == "ToPPageSignup" {
            let navController = segue.destination as! UINavigationController
           // let tabController = segue.destination as! UITabBarController
        
            let detailController = navController.topViewController as! PersonalPageViewController
        
            detailController.userid = userid!
        }
    }
    

}
