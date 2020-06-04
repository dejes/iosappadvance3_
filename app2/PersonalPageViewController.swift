//
//  PersonalPageViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/29.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class PersonalPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userid:String?

    @IBOutlet weak var ProfilePicBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        FuncController.shared.getProfile(userid: userid!) { (receiving) in
            switch receiving{
            case .success (let ProfileData):
                DispatchQueue.main.async{

                     let controller = self.children[0] as? ProfileTableViewController
                    print(ProfileData)
                    controller?.profileDetail[0].text=ProfileData?.profile.email
                    controller?.profileDetail[1].text=ProfileData?.profile.gender
                    controller?.profileDetail[2].text=ProfileData?.profile.nickName
                    controller?.userid=self.userid!
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
    }
    weak open var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    let photopicker = UIImagePickerController()
    @IBAction func ChangeProfilePic(_ sender: UIButton) {
        photopicker.sourceType = .photoLibrary
        photopicker.delegate = self
        self.present(photopicker,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        ProfilePicBtn.setImage(image, for: .normal)
        photopicker.dismiss(animated: true, completion: nil)
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

