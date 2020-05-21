//
//  Details.swift
//  app2
//
//  Created by Jack Liu on 2020/4/26.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case requestFailed(Error)
    case invalidData
    case invalidResponse
}

let apiToken="00-NaG3a4Y-6GkBMSqbamluvV3wsHFX4T85hiXnM3m"
struct LoginDetails:Encodable {
    var username="jack@test.com"
    var password="Abcd1234"
}
struct logindata:Encodable {
    var data:LoginDetails
}
struct retd:Decodable {
    var id:String?
    var status:String?
    var expiresAt:String?
    var sessionToken:String?
}
struct user:Decodable{
    var id:String?
    
}
struct ouo:Decodable {
    var data:retd
}

struct RegisterUser:Encodable {
    var profile:Profile
    var credentials:Credentials
}
struct RegisterUserRecieved:Decodable {	
    var id:String?
    var status:String?
    var created:String?
}
struct Profile:Encodable {
    var email:String="11@test.com"
    var login:String="11@test.com"
    var nickName:String="11"
    var gender:String="female"
}
struct Credentials:Encodable {
    var password:Password
}
struct Password:Encodable{
    var value:String="123"
}


var trylogin=LoginDetails()
var LoginData=logindata(data: trylogin)
var tryrecieve=retd()
//var rdata=ouo(data: tryrecieve)


//var cre=credentials()

//var RU=RegisterUser()


