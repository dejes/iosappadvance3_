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
    func LoginFunc(Email:String, Password:String, completion: @escaping (Result<retd?,NetworkError>) -> Void) {
        var urlRequest = URLRequest(url: LoginURL)
               
               let trylogin2=LoginDetails(username: Email, password: Password)
               urlRequest.httpMethod = "POST"
               urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
               let jsonEncoder=JSONEncoder()
               if let data=try?jsonEncoder.encode(trylogin2){
                    urlRequest.httpBody=data
                    URLSession.shared.dataTask(with: urlRequest) { (rdata, response, error) in
                        print("******")
                        /*let oo = try? JSONSerialization.jsonObject(with: rdata!, options: [])
                        print(oo)*/
                        let jsondecoder = JSONDecoder()
                        if let error = error {
                             completion(.failure(.requestFailed(error)))
                        }
                        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            /*if let res = response as? HTTPURLResponse{
                                print(res.statusCode)
                            }*/
                            print("-----")
                            completion(.failure(.invalidResponse))
                            return
                        }
                        guard let resdata = try?jsondecoder.decode(retd.self, from: rdata!)
                            else{
                                completion(.failure(.invalidData))
                                return
                            }
                        completion(.success(resdata))
                    }.resume()
                }
                   
    }

    func RegisterFunc(registerdata:RegisterUser,  completion:@escaping (Result< RegisterUserRecieved?,NetworkError>) -> Void){
        let RegisterURL = URL(string: "https://dev-108380.okta.com/api/v1/users?activate=true")!
        var urlRequest = URLRequest(url: RegisterURL)
        urlRequest.httpMethod="POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS " + apiToken, forHTTPHeaderField: "Authorization")
        let encoder=JSONEncoder()
        if let data = try?encoder.encode(registerdata){
            urlRequest.httpBody=data
            URLSession.shared.dataTask(with: urlRequest){ (redata, response, error) in
                let qqdata = try? JSONSerialization.jsonObject(with: redata!, options: [])
                print(qqdata)
                let decoder = JSONDecoder()
                
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    
                    completion(.failure(.invalidResponse))
                       return
                   }
                guard let resdata = try?decoder.decode(RegisterUserRecieved.self, from: redata!)
                    else{
                        completion(.failure(.invalidData))
                        return
                    }
                   completion(.success(resdata))
               }.resume()
                    
            }
    }
    func getProfile(userid:String, completion:@escaping(Result<SelfPage?,NetworkError>) -> Void ){
        let ProfileURL = URL(string: "https://dev-108380.okta.com/api/v1/users/" + userid )
        var urlRequest = URLRequest(url: ProfileURL!)
        urlRequest.httpMethod="GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS " + apiToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest){(redata, response, error) in
            let qqdata = try? JSONSerialization.jsonObject(with: redata!, options: [])
            print(qqdata)

            let decoder = JSONDecoder()
            if let error = error {
               completion(.failure(.requestFailed(error)))
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else {
               completion(.failure(.invalidResponse))
                  return
            }
            guard let resdata = try?decoder.decode(SelfPage.self, from: redata!)
                else{
                   completion(.failure(.invalidData))
                   return
               }
              completion(.success(resdata))
        }.resume()
    }
    
    func updateprofile(selfpage:SelfPage, userid: String, completion: @escaping(Result<SelfPage?,NetworkError>) -> Void) {
        let url = URL(string: "https://dev-108380.okta.com/api/v1/users/" + userid)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod="POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("SSWS " + apiToken, forHTTPHeaderField: "Authorization")
            let encoder = JSONEncoder()
        
            if let data = try? encoder.encode(selfpage){
                urlRequest.httpBody = data
                URLSession.shared.dataTask(with: urlRequest){(redata,response, error) in
                    let decoder = JSONDecoder()
                    if let error = error {
                       completion(.failure(.requestFailed(error)))
                    }
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                        else {
                       completion(.failure(.invalidResponse))
                          return
                    }
                    guard let resdata = try?decoder.decode(SelfPage.self, from: redata!)
                        else{
                           completion(.failure(.invalidData))
                           return
                       }
                      completion(.success(resdata))
                    /*if (error != nil) {(print(error?.localizedDescription))}
                    let qqdata = try? JSONSerialization.jsonObject(with: redata!, options: [])
                    print(qqdata)*/
                }.resume()
            }
    }
    func changepasswordfunc(change:changepassword, userid:String, completion: @escaping (Result<pwdreturn?,NetworkError>) -> Void ){
        let url = URL(string: "https://dev-108380.okta.com/api/v1/users/" + userid + "/credentials/change_password")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod="POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS " + apiToken, forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(change){
            urlRequest.httpBody=data
            URLSession.shared.dataTask(with: urlRequest){(redata, response, error) in
               let qqdata = try? JSONSerialization.jsonObject(with: redata!, options: [])
               print(qqdata)
               let decoder = JSONDecoder()
               
               if let error = error {
                   completion(.failure(.requestFailed(error)))
               }
               guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                   
                   completion(.failure(.invalidResponse))
                      return
                  }
               guard let resdata = try?decoder.decode(pwdreturn.self, from: redata!)
                   else{
                       completion(.failure(.invalidData))
                       return
                   }
                  completion(.success(resdata))
            }.resume()
        }
    }

	
    
}
	
