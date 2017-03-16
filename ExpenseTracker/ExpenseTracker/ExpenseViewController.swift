//
//  ExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 12/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController, UITableViewDataSource,ExpenseCategoryViewControllerDelegate {
    
    @IBOutlet weak var txtExpenseDescription: UITextField!
    @IBOutlet weak var btnExpenseType: UIButton!
    @IBOutlet weak var btnExpenseCategory: UIButton!
    @IBOutlet weak var txtExpenseAmount: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var expenseArray:[Expense] = []
    var selectedCategory : ExpenseCatagory?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        // Get all expenses from Data Store
        expenseArray = DataStoreManager.sharedInstance.getExpenses()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeExpenseType(_ sender: Any) {
        if self.btnExpenseType.tag == 0 {
            self.btnExpenseType.setTitle("Expense Type: Recurring", for: .normal)
            self.btnExpenseType.tag = 1
        }
        else{
            self.btnExpenseType.setTitle("Expense Type: AdHoc", for: .normal)
            self.btnExpenseType.tag = 0
        }
    }
    
    
    @IBAction func addExpenseAction(_ sender: Any) {
        if validateForm() {
            let amount : Decimal = Decimal(floatLiteral: Double(txtExpenseAmount.text!)!)
            guard DataStoreManager.sharedInstance.addExpense(expenseDescription:txtExpenseDescription.text!, isRecurring: self.btnExpenseType.tag == 1 ? true : false, amount: amount,category: selectedCategory!) else {
                print("Error in Add Expense")
                return
            }
            resetForm()
        }
    }
    
    func validateForm() -> Bool {
        if txtExpenseDescription.text == "" {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter expense description", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return false
        }
        
        if Double(txtExpenseAmount.text!) == nil {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter valid amount", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return false
        }
        
        if Double(txtExpenseAmount.text!)! > 99999999999.0 || Double(txtExpenseAmount.text!)! < 0  {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter valid amount e.g. 99999999999(max)", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return false
        }
        
        if selectedCategory == nil {
            let errorAlert = UIAlertController(title: "Error", message: "Please select expense category", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return false
        }

        return true
    }
    
    func resetForm() {
        
        // Reset form to initial blank state
        txtExpenseDescription.text   = ""
        txtExpenseAmount.text        = ""
        self.btnExpenseType.setTitle("Expense Type: AdHoc", for: .normal)
        self.btnExpenseType.tag = 0
        btnExpenseCategory.setTitle("Add Expense Category", for: .normal)
        btnExpenseCategory.setTitleColor(btnExpenseCategory.tintColor, for: .normal)
        selectedCategory = nil
        
        // Refresh Table
        expenseArray = DataStoreManager.sharedInstance.getExpenses()
        tableView.reloadData()

    }
    
    // TableView data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Expense List"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell")!
        
        let expense:Expense = expenseArray[indexPath.row]
        
        let descriptionLabel:UILabel    = cell.viewWithTag(100) as! UILabel
        let amountLabel:UILabel         = cell.viewWithTag(101) as! UILabel
        let recurringTypeLabel:UILabel  = cell.viewWithTag(102) as! UILabel
        let categoryLabel:UILabel       = cell.viewWithTag(103) as! UILabel
        
        descriptionLabel.text   = expense.expenseDescription
        amountLabel.text        = "$\(String(describing: expense.amount!))"
        recurringTypeLabel.text = expense.isRecurring ? "Recurring" : "AdHoc"
        categoryLabel.text      = expense.expenseCatagory?.categoryName
        categoryLabel.textColor = UIColor.color(withData: expense.expenseCatagory?.categoryColor! as! Data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataStoreManager.sharedInstance.deleteExpense(expense: expenseArray[indexPath.row]) ? print("Deleted") : print("Error!")
            expenseArray = DataStoreManager.sharedInstance.getExpenses()
            tableView.reloadData()
        }
    }
    
    func sendSelectedCategory(category: ExpenseCatagory) {
        selectedCategory = category
        btnExpenseCategory.setTitle("Category: \(category.categoryName!)", for: .normal)
        btnExpenseCategory.setTitleColor(UIColor.color(withData: category.categoryColor as! Data), for: .normal)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let modalVC:ExpenseCategoryViewController =  segue.destination as? ExpenseCategoryViewController {
            modalVC.delegate=self;
        }
     }
    
}
