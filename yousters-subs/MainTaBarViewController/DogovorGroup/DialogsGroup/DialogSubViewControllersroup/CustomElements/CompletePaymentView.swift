//
//  CompletePaymentView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 06.11.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import InputBarAccessoryView
import UIKit

class CompletePaymentView: UIView, InputItem {
    weak var inputBarAccessoryView: InputBarAccessoryView?
    var parentStackViewPosition: InputStackView.Position?
    
    weak var parentViewController:DialogPageViewController?
    
    var offer:Offer?
        
    init() {
        super.init(frame: .zero)

        let title = UILabel(text: "Запрошена полная оплата", font: Fonts.standart.gilroySemiBoldName(ofSize: 22), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        
        let infoButton = UIButton(image: UIImage(imageLiteralResourceName: "info"), tintColor: .bgColor, target: self, action: #selector(showInfo))
        
        infoButton.snp.makeConstraints { (make) in
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        let hStack = hstack(title, infoButton, spacing: 15, alignment: .center, distribution: .fill)
        
        let payButton = YoustersButton(text: "Оплатить")
        payButton.addOnTapTarget { [unowned self] in
            guard let dialog = parentViewController?.dialog else {return}
            
            for offer in dialog.offers {
                if offer.status != .created {
                    self.offer = offer
                }
            }
            guard let offer = offer else {return}
            
            let title = "Доплата: \(offer.title)"
            let controller = DocumentServicePaymentViewController(offerUID: offer.uid, items: [.init(title: title, price: offer.price - offer.price / 5, amount: 1)], page: self)
            self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        }
        
        let vStack = stack(hStack, payButton, spacing: 10)
        vStack.layoutMargins = .init(top: 10, left: 15, bottom: 10, right: 15)
        vStack.isLayoutMarginsRelativeArrangement = true

        
        addSubview(vStack)
        vStack.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChangeAction(with textView: InputTextView) {}
    
    func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {}
    
    func keyboardEditingEndsAction() {
        UIView.animate(withDuration: 0.2) { [self] in
            snp.removeConstraints()
            self.layoutIfNeeded()
            alpha = 1
        }
    }
    
    func keyboardEditingBeginsAction() {
        UIView.animate(withDuration: 0.2) { [self] in
            snp.remakeConstraints { (make) in
                make.height.equalTo(0)
            }
            alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    @objc private func showInfo() {
        let link = URLs.getLegal(page: "faq/documentservice")
        
        let infoView = YoustersWKWebViewController(url: link)
        infoView.modalPresentationStyle = .popover
        UIApplication.shared.keyWindow?.rootViewController?.present(infoView, animated: true, completion: nil)
    }

}

extension CompletePaymentView: ReloadProtocol {
    func reload() {
        parentViewController?.updateStatusAfterPayment()
    }
}
