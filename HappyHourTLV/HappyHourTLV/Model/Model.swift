//
//  Model.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 22/08/2022.
//

import Foundation
import UIKit
import FirebaseAuth
import CloudKit

class Model {
    
    static let instance = Model()
    private let firebaseModel = ModelFirebase()
    
    private init() {
        
    }
    
    //MARK: Users
    
    func getAllUsers(completion:@escaping ([User]) -> Void){
        return firebaseModel.getAllUsers(completion: completion)
    }
    
    func getUser(byId id: String, completion:@escaping (User?) -> Void) {
        return firebaseModel.getUser(byId: id, completion: completion)
    }
    
    func update(user: User) {
        firebaseModel.update(user: user)
    }
    
    func add(user: User) {
        firebaseModel.add(user: user)
    }
    
    //MARK: Bars
    
    func getAllBars(completion:@escaping ([Bar]) -> Void){
        return firebaseModel.getAllBars(completion: completion)
    }
    
    func getBar(ById id: String, completion:@escaping (Bar?) -> Void) {
        return firebaseModel.getBar(ById: id, completion: completion)
    }
    
    func update(bar: Bar) {
        firebaseModel.update(bar: bar)
    }
    
    //MARK: Reviews
    
    func getAllReviews(ByBarId id: String, completion:@escaping ([Review]?) -> Void) {
        firebaseModel.getAllReviews(ByBarId: id, completion: completion)
    }
    
    func getAllReviews(byUserId id: String, completion:@escaping ([Review]?) -> Void) {
        firebaseModel.getAllReviews(ByUserId: id, completion: completion)
    }
    
    func add(review: Review) {
        firebaseModel.add(review: review)
    }
    
    func update(review: Review) {
        firebaseModel.update(review: review)
    }
    
    func delete(review: Review) {
        firebaseModel.delete(review: review)
    }
    
    //MARK: Images
    
    func uploadImage(name: String, image: UIImage, callback:@escaping (_ url: String) -> Void) {
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
    
    
}
