//
//  MainDialogsViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 30.09.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import CryptoKit
import UIKit
import SnapKit
import Starscream
import SwiftyJSON

class MainDialogsViewController: YoustersViewController {
    
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    let cellID = "dialogCell"
    
    lazy var emptyLabel = EmptyDocsListLabelView(opacity: 0.7)
    let loadingView = LoadingView()
    
    var dialogs:[DialogWrap] = []
    
    var isNeedShowDialog = false
    var dialogUIDtoShow:String?

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .backgroundColor

        setup()
        getData()
                
        navigationItem.title = "Сервис договоров"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem?.tintColor = .bgColor
        
        view.addSubview(loadingView)
        loadingView.centered()
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
            switch result {
            case .success(let resultDialogs):
                App.shared.isNeedUpdateDialogs = false
                self.emptyLabel.removeFromSuperview()
                loadingView.removeFromSuperview()
                dialogs.forEach({$0.disconnect()})
                dialogs = []
                for item in resultDialogs {
                    if item.uid == "" {continue}
                    let socket = DialogSocket(url: URLs.dialogWS(uid: item.uid))
                    let dw = DialogWrap(dialog: item, socket: socket)
                    dw.delegate = self
                    dw.connect()
                    
                    dialogs.append(dw)
                }
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                showDialogIfNeed()
                if self.dialogs.isEmpty {
                    self.tableView.addSubview(self.emptyLabel)
                    self.emptyLabel.centered()
                }
            case .failure(_):
                break
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

    func setNeedShow(with uid:String) {
        isNeedShowDialog = true
        dialogUIDtoShow = uid
    }
    
    func showDialogIfNeed() {
        if isNeedShowDialog, let dialogUID = dialogUIDtoShow {
            if let dialogWrap = dialogs.first(where: {$0.dialog.uid == dialogUID}) {
                navigationController?.pushViewController(DialogPageViewController(dialog: dialogWrap.dialog, socket: dialogWrap.socket), animated: true)
            }
        }
    }
    
    func showDialog(with uid:String) -> Bool {
        if let dialogWrap = dialogs.first(where: {$0.dialog.uid == uid}) {
            navigationController?.pushViewController(DialogPageViewController(dialog: dialogWrap.dialog, socket: dialogWrap.socket), animated: true)
            isNeedShowDialog = false
            return true
        }
        return false
    }
    
    @objc func refresh(sender:AnyObject){
        getData()
    }
    
    @objc private func add() {
        navigationController?.pushViewController(SelectDocServiceViewController(), animated: true)
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
