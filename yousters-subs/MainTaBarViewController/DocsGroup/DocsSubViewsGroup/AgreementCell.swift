//
//  AgreementCell.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class AgreementCell: UITableViewCell {
    
    var agreement:Agreement
    
    let stackView = UIStackView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    init(reuseIdentifier:String?, agreement:Agreement) {
        self.agreement = agreement
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 40)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5.0
        
        let title = UILabel(text: agreement.title, font: Fonts.standart.gilroyMedium(ofSize: 21), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(title)
        
        let status = UILabel(text: agreement.status.getTitle(), font: Fonts.standart.gilroyRegular(ofSize: 14), textColor: .white, textAlignment: .left, numberOfLines: 1)
        
        let statusbgView = UIView()
        statusbgView.backgroundColor = agreement.status.getColor()
        statusbgView.layer.cornerRadius = 5
        statusbgView.clipsToBounds = true
        
        statusbgView.addSubview(status)
        
        status.fillSuperview(padding: .init(top: 4, left: 10, bottom: 4, right: 10))
        
        stackView.addArrangedSubview(statusbgView)
        
        accessoryType = .disclosureIndicator
        
//        textLabel?.text = agreement.title
//        textLabel?.font = Fonts.standart.gilroyMedium(ofSize: 21)
//        detailTextLabel?.text = agreement.status.getString()
//        detailTextLabel?.font = Fonts.standart.gilroyRegular(ofSize: 15)
        
    }
}
