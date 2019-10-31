//
//  UserModel.swift
//  HowlTalk
//
//  Created by 유명식 on 2017. 9. 12..
//  Copyright © 2017년 swift. All rights reserved.
//

import ObjectMapper

struct UserModel: Mappable{
   
    var profileImageUrl :String?
    var uid : String?
    var pushToken :String?
    var userName : String?
    init() {
        
    }
    init?(map: Map) {
           
    }
    mutating func mapping(map: Map) {
        profileImageUrl <- map["profileImageUrl"]
        uid <- map["uid"]
        pushToken <- map["pushToken"]
        userName <- map["userName"]
    }
}
