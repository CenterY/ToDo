//
//  ToDoItemTests.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/18.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init_WhenGivenTitle_SetsTitle() {
        let todoItem = ToDoItem(title: "Foo")
        
        XCTAssertEqual(todoItem.title, "Foo", "shoud set title")
    }
    
    func test_Init_WhenGivenDescription_SetsDescription() {
        let todoItem = ToDoItem(title: "",itemDescription: "Bar")
        
        XCTAssertEqual(todoItem.itemDescription, "Bar", "should set  itemDescription")
    }
    
    func test_Init_WhenGivenTimeStamp_SetsTimeStamp() {
        let todoItem = ToDoItem(title: "",itemDescription: "", timestamp: 0.0)
        
        XCTAssertEqual(todoItem.timestamp, 0.0, "should set  timestamp")
    }
    
    func test_Init_WhenGivenLocation_SetsLocation() {

        let location = Location(name: "Foo")
        let todoItem = ToDoItem(title: "",itemDescription: "", timestamp: 0.0, location: location)

        XCTAssertEqual(todoItem.location?.name, location.name, "should set  location")
    }
    
    func test_EqualItems_AreEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Foo")

        XCTAssertEqual(first, second)
    }
    
    func test_Items_WhenLocationDiffers_AreNotEqual() {
        let first = ToDoItem(title: "" , location: Location(name: "foo"))
        let second = ToDoItem(title: "", location: Location(name: "bar"))
        
        XCTAssertNotEqual(first, second)
        
        
    }
    
    func test_Items_WhenOneLocationIsNilAndTheotherIsnt_AreNotEqual() {
        var first = ToDoItem(title: "" , location: Location(name: "foo"))
        var second = ToDoItem(title: "", location:  nil)
        
         first = ToDoItem(title: "" , location: nil)
         second = ToDoItem(title: "", location:  Location(name: "foo"))
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenTimestampsDiffers_AreNotEqual() {
        let first = ToDoItem(title: "" , timestamp: 1.0)
        let second = ToDoItem(title: "", timestamp: 0.0)
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenDescriptionsDiffers_AreNotEqual() {
        let first = ToDoItem(title: "" , itemDescription: "Bar")
        let second = ToDoItem(title: "", itemDescription: "Barz")
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenTitleDiffers_AreNotEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Bar")
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "Foo")
        let dictionary = item.plistDictionary
        
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is  [String : Any])
    }
    
    func test_CanbeCreatedFromPlistDictionary() {
        let location = Location(name: "Bar")
        let item = ToDoItem(title: "Foo",itemDescription: "Baz",
                timestamp: 1.0,
            location: location)
        
        let dictionary = item.plistDictionary
        
        let recreatedItem = ToDoItem(dict: dictionary)
        XCTAssertEqual(item, recreatedItem)
        
        
    }
}
