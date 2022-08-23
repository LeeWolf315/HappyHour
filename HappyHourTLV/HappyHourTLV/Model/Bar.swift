//
//  Bar.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 22/08/2022.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class Bar {
    
    var uid: String
    var name: String
    var address: String
    var reviewsId: [String]
    var imageUrl: String
    var fromHour: String
    var toHour: String
    var alcohol: Float
    var food: Float
    
    init(uid: String, name: String, address: String, reviewsId: [String], imageUrl: String, fromHour: String, toHour: String, alcohol: Float, food: Float) {
        self.uid = uid
        self.name = name
        self.address = address
        self.reviewsId = reviewsId
        self.imageUrl = imageUrl
        self.fromHour = fromHour
        self.toHour = toHour
        self.alcohol = alcohol
        self.food = food
    }
    
    
}
