//
//  ItemManagerTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/19.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTest: XCTestCase {
    var sut: ItemManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = ItemManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.removeAll()
        sut = nil
        super.tearDown()
    }
    
    func test_ToDoCount_Initially_IsZero() {
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    func test_DoneCount_Initially_IsZero() {
        XCTAssertEqual(sut.doneCount, 0)
    }
    
    func test_AddItem_IncreasesToDoCountOne() {
        sut.add(ToDoItem(title: ""))
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func test_ItemAt_AfterAddingAnItem_ReturnsThatItem() {
        let item = ToDoItem(title: "Foo")
        sut.add(item)
        
        let returnedItem: ToDoItem = sut.item(at: 0)
        
        XCTAssertEqual(item.title, returnedItem.title)
    }
    
    func test_CheckItemAt_ChangesCounts() {
        sut.add(ToDoItem(title: ""))
        
            sut.checkItem(at: 0)
        
        XCTAssertEqual(sut.toDoCount, 0)
        XCTAssertEqual(sut.doneCount, 1)
    }
    
    func test_CheckItemAt_RemoveItemFromToDoItems() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.add(firstItem)
        sut.add(secondItem)
        
        sut.checkItem(at: 0)
        
        XCTAssertEqual(sut.item(at: 0).title, "Second")
    }
    
    func test_DomeItemAt_ReturnsCheckedItem() {
        let item = ToDoItem(title: "foo")
        
        sut.add(item)
        sut.checkItem(at: 0)
        
        let returnedItem = sut.doneItem(at: 0)
        XCTAssertEqual(item.title, returnedItem.title)
    }
    
    func test_RemoveAll_ResultsInCountsBeZero() {
        sut.add(ToDoItem(title: "Foo"))
        sut.add(ToDoItem(title: "Bar"))
        
        sut.checkItem(at: 0)
        
        XCTAssertEqual(sut.toDoCount, 1)
        XCTAssertEqual(sut.doneCount, 1)
        
        sut.removeAll()
        
        XCTAssertEqual(sut.toDoCount, 0)
        XCTAssertEqual(sut.doneCount, 0)
        
    }
    
    func test_All_WhenItemIsAlreadyAdded_DoesNotIncreaseCount() {
        sut.add(ToDoItem(title: "Foo"))
        sut.add(ToDoItem(title: "Foo"))
        
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func test_ToDoItemsGetSeriialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager!.add(firstItem)
        
        let secondItem = ToDoItem(title: "Second")
        itemManager!.add(secondItem)
        
        NotificationCenter.default.post(name: .UIApplicationWillResignActive, object: nil, userInfo: nil)
        
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.item(at: 0), firstItem)
        XCTAssertEqual(itemManager?.item(at: 1), secondItem)
        
    }
    
    func test_DoneItemsGetSeriialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager!.add(firstItem)
        
        let secondItem = ToDoItem(title: "Second")
        itemManager!.add(secondItem)
        
        itemManager?.checkItem(at: 0)
        
        NotificationCenter.default.post(name: .UIApplicationWillResignActive, object: nil, userInfo: nil)
        
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        
        XCTAssertEqual(itemManager?.doneCount, 1)
        XCTAssertEqual(itemManager?.doneItem(at: 0), firstItem)
        XCTAssertEqual(itemManager?.item(at: 0), secondItem)
        
    }
}
