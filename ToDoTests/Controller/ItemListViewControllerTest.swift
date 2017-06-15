//
//  ItemListViewControllerTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/21.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo


class ItemListViewControllerTest: XCTestCase {
    var sut: ItemListViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
        sut = viewController as! ItemListViewController
        _ = sut.view

        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_TableView_AfterViewDidLoad_IsNotNil() {
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_TableView_SetTableViewDataSource() {
        
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func test_ItenListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
        
    }
    
    func test_AddItem_PresentAddItemViewController() {
        presentInputViewController()
        XCTAssertNotNil(sut.presentedViewController)
XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputVC = sut.presentedViewController as? InputViewController
        
        XCTAssertNotNil(inputVC?.titleTextField)
        
    }
    
    func test_ItemListVC_SharesItemManagerWithInputVC() {
       
        presentInputViewController()
        guard let inputVC = sut.presentedViewController as? InputViewController else { XCTFail()
        return}
        
        guard let inputItemManager = inputVC.itemManager else { XCTFail()
            return  }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
        
    }
    
    func presentInputViewController() {
        UIApplication.shared.keyWindow?.rootViewController = sut
        XCTAssertNil(sut.presentedViewController)
        
        guard let action = sut.navigationItem.rightBarButtonItem?.action else { return XCTFail()
        }
        
        sut.performSelector(onMainThread: action, with: nil, waitUntilDone: true)
    }
    
    func test__ViewDidLoad_SetItemManagerToDataPorvieder() {
        XCTAssertEqual(sut.itemManager, sut.dataProvider.itemManager)
    }
    
    func test_ViewWillAppear_TabelViewReloaded() {
        let mockTableView = MockTableView();
        sut.tableView = mockTableView
        sut.tableView.delegate = sut.dataProvider
        sut.tableView.dataSource = sut.dataProvider
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertTrue((sut.tableView as! MockTableView).hasReloaded)
    }
    
    func test_ItemCellSelectedNotification_PushDetailVC() {
        let mockNavigationViewController = MockNavigationViewController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationViewController
        
        _ = sut.view
        
        NotificationCenter.default.post(name: NSNotification.Name("ItemSelectedNotification"), object: self, userInfo: ["index": 1])
        guard let detailViewController = mockNavigationViewController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        guard let detailItemManager = detailViewController.itemInfo?.0 else {
            XCTFail()
            return
        }
        
        guard let index = detailViewController.itemInfo?.1 else {
            XCTFail()
            return  }
        
        _ = detailViewController.view
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        
        XCTAssertEqual(index, 1)
    }
    
}

class MockTableView: UITableView {
    var hasReloaded = false;
    
    override func reloadData() {
        hasReloaded = true;
    }
}

extension ItemListViewControllerTest {
    class MockNavigationViewController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            
            super.pushViewController(viewController, animated: animated)
        }
        
    }
}

