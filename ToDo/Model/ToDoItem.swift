//
//  ToDoItem.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/18.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

struct ToDoItem: Equatable {

    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    init(title: String,
         itemDescription: String? = nil,
         timestamp: Double? = nil,
        location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    private let titleKey = "titleKey"
    private let itemDescriptionKey = "itemDescriptionKey"
    private let timestampKey = "timestampKey"
    private let locationKey = "locationKey"
    
    init?(dict: [String: Any]) {
        guard let title = dict[titleKey] as? String else { return nil
        }
        self.title = title
        
        self.itemDescription = dict[itemDescriptionKey] as? String
        
        self.timestamp = dict[timestampKey] as? Double
        
        if let locationdict = dict[locationKey] as? [String: Any] {
            self.location = Location(dict: locationdict)
        } else{
            self.location = nil
        }
    }
    
    var plistDictionary: [String: Any] {
        var dict = [String: Any]()
        dict[titleKey] = title
        
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription
        }
        
        if let timestamp = timestamp {
            dict[timestampKey] = timestamp
        }
        
        if let location = location {
            dict[locationKey] = location.plistDict
        }
        
        return dict
    }
    
}

func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
    if lhs.location != rhs.location {
        return false
    }
    if lhs.timestamp != rhs.timestamp {
        return false
    }
    
    if lhs.itemDescription != rhs.itemDescription {
        return false
    }
    
    if lhs.title != rhs.title {
        return false
    }
    
    return true
}
