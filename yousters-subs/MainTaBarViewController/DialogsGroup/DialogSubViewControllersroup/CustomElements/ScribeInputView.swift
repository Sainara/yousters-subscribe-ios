//
//  ScribeInputView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import CoreServices
import InputBarAccessoryView
import UIKit

final class ScribeInputView: InputBarAccessoryView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        let items = [
            makeButton(named: "attach").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            }.onSelected {
                $0.tintColor = .bgColor
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                
                let choiseAlert = UIAlertController(title: "Выберите источник", message: nil, preferredStyle: .actionSheet)
                
                choiseAlert.addAction(UIAlertAction(title: "Из галереи", style: .default, handler: { (_) in
                    imagePicker.sourceType = .photoLibrary
                    UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
                }))
                choiseAlert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (_) in
                    imagePicker.sourceType = .camera
                    UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
                }))
                choiseAlert.addAction(UIAlertAction(title: "Из файлов", style: .default, handler: { (_) in
                    let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
                    importMenu.delegate = self
                    importMenu.modalPresentationStyle = .formSheet
                    UIApplication.shared.keyWindow?.rootViewController?.present(importMenu, animated: true, completion: nil)
                }))
                
                
                
                choiseAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                    choiseAlert.dismiss(animated: true, completion: nil)
                }))
                
                UIApplication.shared.keyWindow?.rootViewController?.present(choiseAlert, animated: true, completion: nil)
                
                
            },
            //            makeButton(named: "ic_library")
            //                .onSelected {
            //                    $0.tintColor = .systemBlue
            //
            //            }
            
            //                .configure {
            //                    $0.layer.cornerRadius = 8
            //                    $0.layer.borderWidth = 1.5
            //                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
            //                    $0.setTitleColor(.white, for: .normal)
            //                    $0.setTitleColor(.white, for: .highlighted)
            //                    $0.setSize(CGSize(width: 52, height: 30), animated: false)
            //                }.onDisabled {
            //                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
            //                    $0.backgroundColor = .clear
            //                }.onEnabled {
            //                    $0.backgroundColor = .systemBlue
            //                    $0.layer.borderColor = UIColor.clear.cgColor
            //                }.onSelected {
            //                    // We use a transform becuase changing the size would cause the other views to relayout
            //                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            //                }.onDeselected {
            //                    $0.transform = CGAffineTransform.identity
            //}
        ]
        
        // We can change the container insets if we want
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        //rightStackView.alignment = .top
        //setStackViewItems([sendButton], forStack: .right, animated: false)
        //setRightStackViewWidthConstant(to: 20, animated: false)
        
        // Finally set the items
        setStackViewItems(items, forStack: .left, animated: false)
        setLeftStackViewWidthConstant(to: 36, animated: false)
        
        shouldAnimateTextDidChangeLayout = true
    }
    
    
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.tintColor = .darkGray
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 52, height: 36), animated: false)
            }.onSelected {
                $0.tintColor = .bgColor
            }.onDeselected {
                $0.tintColor = .darkGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
            }
    }
    
}

extension ScribeInputView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                self.inputPlugins.forEach { _ = $0.handleInput(of: pickedImage) }
            }
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


extension ScribeInputView: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else {return}
        
        print("import result : \(myURL.lastPathComponent)")

        self.inputPlugins.forEach { _ = $0.handleInput(of: NSURL(string: myURL.absoluteString)!) }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        controller.dismiss(animated: true) {
            //self.fromFilesBut.setTitle("Выбрать из файлов", for: .normal)
        }
    }
}
