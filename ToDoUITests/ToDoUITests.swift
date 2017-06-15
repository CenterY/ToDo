//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by hanbaoyu on 2017/4/7.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let app = XCUIApplication()
//        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
//        
//        let titleTextField = app.textFields["title"]
//        titleTextField.tap()
//        titleTextField.typeText("tiilte")
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
//        
//        let dateTextField = app.textFields["date"]
//        dateTextField.tap()
//        
//        dateTextField.typeText("111")
//        
//        dateTextField.typeText("12/2016")
//        
//        let locationTextField = app.textFields["location"]
//        locationTextField.tap()
//        
//        
//        locationTextField.typeText("➍➍➋➍➍")
//
//        
//        let descriptionTextField = app.textFields["description"]
//        descriptionTextField.tap()
//        descriptionTextField.typeText("➍➏➍➍➎➍➎")
//        
//        let addressTextField = app.textFields["address"]
//        addressTextField.tap()
//        
//        addressTextField.typeText("➍➋➍")

        
    }
    
}
