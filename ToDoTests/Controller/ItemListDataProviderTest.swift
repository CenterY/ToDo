//
//  ItemListDataProviderTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/22.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTest: XCTestCase {
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var viewController: ItemListViewController!

    override func setUp() {
        super.setUp()
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = viewController.view
tableView = viewController.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.itemManager?.removeAll()
        super.tearDown()
    }
    
    func test_NumberOfSections_IsTwo () {
        
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2)
        
    }
    
    func test_NumberOfRowsInSectionZero_IsToDoCount () {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0) , 1)
        sut.itemManager?.add(ToDoItem(title: "Bar"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
        
    }
    
    func test_NumberOfRowsInSecondSection_IsDoneCount() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        sut.itemManager?.add(ToDoItem(title: "Bar"))
        sut.itemManager?.checkItem(at: 0)
   
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.itemManager?.checkItem(at: 0)
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func test_CellForRow_ReturnsItemCell() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0,section: 0))
        
        XCTAssertTrue(cell is ItemCell)
    }
    
    func test_CellForRow_DequeuesCellFromTableView() {
        
        let mockTableView = MockTableView.mockTabelView(withDataSource: sut)
        
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0,section: 0))
        
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func test_CellForRow_CallsConfigCell() {
        
        let mockTableView = MockTableView.mockTabelView(withDataSource: sut)
        
        let item = ToDoItem(title: "")
        sut.itemManager?.add(item)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0,section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.catchedItem,item )
    }
    
    func test_CellForRow_InSectionTwo_CallsConfigCellWithDoneIten() {
        let mockTableView = MockTableView.mockTabelView(withDataSource: sut)
        
        let firstItem = ToDoItem(title: "Foo")
        sut.itemManager?.add(firstItem)
        
        let secondIten = ToDoItem(title: "Bar")
        sut.itemManager?.add(secondIten)
        
        sut.itemManager?.checkItem(at: 1)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        
        XCTAssertEqual(cell.catchedItem, secondIten)
        
    }
    
    func test_DeleteButton_InFirstSection_ShowsTitleCheck() {
        let deleteTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section:0))
        
        XCTAssertEqual(deleteTitle, "Check")
        
    }
    
    func test_DeleteButton_InSecondSection_ShowsTitleUnCheck() {
        let deleteTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section:1))
        
        XCTAssertEqual(deleteTitle, "UnCheck")
        
    }
    
    func test_CheckAnItem_ChecksItInItemManager() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }
    
    func test_UnCheckingAnItem_UnChecksItInItemManager() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        sut.itemManager?.checkItem(at: 0)
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }
    
    func test_SelectingACell_SentNotification() {
        let item = ToDoItem(title: "Foo")
        sut.itemManager?.add(item)
        
        expectation(forNotification: "selectCell", object: nil) { (notification) -> Bool in
            
            guard let index = notification.userInfo?["index"] as? Int else {
                return false
            }
            return index == 0
        }
        
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}

extension ItemListDataProviderTest {
    class MockTableView: UITableView {
        var cellGotDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        class func mockTabelView(withDataSource dataSource: ItemListDataProvider) ->MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            
            return mockTableView
            
        }
        
    }
    
    class MockItemCell: ItemCell {
        var catchedItem: ToDoItem?
        
        override func configCell(with item: ToDoItem, checked: Bool = false) -> Void {
            catchedItem = item
        }
        
    }
}
