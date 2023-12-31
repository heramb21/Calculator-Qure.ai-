//
//  TextTableViewCell.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 14/12/23.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    static let identifier = "TextTableViewCell"
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rightLabel)
        
        rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
    
    func configure(rightText: String) {
        rightLabel.text = rightText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

