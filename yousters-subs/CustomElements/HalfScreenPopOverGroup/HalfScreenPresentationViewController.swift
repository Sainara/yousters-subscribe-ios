//
//  HalfScreenPresentationViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class HalfScreenPresentationViewController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var yOffSet:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGest(gesture:)))
        panGesture.delegate = self
        presentedViewController.view.addGestureRecognizer(panGesture)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let y = self.containerView!.frame.height / 2
        viewHeight = self.containerView!.frame.height/2
        return CGRect(origin: CGPoint(x: 0, y: y + yOffSet), size: CGSize(width: self.containerView!.frame.width, height: viewHeight))
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.3
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in

        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 20
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func panGest(gesture: UIPanGestureRecognizer) {
        //print()
        
        switch gesture.state {
        case .began, .changed:
            let offset = gesture.translation(in: gesture.view!)
            if offset.y < 0 {
                yOffSet = 0
            } else {
                yOffSet = offset.y
            }
            containerViewDidLayoutSubviews()
        case .ended:
            print(yOffSet)
            print(viewHeight/4)
            if yOffSet > viewHeight/4 {
                self.dismiss()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.yOffSet = 0
                    self.containerViewDidLayoutSubviews()
                }
            }
            
        default:
            break
        }
        
        
    }
}

extension HalfScreenPresentationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
