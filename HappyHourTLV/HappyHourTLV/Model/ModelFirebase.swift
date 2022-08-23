//
//  ModelFirebase.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 21/08/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseCore
import UIKit

class ModelFirebase {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init() {
        
    }
    
    //MARK: Users
    
    func getAllUsers(completion:@escaping ([User]) -> Void) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([User]())
            } else {
                var users: [User] = []
                for document in querySnapshot!.documents {
                    
                    let user = User(uid: document.data()["uid"] as! String,
                                    firstName: document.data()["firstName"] as! String,
                                    lastName: document.data()["lastName"] as! String,
                                    email: document.data()["email"] as! String,
                                    imageUrl: document.data()["imageUrl"] as! String,
                                    dateOfBirth: document.data()["dateOfBirth"] as! String,
                                    password: document.data()["password"] as! String,
                                    reviewsId: document.data()["reviewsId"] as! [String])
                    users.append(user)
                }
                completion(users)
            }
        }
    }
    
    func getUser(byId id: String,completion:@escaping (User?) -> Void) {
        var user: User?
        db.collection("users").whereField("uid", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    for document in querySnapshot!.documents {
                        user = User(uid: document.data()["uid"] as! String,
                                    firstName: document.data()["firstName"] as! String,
                                    lastName: document.data()["lastName"] as! String,
                                    email: document.data()["email"] as! String,
                                    imageUrl: document.data()["imageUrl"] as! String,
                                    dateOfBirth: document.data()["dateOfBirth"] as! String,
                                    password: document.data()["password"] as! String,
                                    reviewsId: document.data()["reviewsId"] as! [String])
                        completion(user)
                    }
                }
            }
    }
    
    func add(user: User) {
        db.collection("users").addDocument(data: [
            "uid": user.uid,
            "email": user.email,
            "password": user.password,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "imageUrl": user.imageUrl,
            "dateOfBirth": user.dateOfBirth,
            "reviewsId": user.reviewsId,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    func update(user: User) {
        let currentUser = FirebaseAuth.Auth.auth().currentUser
        let userId = currentUser?.uid
        var documentId: String = ""
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uid"] as? String == userId {
                        documentId = document.documentID
                        self.db.collection("users").document(documentId).updateData( [
                            "uid": user.uid,
                            "email": user.email,
                            "password": user.password,
                            "firstName": user.firstName,
                            "lastName": user.lastName,
                            "imageUrl": user.imageUrl,
                            "dateOfBirth": user.dateOfBirth,
                            "reviewsId": user.reviewsId,
                        ])
                    }
                }
            }
        }
    }
    
    //MARK: Bars
    
    func getAllBars(completion:@escaping ([Bar]) -> Void) {
        db.collection("bars").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([Bar]())
            } else {
                var bars: [Bar] = []
                for document in querySnapshot!.documents {
                    let bar = Bar(uid: document.data()["uid"] as! String,
                                  name: document.data()["name"] as! String,
                                  address: document.data()["address"] as! String,
                                  reviewsId: document.data()["reviewsId"] as! [String],
                                  imageUrl: document.data()["imageUrl"] as! String,
                                  fromHour: document.data()["fromHour"] as! String,
                                  toHour: document.data()["toHour"] as! String,
                                  alcohol: document.data()["alcohol"] as! Float,
                                  food: document.data()["food"] as! Float)
                    bars.append(bar)
                }
                completion(bars)
            }
        }
    }
    
    func getBar(ById uid: String, completion:@escaping (Bar?) -> Void) {
        var bar: Bar?
        db.collection("bars").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    for document in querySnapshot!.documents {
                        bar = Bar(uid: document.data()["uid"] as! String,
                                  name: document.data()["name"] as! String,
                                  address: document.data()["address"] as! String,
                                  reviewsId: document.data()["reviewsId"] as! [String],
                                  imageUrl: document.data()["imageUrl"] as! String,
                                  fromHour: document.data()["fromHour"] as! String,
                                  toHour: document.data()["toHour"] as! String,
                                  alcohol: document.data()["alcohol"] as! Float,
                                  food: document.data()["food"] as! Float)
                        completion(bar)
                    }
                }
            }
        
    }
    
    func update(bar: Bar) {
        var documentId: String = ""
        
        db.collection("bars").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uid"] as? String == bar.uid {
                        documentId = document.documentID
                        self.db.collection("bars").document(documentId).updateData( [
                            
                            "uid": bar.uid,
                            "reviewsId": bar.reviewsId,
                            "address": bar.address,
                            "imageUrl": bar.imageUrl,
                            "fromHour": bar.fromHour,
                            "toHour": bar.toHour,
                            "alcohol": bar.alcohol,
                            "food": bar.food,
                        ])
                    }
                }
            }
        }
    }
    
    //MARK: Reviews
    
    func getAllReviews(ByBarId id: String, completion:@escaping ([Review]?) -> Void) {
        var reviews: [Review] = []
        db.collection("reviews").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["barId"] as! String == id {
                        reviews.append(Review(uid: document.data()["uid"] as! String,
                                              userName: document.data()["userName"] as! String,
                                              userId: document.data()["userId"] as! String,
                                              date: document.data()["date"] as! String,
                                              rate: document.data()["rate"] as! Int,
                                              text: document.data()["text"] as! String,
                                              barId: document.data()["barId"] as! String,
                                              barName: document.data()["barName"] as! String,
                                              userImageUrl: document.data()["userImageUrl"] as! String,
                                              barImageUrl:  document.data()["barImageUrl"] as! String))
                    }
                }
                completion(reviews)
            }
        }
    }
    
    func getAllReviews(ByUserId id: String, completion:@escaping ([Review]?) -> Void) {
        var reviews: [Review] = []
        db.collection("reviews").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil)
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["userId"] as! String == id {
                        reviews.append(Review(uid: document.data()["uid"] as! String,
                                              userName: document.data()["userName"] as! String,
                                              userId: document.data()["userId"] as! String,
                                              date: document.data()["date"] as! String,
                                              rate: document.data()["rate"] as! Int,
                                              text: document.data()["text"] as! String,
                                              barId: document.data()["barId"] as! String,
                                              barName: document.data()["barName"] as! String,
                                              userImageUrl: document.data()["userImageUrl"] as! String,
                                              barImageUrl: document.data()["barImageUrl"] as! String))
                    }
                }
                completion(reviews)
            }
        }
    }
    
    func delete(review: Review) {
        var documentId: String = ""
        db.collection("reviews").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uid"] as? String == review.uid {
                        documentId = document.documentID
                        self.db.collection("reviews").document(documentId).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func update(review: Review) {
        var documentId: String = ""
        
        db.collection("reviews").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uid"] as? String == review.uid {
                        documentId = document.documentID
                        self.db.collection("reviews").document(documentId).updateData( [
                            "uid": review.uid,
                            "userName": review.userName,
                            "userId": review.userId,
                            "date": review.date,
                            "rate": review.rate,
                            "text": review.text,
                            "barId": review.barId,
                            "barName": review.barName,
                            "userImageUrl": review.userImageUrl,
                            "barImageUrl": review.barImageUrl,
                        ])
                    }
                }
            }
        }
    }
    
    func add(review: Review) {
        db.collection("reviews").addDocument(data: [
            "uid": review.uid,
            "userId": review.userId,
            "userName": review.userName,
            "date": review.date,
            "rate": review.rate,
            "text": review.text,
            "barId": review.barId,
            "barName": review.barName,
            "userImageUrl": review.userImageUrl,
            "barImageUrl": review.barImageUrl,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    //MARK: Images
    
    func uploadImage(name: String, image: UIImage, callback:@escaping (_ url: String) -> Void) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child(name)
        let data = image.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metaData) { (metaData,error) in
            imageRef.downloadURL {(url, error) in
                let urlString = url?.absoluteString
                callback(urlString!)
            }
        }
    }
    
}
