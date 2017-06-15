//
//  DetailViewControllerTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/23.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class DetailViewControllerTest: XCTestCase {
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        _ = sut.view
        let itemManager = ItemManager()
        itemManager.removeAll()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.itemInfo?.0.removeAll()
        super.tearDown()
    }
    
    func test_HasTitleLabel()  {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func test_HasDateLabel()  {
        XCTAssertNotNil(sut.dateLabel)
    }
    
    func test_HasLocationLabel()  {
        XCTAssertNotNil(sut.locationLabel)
    }
    
    func test_HasDescriptionLabel()  {
        XCTAssertNotNil(sut.descriptionLabel)
    }
    
    func test_HasCheckButton()  {
        XCTAssertNotNil(sut.checkButton)
    }
    
    func test_HasMapView()  {
        XCTAssertNotNil(sut.mapView)
    }
    
    func test_SettingItemInfo_SetsTextsToLabel()  {
        let coordinate = CLLocationCoordinate2DMake(51.2277, 6.7735)
        let location = Location(name: "Foo", coordinate: coordinate)
        let item = ToDoItem(title: "Bar", itemDescription: "Baz", timestamp: 1456150025, location: location)
        let itemManager = ItemManager()
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "Bar")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.descriptionLabel.text, "Baz")
         XCTAssertEqual(sut.locationLabel.text, "Foo")
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, (location.coordinate?.latitude)!,accuracy: 0.001)
        
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.longitude, (location.coordinate?.longitude)!, accuracy: 0.001)
        
    }
    
    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
    
    
}
