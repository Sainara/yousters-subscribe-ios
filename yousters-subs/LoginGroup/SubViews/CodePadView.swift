//
//  CodePadView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 18.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import Haptica
import LocalAuthentication

class CodePadView: UIView {
    
    let delegate:EnterCodePadDelegate
    
    let rowsStackView = UIStackView()
    
    let isInCreate:Bool
    
    init(delegate:EnterCodePadDelegate, isInCreate:Bool) {
        self.isInCreate = isInCreate
        self.delegate = delegate
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        rowsStackView.spacing = 0
        rowsStackView.distribution = .fillEqually
        rowsStackView.alignment = .center
        rowsStackView.axis = .vertical
        addSubview(rowsStackView)
        rowsStackView.fillSuperview()
        
        setupLine(line: .first)
        setupLine(line: .second)
        setupLine(line: .third)
        setupLine(line: .last)
        //           renderCirlce()
    }
    
    private func setupLine(line:PadLines) {
        
        let stackView = UIStackView()
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        
        
        switch line {
        case .first:
            stackView.addArrangedSubview(PadButton(digit: 1, delegate: delegate))
            stackView.addArrangedSubview(PadButton(digit: 2, delegate: delegate))
            stackView.addArrangedSubview(PadButton(digit: 3, delegate: delegate))
            
        case .second:
            stackView.addArrangedSubview(PadButton(digit: 4, delegate: delegate))
            stackView.addArrangedSubview(PadButton(digit: 5, delegate: delegate))
            stackView.addArrangedSubview(PadButton(digit: 6, delegate: delegate))
            
        case .third:
            stackView.addArrangedSubview(PadButton(digit: 7, delegate: delegate))
            stackView.addArrangedSubview(PadButton(digit: 8, delegate: delegate))
            stackView.addArrangedSubview(PadButton(digit: 9, delegate: delegate))
            
        case .last:
            stackView.addArrangedSubview(PadButton(type: .biometry, delegate: delegate, isNeedBiometry: !isInCreate))
            stackView.addArrangedSubview(PadButton(digit: 0, delegate: delegate))
            stackView.addArrangedSubview(PadButton(type: .delete, delegate: delegate))

        }

        rowsStackView.addArrangedSubview(stackView)
        
    }
    
    enum PadLines {
        case first, second, third, last
    }
    
}

class PadButton: UIView {
    
    let context = LAContext()
    
    let delegate:EnterCodePadDelegate
    
    let type:ButtonType
    var digit:Int = 0
    
    init(digit:Int, delegate:EnterCodePadDelegate) {
        self.type = .digit
        self.digit = digit
        self.delegate = delegate
        super.init(frame: .zero)
        sameInit()
        setupDigit()
        addTap()
    }
    
    init(type:ButtonType, delegate:EnterCodePadDelegate, isNeedBiometry:Bool = true) {
        self.type = type
        self.delegate = delegate
        super.init(frame: .zero)
        sameInit()
        setupBiometryOrDelete()
        
        if type == .delete {
            addTap()
        } else if type == .biometry {
            if (context.biometryType == .faceID || context.biometryType == .touchID) && isNeedBiometry  {
                addTap()
            }
        }
    }
    
    private func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    private func sameInit() {
        snp.makeConstraints { (make) in
            make.height.equalTo(75)
            make.width.equalTo(75)
        }
    }
    
    private func setupDigit() {
        let label = UILabel(text: String(digit), font: Fonts.standart.gilroyMedium(ofSize: 40), textColor: .bgColor, textAlignment: .center, numberOfLines: 1)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBiometryOrDelete() {
        let imageView = UIImageView()
        //imageView.con
        addSubview(imageView)
        
        if type == .biometry {
            switch context.biometryType {
            case .faceID:
                imageView.image = UIImage(imageLiteralResourceName: "faceID")
            case .touchID:
                imageView.image = UIImage(imageLiteralResourceName: "touchID")
            default:
                break
            }
        }
        
        if type == .delete {
            imageView.image = UIImage(imageLiteralResourceName: "removeChar")
        }
        
        imageView.fillSuperview(padding: .allSides(20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped() {
        Haptic.play([.haptic(.impact(.light))])
        switch type {
        case .digit:
            delegate.digitClicked(digit: digit)
        case .biometry:
            delegate.biometryClicked()
        case .delete:
            delegate.removeCliced()
        }
    }
    
    enum ButtonType {
        case digit, delete, biometry
    }
}
