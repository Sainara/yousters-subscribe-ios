//
//  ExecutorsListView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 16.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import InputBarAccessoryView
import UIKit

class ExecutorsListView: UIView, InputItem {
    weak var inputBarAccessoryView: InputBarAccessoryView?
    var parentStackViewPosition: InputStackView.Position?
    
    var collectionView:UICollectionView
    
    weak var parentViewController:DialogPageViewController?
    
    let height = 140.0
        
    let cellID = "offerCell"
    let previewCellID = "previewCell"
    
    var offers:[Offer] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExecutorsCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(ExecutorsCollectionViewCellPreview.self, forCellWithReuseIdentifier: previewCellID)
        
        super.init(frame: .zero)
                
        collectionView.backgroundColor = .clear
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        collectionView.dataSource = self

        
        let title = UILabel(text: "Предложения юристов", font: Fonts.standart.gilroySemiBoldName(ofSize: 22), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        
        let infoButton = UIButton(image: UIImage(imageLiteralResourceName: "info"), tintColor: .bgColor, target: self, action: #selector(showInfo))
        
        infoButton.snp.makeConstraints { (make) in
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        let hStack = hstack(title, infoButton, spacing: 15, alignment: .center, distribution: .fill)
        hStack.layoutMargins = .init(top: 10, left: 15, bottom: 0, right: 15)
        hStack.isLayoutMarginsRelativeArrangement = true
        
        let vStack = stack(hStack, collectionView, spacing: 0)
        
        addSubview(vStack)
        vStack.fillSuperview()
        
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChangeAction(with textView: InputTextView) {}
    
    func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {}
    
    func keyboardEditingEndsAction() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            snp.removeConstraints()
            self.layoutIfNeeded()
            alpha = 1
        }
        collectionView.reloadData()
    }
    
    func keyboardEditingBeginsAction() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            snp.remakeConstraints { (make) in
                make.height.equalTo(0)
            }
            alpha = 0
            self.layoutIfNeeded()
        }
        collectionView.reloadData()
    }
    
    @objc private func showInfo() {
        let link = URLs.getLegal(page: "faq/documentservice")
        
        let infoView = YoustersWKWebViewController(url: link)
        infoView.modalPresentationStyle = .popover
        UIApplication.shared.keyWindow?.rootViewController?.present(infoView, animated: true, completion: nil)
    }

}

extension ExecutorsListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if offers.isEmpty {
            return 1
        }
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if offers.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellID, for: indexPath) as! ExecutorsCollectionViewCellPreview
            cell.configure()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ExecutorsCollectionViewCell
        cell.configure(offer: offers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !offers.isEmpty {
            let offer = offers[indexPath.row]
            let controller = OfferInfoViewController(offer: offer)

            let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: parentViewController!, to: controller)
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = detailsTransitioningDelegate
            controller.parentViewControllerCustom = self
            
            parentViewController?.present(controller, animated: true, completion: nil)
        }
    }
}

extension ExecutorsListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 130, height: 60)
    }
}

extension ExecutorsListView: ReloadProtocol {
    func reload() {
        parentViewController?.updateStatusAfterPayment()
    }
}
