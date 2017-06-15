//
//  ItemCell.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/22.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    func configCell(with item: ToDoItem, checked: Bool = false) -> Void {
        
        if checked {
            let attributeString = NSAttributedString(string: item.title, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
            
            titleLabel.attributedText = attributeString
            locationLabel.text = nil
            dateLabel.text = nil
            
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name
            if let timestamp = item.timestamp {
                let date = NSDate(timeIntervalSince1970:timestamp)
                
                dateLabel.text = dateFormatter.string(from: date as Date)
                
            }
        }
    }

}
