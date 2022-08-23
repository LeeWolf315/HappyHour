//
//  BarReviewsVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 15/08/2022.
//

import UIKit
import Kingfisher

class BarReviewsVC: UIViewController {
    
    @IBOutlet weak var barView: BarCellView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var image: Data = Data()
    private var titleText: String = "identifier"
    private var descriptionText: String = ""
    var identifier: Int?
    
    var bar: Bar?
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: bar?.imageUrl ?? "")
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            image = imageData
        }
        
        barView.configure(image: UIImage(data: image) ?? UIImage(), title: bar?.name ?? "", address: bar?.address ?? "", identifier: 0)
        
        collectionView.register(UINib(nibName: "reviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension BarReviewsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! reviewCell
        cell.configure(title: reviews[indexPath.row].userName, date: reviews[indexPath.row].date, rate: reviews[indexPath.row].rate, description: reviews[indexPath.row].text, image: reviews[indexPath.row].userImageUrl, identifier: indexPath.row)
        cell.setButtonsHide(hide: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 390, height: 110)
    }
}
