//
//  ItemManager.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/19.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import UIKit

class ItemManager: NSObject {
    
    override init() {
        super.init()
        
        if let nsToDoItems = NSArray.init(contentsOf: todoPathURL) {
            for dict in nsToDoItems {
                if let todoItem = ToDoItem(dict: dict as! [String: Any]) {
                   toDoItems.append(todoItem)
                }
            }
        }
        
        if let nsDoneItems = NSArray.init(contentsOf: donePathURL) {
            for dict in nsDoneItems {
                if let todoItem = ToDoItem(dict: dict as! [String: Any]) {
                    doneItems.append(todoItem)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    var toDoCount: Int {
        return toDoItems.count
    }
    var doneCount: Int {
        return doneItems.count
    }
    private var toDoItems: [ToDoItem] = []
    private var doneItems: [ToDoItem] = []
    func add(_ item: ToDoItem) {
        
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }
    
    var todoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {  fatalError() }
        
        return documentURL.appendingPathComponent("ToDoItems.plist")
    }
    
    var donePathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {  fatalError() }
        
        return documentURL.appendingPathComponent("DoneItems.plist")
    }
    
    
    func save()  {
        let nsToDoItems = toDoItems.map { $0.plistDictionary
        }
        
        guard nsToDoItems.count > 0 else {
            try? FileManager.default.removeItem(at: todoPathURL)
            return
        }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: nsToDoItems, format: PropertyListSerialization.PropertyListFormat.xml,
            options: PropertyListSerialization.WriteOptions(0))
            
            try plistData.write(to: todoPathURL, options: Data.WritingOptions.atomic)
        } catch  {
            print(error)
        }
        
        let nsDoneItems = doneItems.map { $0.plistDictionary
        }
        
        guard nsDoneItems.count > 0 else {
            try? FileManager.default.removeItem(at: donePathURL)
            return
        }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: nsDoneItems, format: PropertyListSerialization.PropertyListFormat.xml,
                                                               options: PropertyListSerialization.WriteOptions(0))
            
            try plistData.write(to: donePathURL, options: Data.WritingOptions.atomic)
        } catch  {
            print(error)
        }
        
    }
    
    
    
    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func checkItem(at index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func unCheckItem(at index: Int) {
       let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }
    
    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func removeAll() -> Void {
        toDoItems.removeAll()
        doneItems.removeAll()
        try? FileManager.default.removeItem(at: todoPathURL)
        try? FileManager.default.removeItem(at: donePathURL)
    }
}
