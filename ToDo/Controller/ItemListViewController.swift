//
//  ItemListViewController.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/21.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    let itemManager = ItemManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSetable)!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager;
        
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(showDetails(sender:)),
                                                name: NSNotification.Name("ItemSelectedNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func showDetails(sender : NSNotification) -> Void {
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }
        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

    @IBAction func addItem(_ sender: Any) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
           present(nextViewController, animated: true, completion: nil)
            
            nextViewController.itemManager = self.itemManager
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
