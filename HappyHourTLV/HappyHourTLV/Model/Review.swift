//
//  Review.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 22/08/2022.
//

import Foundation
import UIKit

class Review {
    
    var uid: String
    var userId: String
    var userName: String
    var date: String
    var rate: Int
    var text: String
    var barId: String
    var barName: String
    var userImageUrl: String
    var barImageUrl: String
    
    init(uid: String, userName: String, userId: String, date: String, rate: Int, text: String, barId: String, barName: String, userImageUrl: String, barImageUrl: String) {
        self.uid = uid
        self.userName = userName
        self.userId = userId
        self.date = date
        self.rate = rate
        self.text = text
        self.barId = barId
        self.barName = barName
        self.userImageUrl = userImageUrl
        self.barImageUrl = barImageUrl
    }
    
}
