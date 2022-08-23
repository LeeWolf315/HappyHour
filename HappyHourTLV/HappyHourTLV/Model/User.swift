//
//  User.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 21/08/2022.
//

import Foundation
import UIKit

class User {
    
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    var imageUrl: String
    var dateOfBirth: String
    var password: String
    var reviewsId: [String]
    
    init(uid: String, firstName: String, lastName: String, email: String, imageUrl: String,dateOfBirth: String, password: String, reviewsId: [String]) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imageUrl = imageUrl
        self.dateOfBirth = dateOfBirth
        self.password = password
        self.reviewsId = reviewsId
    }
}
