//
//  ScribeInputView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import AVFoundation
import CoreServices
import FDSoundActivatedRecorder
import Haptica
import InputBarAccessoryView
import UIKit

final class ScribeInputView: InputBarAccessoryView {
    
    var recorder = FDSoundActivatedRecorder()
    
    weak var recordDelegate:VoiceRecordedDelegate?
    
    var isVoiceActive = true
    var isRecordStarted = false
    
    private var workItem: DispatchWorkItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession.sharedInstance().setActive(true) - failed")
        }
        
        recorder.timeoutSeconds = 360.0
        recorder.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        recorder.delegate = nil
        print("ScribeInputView deinit")
    }
    
    func configure() {
        let items:[InputItem] = [
            makeButton(named: "attach").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            }.onSelected { [unowned self] in
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

            }
        ]
        
        sendButton.configure({
            $0.image = UIImage(imageLiteralResourceName: "paper-plane")
            $0.title = ""
            $0.tintColor = .bgColor
        })
        
        makeVoiceButton()
        
        // We can change the container insets if we want
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // Finally set the items
        setStackViewItems(items, forStack: .left, animated: false)
        setLeftStackViewWidthConstant(to: 36, animated: false)
        
        shouldAnimateTextDidChangeLayout = true
    }
    
    func setTopStackView(items:[InputItem]) {
        setStackViewItems(items, forStack: .top, animated:false)
    }
    
    var bb:UIView?
    
    func makeVoiceButton() {
        isVoiceActive = true
        sendButton.configure({
            $0.image = UIImage(imageLiteralResourceName: "mic")
            $0.title = ""
            $0.isEnabled = true
            $0.addHaptic(.impact(.medium), forControlEvents: .touchDown)
            //$0.backgroundColor = .blackTransp
            //$0.layer.cornerRadius = 18
            //$0.setSize(.init(width: 36, height: 36), animated: false)
            //$0.setSize(.init(width: 200, height: 36), animated: false)
            $0.tintColor = .bgColor
        }).onTouchUpInside { _ in
            print("recordStartedonTouchUpInside")
        }.onSelected { [unowned self] in
            
            if isVoiceActive {
                
                let bubbleView = UIView()
                
                bb = bubbleView
                
                bubbleView.backgroundColor = .red
                
                let micImage = UIImageView(image: UIImage(imageLiteralResourceName: "mic"))
                bubbleView.addSubview(micImage)
                micImage.setImageColor(color: .white)
                micImage.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.width.equalTo(32)
                    make.height.equalTo(32)
                }
                
                $0.addSubview(bubbleView)
                
                bubbleView.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.width.equalTo(44)
                    make.height.equalTo(44)
                }
                
                bubbleView.layer.cornerRadius = 22
                bubbleView.clipsToBounds = true
                
                workItem = DispatchWorkItem.init {
                    isRecordStarted = true
                    recorder.startListening()
                    recorder.startRecording()
                    
                    UIView.animate(withDuration: 0.2) {
                        bubbleView.snp.updateConstraints { (make) in
                            make.center.equalToSuperview()
                            make.width.equalTo(130)
                            make.height.equalTo(130)
                        }
                        
                        bubbleView.layer.cornerRadius = 65
                        bubbleView.layoutIfNeeded()
                    }
                }
                
                if let workItem = workItem {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
                }
                print("recordStarted")

            }
        }.onDeselected { [unowned self] _ in
            if isVoiceActive {
                Haptic.play([.haptic(.impact(.light))])
                if isRecordStarted {
                    recorder.stopAndSaveRecording()
                } else {
                    workItem?.cancel()
                }
                bb?.removeFromSuperview()
                isRecordStarted = false
            }
            
            print("recordEND")
        }
    }
    
    func makeSendButton() {
        isVoiceActive = false
        sendButton.configure({
            $0.image = UIImage(imageLiteralResourceName: "paper-plane")
            $0.title = ""
            $0.tintColor = .bgColor
            $0.removeHaptic(forControlEvents: .touchDown)
        }).onTouchUpInside {
            Haptic.play([.haptic(.impact(.light))])
            $0.inputBarAccessoryView?.didSelectSendButton()
        }.onDisabled {
            $0.isEnabled = true
        }.onDeselected { [unowned self] _ in
            
        }
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

extension ScribeInputView: FDSoundActivatedRecorderDelegate {
    func soundActivatedRecorderDidStartRecording(_ recorder: FDSoundActivatedRecorder) {
        print("recordStartedDelegate")
    }
    
    func soundActivatedRecorderDidTimeOut(_ recorder: FDSoundActivatedRecorder) {
        print("soundActivatedRecorderDidTimeOut")
    }
    
    func soundActivatedRecorderDidAbort(_ recorder: FDSoundActivatedRecorder) {
        print("soundActivatedRecorderDidAbort")
    }
    
    func soundActivatedRecorderDidFinishRecording(_ recorder: FDSoundActivatedRecorder, andSaved file: URL) {
        print("recordEndDelegate")
        print(file)
        recordDelegate?.successVoiceRecord(file: file)
    }
}
