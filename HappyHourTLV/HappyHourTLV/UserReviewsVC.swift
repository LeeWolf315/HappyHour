//
//  UserReviewsVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 13/08/2022.
//

import UIKit

class UserReviewsVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var editReviewIndex: Int = -1
    var reviews: [Review] = []
    var selectedReview: Review?
    var user: User?
    var bar: Bar?
    var bars: [Bar] = []
    
    override func viewWillAppear(_ animated: Bool) {
        //Check
//        if editReviewIndex != -1 {
//            editReviewIndex = -1
//            self.dismiss(animated: false)
//        }
        
        Model.instance.getAllReviews(byUserId: self.user?.uid ?? "", completion: {
            reviews in
            self.reviews = reviews ?? []
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: "happy-hour")
        
        self.collectionView.register(UINib(nibName: "reviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension UserReviewsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! reviewCell
        cell.configure(title: reviews[indexPath.row].barName, date: reviews[indexPath.row].date, rate: reviews[indexPath.row].rate, description: reviews[indexPath.row].text, image: reviews[indexPath.row].barImageUrl, identifier: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width, height: 110)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "UserReviewsToEditReview" {
            let vc = (segue.destination as! EditReviewVC)
            vc.identifier = editReviewIndex
            vc.review = selectedReview
            vc.user = user
            vc.rate = selectedReview?.rate ?? 0
            vc.bars = bars
            vc.reviews = reviews
        }
    }
    
}

extension UserReviewsVC: reviewCellDelegate {
    func editDidPress(identifier: Int) {
        print("Edit")
        editReviewIndex = identifier
        selectedReview = reviews[identifier]
        
        performSegue(withIdentifier: "UserReviewsToEditReview", sender: self)
    }
    
    func deleteDidPress(identifier: Int) {
        print("Delete")
        selectedReview = reviews[identifier]
        let barId = selectedReview?.barId
        
        Model.instance.delete(review: selectedReview!)
        
        if let index = user!.reviewsId.firstIndex(of: selectedReview!.uid) {
            user?.reviewsId.remove(at: index)
        }
        Model.instance.update(user: user!)
        
        Model.instance.getBar(ById: barId ?? "", completion: {
            bar in
            self.bar = bar
            if let index = bar!.reviewsId.firstIndex(of: self.selectedReview!.uid) {
                self.bar?.reviewsId.remove(at: index)
            }
            Model.instance.update(bar: self.bar!)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.dismiss(animated: true)
        })
        
    }
    
}
