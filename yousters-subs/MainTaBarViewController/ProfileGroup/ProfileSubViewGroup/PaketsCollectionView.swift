//
//  PaketsCollectionView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import Haptica

class PaketsCollectionView: UICollectionView {

    var pakets:[Paket] = []
    var parentVC:ParentViewControllerProtocol?
    
    let cellID = "paketCell"
    
    init(pakets:[Paket]) {
        self.pakets = pakets
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 250, height: 260)
        layout.minimumInteritemSpacing = 25
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        register(PaketCell.self, forCellWithReuseIdentifier: cellID)
        delegate = self
        dataSource = self
        //allowsSelection = true
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        snp.makeConstraints { (make) in
            make.height.equalTo(280)
        }
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        //isPagingEnabled = true
    }
    
    private var indexOfCellBeforeDragging = 0
}

extension PaketsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pakets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PaketCell
        cell.setup(paket: pakets[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let proportionalOffset = self.contentOffset.x / 260.0
        indexOfCellBeforeDragging = Int(round(proportionalOffset))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrolling
        targetContentOffset.pointee = scrollView.contentOffset

        // Calculate conditions
        let pageWidth = 260.0// The width your page should have (plus a possible margin)
        let collectionViewItemCount = pakets.count// The number of items in this section
        let proportionalOffset = self.contentOffset.x / 260.0
        let indexOfMajorCell = Int(round(proportionalOffset))
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewItemCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {
            // Animate so that swipe is just continued
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = 260.0 * CGFloat(snapToIndex)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                },
                completion: nil
            )
        } else {
            // Pop back (against velocity)
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        Haptic.play([.haptic(.impact(.light))])
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath)
//        collectionView.cellForItem(at: indexPath)?.layer.opacity = 0.5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        true
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        print(indexPath)
//        collectionView.cellForItem(at: indexPath)?.layer.opacity = 0.5
//    }
}

extension PaketsCollectionView: CellDelegate {
    func work(data:Any) {
        parentVC?.workWithData(data: data)
    }
}
