//
//  MainDialogsViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 30.09.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Starscream
import UIKit
import SnapKit
import CryptoKit
import SwiftyJSON

class MainDialogsViewController: YoustersViewController {
    
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    let cellID = "dialogCell"
    
    let emptyLabel = EmptyDocsListLabelView(opacity: 0.7)
    
    var dialogs:[DialogWrap] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .backgroundColor

        setup()
        getData()
        
        //dialogs.append(contentsOf: [Dialog(), Dialog()])
        
        navigationItem.title = "Диалоги"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem?.tintColor = .bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedUpdateDialogs {
            getData()
        }
    }
    
    func getData() {
        DialogsService.main.getDialogs { [self] (result) in
            self.emptyLabel.removeFromSuperview()
            dialogs = []
            for item in result {
                if item.uid == "" {continue}
                let socket = DialogSocket(url: URLs.dialogWS(uid: item.uid))
                let dw = DialogWrap(dialog: item, socket: socket)
                dw.delegate = self
                dw.connect()
                
                dialogs.append(dw)
            }
            self.tableView.reloadData()
            self.refresher.endRefreshing()
            if self.dialogs.isEmpty {
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
        navigationController?.pushViewController(CreateDialogViewController(), animated: true)
    }
}

extension MainDialogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DialogCell(reuseIdentifier: cellID, dialog: dialogs[indexPath.row].dialog)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DialogPageViewController(dialog: dialogs[indexPath.row].dialog, socket: dialogs[indexPath.row].socket), animated: true)
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

extension MainDialogsViewController: DialogWrapDelegate {
    func websocketDidReceiveMessage(text: String) {
        tableView.reloadData()
    }
}
