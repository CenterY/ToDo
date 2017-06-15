//
//  ItemCellTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/23.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemCellTest: XCTestCase {
    var sut: ItemCell!
    var tableView: UITableView!
    let dataSource = FakeDataSource()
    
    
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = viewController.view
        
        tableView = viewController.tableView
        tableView?.dataSource = dataSource
        
        sut = tableView?.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasNameLabel() {
        
        
        XCTAssertNotNil(sut.titleLabel)
        
        
    }
    
    func test_HasLocationLabel() {
       
        XCTAssertNotNil(sut.locationLabel)
        
    }
    
    func test_HasDateLabel() {
        
        XCTAssertNotNil(sut.dateLabel)
        
    }
    
    func test_ConfigCell_SetsLabelsText() {
        
        let location = Location(name: "Bar")
        let item = ToDoItem(title: "Foo", itemDescription: nil, timestamp:1456150025, location:location)
        
        sut.configCell(with: item)
        XCTAssertEqual(sut.titleLabel.text, "Foo")
        XCTAssertEqual(sut.locationLabel.text, "Bar")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
    }
    
    func test_Title_WhenIsChecked_IsStrokeThrouth()  {
        let location = Location(name: "Bar")
        let item = ToDoItem(title: "Foo", itemDescription: nil, timestamp:1456150025, location:location)
        
        sut.configCell(with: item, checked: true)
        
        let attributeString = NSAttributedString(string: "Foo" , attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        XCTAssertEqual(sut.titleLabel.attributedText, attributeString)
        XCTAssertNil(sut.locationLabel.text)
        XCTAssertNil(sut.dateLabel.text)
    }
    
}

extension ItemCellTest{
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
