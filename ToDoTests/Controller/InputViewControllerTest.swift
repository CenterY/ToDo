//
//  InputViewControllerTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/24.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation
class InputViewControllerTest: XCTestCase {
    
    var sut: InputViewController!
    var placeMark: MockPlacemark!
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale.current
        return formatter
    }()
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.itemManager?.removeAll()
        super.tearDown()
    }
    
    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasDateLabel()  {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationLabel()  {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasDescriptionLabel()  {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasSaveButton()  {
        XCTAssertNotNil(sut.saveButton)
    }
    
    func test_HasCancelButton()  {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func test_Save_UsesGerCodeToGetCoordinateFromAddress() {

        let timestamp = 1456095600.0
        let date = Date(timeIntervalSince1970: timestamp)
        let dateString = dateFormatter.string(from: date)

        sut.titleTextField.text = "Foo"
        sut.dateTextField.text = dateString
        sut.descriptionTextField.text = "Baz"
        sut.locationTextField.text = "Bar"
        sut.addressTextField.text = "address"

        let mockGeoCoder = MockGeoCoder()
        sut.geocoder = mockGeoCoder
        sut.itemManager = ItemManager()
        sut.save()
        
        placeMark = MockPlacemark()
        let coordinate = CLLocationCoordinate2D(latitude:37.3316851 , longitude:-122.0300674)
        placeMark.mockCoordinate = coordinate
        mockGeoCoder.completeHandlerr?([placeMark], nil)
        
        let item = sut.itemManager?.item(at: 0)
        let testItem = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp:timestamp,location: Location(name: "Bar", coordinate: coordinate) )
        
        XCTAssertEqual(item, testItem)
        
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail();return
        }
        
        XCTAssertTrue(actions.contains("save"))
        
    }
    
    func xtest_GeoCoder_FetchsCoordinate() {
        let geocoder = CLGeocoder()
        let geocoderAnswered = expectation(description: "GeoCoder")
        
        geocoder.geocodeAddressString("晨晖路828弄") { (placeMarks, error) in
            let coordinate = placeMarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqualWithAccuracy(latitude, 31.1999, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(longitude, 121.5977, accuracy: 0.0001)
            
            geocoderAnswered.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSave_DismissViewController() {
        let mockInputVC = MockInputViewController()
        mockInputVC.titleTextField = UITextField()
        mockInputVC.addressTextField = UITextField()
        mockInputVC.locationTextField = UITextField()
        mockInputVC.dateTextField = UITextField()
        mockInputVC.descriptionTextField = UITextField()
        mockInputVC.titleTextField.text = "sfdsf"
        
        mockInputVC.save()
        
        XCTAssertTrue(mockInputVC.dismissIsCallED)
    }
}

extension InputViewControllerTest {
    class MockGeoCoder: CLGeocoder {
        var completeHandlerr: CLGeocodeCompletionHandler?
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completeHandlerr = completionHandler
        }
        
    }
    
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else {
                return CLLocation()
            }
            
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
    }
    
    class MockInputViewController: InputViewController {
        var dismissIsCallED = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissIsCallED = true
        }
    }
}
