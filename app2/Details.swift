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
    var _embedded:emb
    var status:String?
    var expiresAt:String?
    var sessionToken:String?
    struct emb:Decodable {
        var user:user
        struct user:Decodable {
            var id:String?
        }
    }
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
    var email:String="112@test.com"
    var login:String="112@test.com"
    var nickName:String="11"
    var gender:String="female"
}
struct Credentials:Encodable {
    var password:Password
}
struct Password:Encodable{
    var value:String="123"
}
struct SelfPage:Codable {
    var profile:profiledecode
	
    struct profiledecode:Codable{
        var email:String?
        var login:String?
        var nickName:String?
        var gender:String?
        var profileImg:String?
    }
}
struct UploadImageResult: Decodable {
    struct Data: Decodable {
        let link: URL?
    }
    let data: Data
}
struct changepassword:Codable{
    var oldPassword:String!
    var newPassword:String!
}
struct pwdreturn:Codable {
    var password:pp?
    struct pp:Codable {
    }
}
struct PostsThings:Codable{
    
    var data:data
    struct data:Codable{
        var posts:String?
        var pic1:String?
        var pic2:String?
        var Location:String?
        var Time:String?
        var userid:String?
    }

}
struct sheetDB_GETdata:Codable{
    var posts:String?
    var pic1:String?
    var pic2:String?
    var Location:String?
    var Time:String?
    var userid:String?
}
struct sheetDBreturn:Decodable {
    var created:Int?
}

var trylogin=LoginDetails()
var LoginData=logindata(data: trylogin)
//var tryrecieve=retd()
//var rdata=ouo(data: tryrecieve)


//var cre=credentials()

//var RU=RegisterUser()


