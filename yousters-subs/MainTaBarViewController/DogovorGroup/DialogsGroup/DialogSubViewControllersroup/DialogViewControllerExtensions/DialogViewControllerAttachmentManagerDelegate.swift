//
//  DialogViewControllerAttachmentManagerDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 09.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import CoreServices
import InputBarAccessoryView
import MessageKit

extension DialogPageViewController: AttachmentManagerDelegate {
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        makeInputBarButton(manager)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        makeInputBarButton(manager)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        makeInputBarButton(manager)
    }
    
    func makeInputBarButton(_ manager: AttachmentManager) {
        if manager.attachments.count > 0 {
            (messageInputBar as? ScribeInputView)?.makeSendButton()
        } else {
            (messageInputBar as? ScribeInputView)?.makeVoiceButton()
        }
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let choiseAlert = UIAlertController(title: "Выберите источник", message: nil, preferredStyle: .actionSheet)
        
        choiseAlert.addAction(UIAlertAction(title: "Из галереи", style: .default, handler: { (_) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        choiseAlert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (_) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        choiseAlert.addAction(UIAlertAction(title: "Из файлов", style: .default, handler: { (_) in
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
        }))
        
        choiseAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            choiseAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(choiseAlert, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = messageInputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

extension DialogPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        dismiss(animated: true, completion: {
            if let pickedImage = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                let handled = self.attachmentManager.handleInput(of: pickedImage)
                if !handled {
                    // throw error
                }
            }
        })
    }
}


extension DialogPageViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else {return}
        print("import result : \(myURL.lastPathComponent)")
        self.attachmentManager.handleInput(of: NSURL(string: myURL.absoluteString)!)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        controller.dismiss(animated: true) {}
    }
}
