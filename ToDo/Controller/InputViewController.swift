//
//  InputViewController.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/24.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import UIKit
import CoreLocation
class InputViewController: UIViewController {

    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!


    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction  func save() {
        guard let titleString = titleTextField.text, titleString.characters.count > 0 else {
            return
        }
        var date: Date?
        if let dateText = dateTextField.text, dateText.characters.count > 0 {
            date = dateFormatter.date(from: dateText)
            let zone = TimeZone.current
            date = date?.addingTimeInterval(TimeInterval(zone.secondsFromGMT()) )
            
        } else {
            date = nil
        }
        
        let descriptionString = descriptionTextField.text
        
        if let locationName = locationTextField.text, locationName.characters.count > 0 {
            if let address = addressTextField.text, address.characters.count > 0 {
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: 1456095600.0, location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))
                    self.itemManager?.add(item)
                }
            }
        } else {
            let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: 1456095600.0, location: nil)
            self.itemManager?.add(item)
            
    }
        dismiss(animated: true, completion: nil)
    }

}
