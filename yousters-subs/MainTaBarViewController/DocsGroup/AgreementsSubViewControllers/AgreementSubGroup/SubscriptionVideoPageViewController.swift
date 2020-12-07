//
//  SubscriptionVideoPageViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 31.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import AVKit
import UIKit

class SubscriptionVideoPageViewController: YoustersViewController {
    
    var sub:Subscriber
    let agr:Agreement
    
    let avPlayerViewController = AVPlayerViewController()
    
    init(sub:Subscriber, agr:Agreement) {
        self.sub = sub
        self.agr = agr
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        setupView()
        
        addCloseItem(color: .white)
        addReportButton()
    }
    
    private func setupView() {
        
        let videoView = UIView()
        
        view.addSubview(videoView)
        
        videoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        avPlayerViewController.view.frame = videoView.frame
        addChild(avPlayerViewController)
        videoView.addSubview(avPlayerViewController.view)
        avPlayerViewController.didMove(toParent: self)
        
        let player = AVPlayer(url: URL(string: sub.getVideoUrl())!)
        print(sub.getVideoUrl())
        avPlayerViewController.player = player
        
        let wrapView = UIView()
        videoView.addSubview(wrapView)
        wrapView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-80)
        }
        wrapView.clipsToBounds = true
        wrapView.layer.cornerRadius = 12
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = wrapView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wrapView.addSubview(blurEffectView)
        
        let info = UILabel(text: "Контрагент должен был назвать код: \(agr.number)", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .white, textAlignment: .center, numberOfLines: 0)
        wrapView.addSubview(info)
        info.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)

        }
    }
    
    private func addReportButton() {
        let close = UIButton(title: "Пожаловаться", titleColor: .white)
        close.titleLabel?.font = Fonts.standart.gilroyMedium(ofSize: 15)
        close.contentHorizontalAlignment = .leading
        close.addTarget(self, action: #selector(makeReportAlert), for: .touchUpInside)
        view.addSubview(close)
        close.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
    
    @objc private func makeReportAlert() {
        let alert = UIAlertController(title: "Пожаловаться", message: "Сообщите что не так", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        if let user = App.shared.currentUser, let name = user.name, name == sub.name {
            alert.addAction(UIAlertAction(title: "Это не я", style: .default, handler: { (_) in
                self.makeReport(alert: alert, reason: "notMe")
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Это не мой контрагент", style: .default, handler: { (_) in
                self.makeReport(alert: alert, reason: "notMyKontr")
            }))
            alert.addAction(UIAlertAction(title: "Назван не тот номер", style: .default, handler: { (_) in
                self.makeReport(alert: alert, reason: "wrongCode")
            }))
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    private func makeReport(alert:UIAlertController, reason:String) {
        alert.dismiss(animated: true) {
            let loadAlert = UIAlertController(style: .loading)
            self.present(loadAlert, animated: true, completion: nil)
            ReportService.main.report(uid: self.sub.uid, reason: reason) { (result, error) in
                loadAlert.dismiss(animated: true) {
                    if result {
                        let successAlert = UIAlertController(style: .message, title: "Успех", message: "Жалоба была отправлена, мы рассмотрим её в ближайщее время")
                        self.present(successAlert, animated: true, completion: nil)
                    } else {
                        ResponseError.showAlertWithError(vc: self, error: error)
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
