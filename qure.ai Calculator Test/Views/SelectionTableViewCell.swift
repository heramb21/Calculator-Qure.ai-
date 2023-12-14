//
//  SelectionTableViewCell.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 14/12/23.
//

import UIKit
import SwiftUI

class SelectionTableViewCell: UITableViewCell {
    
    static let identifier = "SelectionTableViewCell"

    var rightImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(rightImage)
        
        rightImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        rightImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
    
    func configure(isSelected: Bool, colour: UIColor) {
        if isSelected {
            rightImage.image = UIImage(systemName: "checkmark")
            rightImage.tintColor = colour
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
