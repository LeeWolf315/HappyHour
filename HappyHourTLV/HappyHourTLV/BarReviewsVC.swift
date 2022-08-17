//
//  BarReviewsVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 15/08/2022.
//

import UIKit

class BarReviewsVC: UIViewController {

    @IBOutlet weak var barView: BarCellView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var image: String = ""
    private var titleText: String = ""
    private var descriptionText: String = ""
    private var identifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barView.configure(image: UIImage(named: image) ?? UIImage(), title: titleText, descripation: descriptionText, identifier: identifier)
        
        collectionView.register(UINib(nibName: "reviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension BarReviewsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! reviewCell
        cell.configure(title: "\(indexPath.row)", date: "\(indexPath.row)", rate: 3, description: "dfdsfsdfghgfhfghghgfhgfhgfhfghfghgfhgfh", image: "happy-hour", identifier: indexPath.row)
        cell.setButtonsShow(show: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width, height: 110/*heightForCell(index: indexPath.row)*/ )
    }
    
}
