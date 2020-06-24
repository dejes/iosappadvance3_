//
//  PersonalPageViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/29.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit
import Alamofire

class PersonalPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userid:String?
    let userDefault = UserDefaults()
    @IBOutlet weak var ProfilePicBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault.setValue(userid!, forKey: "userid")
        print(userDefault.value(forKey: "userid"))
        ProfilePicBtn.imageView?.contentMode = .scaleAspectFill
        self.modalPresentationStyle = .fullScreen
        FuncController.shared.getProfile(userid: userid!) { (receiving) in
            switch receiving{
            case .success (let ProfileData):
                DispatchQueue.main.async{
                    var url = URL(string: (ProfileData?.profile.profileImg ?? "123")!)
                    if url != nil{
                        self.downloadimage(url: url!)
                    }
                    
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
        uploadimage(uiimage: image!)
    }
    func uploadimage(uiimage:UIImage){
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID 1d4d94a1c93e933",
        ]
        AF.upload(multipartFormData: { (data) in
            let imageData = uiimage.jpegData(compressionQuality: 0.9)
            data.append(imageData!, withName: "image")
            
        }, to: "https://api.imgur.com/3/upload", headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let result):
                print(result.data.link)
                let upurl = result.data.link!.absoluteString
                let selfpage=SelfPage(profile: SelfPage.profiledecode(profileImg: upurl))
                FuncController.shared.updateprofile(selfpage: selfpage, userid: self.userid!) { (receiving) in
                    switch receiving{
                    case .success(let profiledata):
                        print("******\n")
                        print(profiledata)
                        print("******\n")
                    case .failure(let networkError):
                        switch  networkError {
                        case .invalidUrl:
                            print(networkError)
                        case .invalidResponse :
                            print(networkError)
                        case .invalidData:
                            print(networkError)
                        case .requestFailed(let error):
                            print(error)
                        }
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func downloadimage(url:URL){
        URLSession.shared.dataTask(with: url){(data,response,error)
            in
            print(url)
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.ProfilePicBtn.setImage(image, for: .normal)
                }
            }
        }.resume()
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

