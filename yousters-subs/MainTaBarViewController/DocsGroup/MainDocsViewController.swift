//
//  MainDocsViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit
import CryptoKit

class MainDocsViewController: YoustersViewController {
    
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    let cellID = "agreementCell"
    
    let emptyLabel = EmptyDocsListLabelView(opacity: 0.7)
    
    var agreements:[Agreement] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .backgroundColor
        
//        let vari = UILabel(text: "In Develop", font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .bgColor, textAlignment: .center, numberOfLines: 0)
//
//        view.addSubview(vari)
//        vari.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
        
        setup()
        getData()
        
        navigationItem.title = "Главная"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem?.tintColor = .bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedUpdateDocs {
            getData()
        }
    }
    
    func getData() {
        AgreementService.main.getAgreements { (result) in
            self.emptyLabel.removeFromSuperview()
            self.agreements = result
            self.tableView.reloadData()
            self.refresher.endRefreshing()
            if self.agreements.isEmpty {
                self.tableView.addSubview(self.emptyLabel)
                self.emptyLabel.centered()
            }
        }
    }
    
    private func setup() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(AgreementCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        refresher.tintColor = .bgColor
        refresher.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    @objc func refresh(sender:AnyObject){
        getData()
    }
    
    @objc private func add() {
        
        if agreements.filter({$0.status == .initial}).count >= 5 {
            let alert = UIAlertController(style: .message, title: nil, message: "Вы не можете имить более 5 неоплаченных договоров")
            self.present(alert, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(CreateAgreementViewController(), animated: true)
        }
    }
}

extension MainDocsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        agreements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AgreementCell(reuseIdentifier: cellID, agreement: agreements[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(AgreementPageViewController(agreemant: agreements[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        guard App.shared.currentUser != nil else {return []}
        
//        if agreements[editActionsForRowAt.row].status == .initial {
//            let delete = UITableViewRowAction(style: .destructive, title: "Удалить") { action, index in
//                print("delete button tapped")
//            }
//            delete.backgroundColor = .red
//
//            return [delete]
//        }
        return []
               
    }

}
