//
//  ExpenseCategoryViewController.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 15/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

protocol ExpenseCategoryViewControllerDelegate
{
    func sendSelectedCategory(category : ExpenseCatagory)
}

class ExpenseCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var delegate:ExpenseCategoryViewControllerDelegate!
    
    @IBOutlet weak var txtExpenseCategory: UITextField!
    @IBOutlet weak var btnRefreshColor: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var expenseCategories:[ExpenseCatagory] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnRefreshColor.backgroundColor = UIColor.randomColor()
        expenseCategories = DataStoreManager.sharedInstance.getExpenseCategory()
        
        categoryTableView.delegate = self;
        categoryTableView.dataSource = self;
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        btnRefreshColor.backgroundColor = UIColor.randomColor()
    }
    
    @IBAction func addCategoryAction(_ sender: Any) {
        if txtExpenseCategory.text == "" {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter category name", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        if DataStoreManager.sharedInstance.getExpenseCategoryFor(categoryName: txtExpenseCategory.text!) != nil{
            let errorAlert = UIAlertController(title: "Error", message: "Category already exist with same name", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        else{
            if DataStoreManager.sharedInstance.addExpenseCategory(expenseCategoryName: txtExpenseCategory.text!, color: btnRefreshColor.backgroundColor!) {
                
                btnRefreshColor.backgroundColor = UIColor.randomColor()
                txtExpenseCategory.text         = nil
                expenseCategories = DataStoreManager.sharedInstance.getExpenseCategory()
                categoryTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Expense Category"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")! as UITableViewCell
        
        let expenseCategory:ExpenseCatagory = expenseCategories[indexPath.row]
        let categoryLabel:UILabel    = cell.viewWithTag(100) as! UILabel
        let colorView:UIView         = cell.viewWithTag(101)!
        categoryLabel.text   = expenseCategory.categoryName
        colorView.backgroundColor = UIColor.color(withData: expenseCategory.categoryColor as! Data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (delegate != nil) {
            delegate.sendSelectedCategory(category: expenseCategories[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
    }

}
