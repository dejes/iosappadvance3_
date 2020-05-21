//
//  FuncController.swift
//  app2
//
//  Created by Jack Liu on 2020/4/28.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class FuncController{
    static let shared = FuncController()
    
    let LoginURL = URL(string: "https://dev-108380.okta.com/api/v1/authn")!
    func LoginFunc(Email:String, Password:String, completion: @escaping (retd?) -> Void) {
        var urlRequest = URLRequest(url: LoginURL)
               
               let trylogin2=LoginDetails(username: Email, password: Password)
               urlRequest.httpMethod = "POST"
               urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
               let jsonEncoder=JSONEncoder()
               if let data=try?jsonEncoder.encode(trylogin){
                   urlRequest.httpBody=data
                   URLSession.shared.dataTask(with: urlRequest) { (rdata, response, error) in
                       guard error == nil else { print(error!.localizedDescription); return }
                       guard let rdata = rdata else { print("Empty data"); return }
                       let jsondecoder = JSONDecoder()
                       if let resdata = try?jsondecoder.decode(retd.self, from: rdata) {
                        completion(resdata)}
                        else {completion(nil)}
                   }.resume()
                   print("123")
                   
               }
    }
    /*	func RegisterFunc(registerdata:RegisterUser,  completion:@escaping (RegisterUserRecieved?) -> Void){
        let RegisterURL = URL(string: "https://dev-108380.okta.com/api/v1/users?activate=true")!
        var urlRequest = URLRequest(url: RegisterURL)
        urlRequest.httpMethod="POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00-NaG3a4Y-6GkBMSqbamluvV3wsHFX4T85hiXnM3m", forHTTPHeaderField: "Authorization")
        let encoder=JSONEncoder()
        if let data = try?encoder.encode(RU){
            urlRequest.httpBody=data
            print(RU)
            URLSession.shared.dataTask(with: urlRequest){ (redata, response, error) in
                guard error == nil else { print(error!.localizedDescription); return}
                guard let redata = redata else { print("Empty data"); return }
                let decoder = JSONDecoder()
                
                if let RegisterReturn = try?decoder.decode(RegisterUserRecieved.self, from: redata){
                    print(redata)
                    print(error)
                    print(RegisterReturn)
                    completion(RegisterReturn)
                }
                else {
                    print("failed")
                    completion(nil)
                    
                }
                }.resume()
        }
        
        
        
    }*/
    
}
	
