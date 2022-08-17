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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = UIImage(named: "happy-hour")
        
        collectionView.register(UINib(nibName: "reviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        collectionView.delegate = self
        collectionView.dataSource = self

    }

}

extension UserReviewsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! reviewCell
        cell.configure(title: "\(indexPath.row)", date: "\(indexPath.row)", rate: 3, description: "dfdsfsdfghgfhfghghgfhgfhgfhfghfghgfhgfh", image: "happy-hour", identifier: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width, height: 110/*heightForCell(index: indexPath.row)*/ )
    }
    
}

extension UserReviewsVC: reviewCellDelegate {
    func editDidPress(identifier: Int) {
        print("Edit")
    }
    
    func deleteDidPress(identifier: Int) {
        print("Delete")
    }
    
}
