//
//  ViewController.swift
//  swift_demo
//
//  Created by chenzeyu on 15/4/16.
//  Copyright © 2016 chenzeyu. All rights reserved.
//

import UIKit
import CZPicker

class ViewController: UIViewController {

    var fruits = [String]()
    var fruitImages = [UIImage]()
    var pickerWithImage: CZPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fruits = ["Apple", "Banana", "Grape", "Watermelon", "Lychee"]
        fruitImages = [UIImage(named: "Apple")!, UIImage(named: "Banana")!, UIImage(named: "Grape")!, UIImage(named: "Watermelon")!, UIImage(named: "Lychee")!]
        self.title = "CZPicker"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showWithFooter(sender: AnyObject) {
        let picker = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = true
        picker.show()
    }
    
    @IBAction func showWithoutFooter(sender: AnyObject) {
        let picker = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = false
        picker.show()
    }
    
    @IBAction func showWithMultipleSelections(sender: AnyObject) {
        let picker = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = false
        picker.allowMultipleSelection = true
        picker.show()
    }
    
    @IBAction func showWithImages(sender: AnyObject) {
        pickerWithImage = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        pickerWithImage?.delegate = self
        pickerWithImage?.dataSource = self
        pickerWithImage?.needFooterView = false
        pickerWithImage?.show()
    }
    
    @IBAction func showInsideContainer(snder: AnyObject) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let picker = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.show(self.view)
    }
}

extension ViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        if pickerView == pickerWithImage {
            return fruitImages[row]
        }
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return fruits.count
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return fruits[row]
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        print(fruits[row])
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerViewDidClickCancelButton(pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print(fruits[row])
            }
        }
    }
}

