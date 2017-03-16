//
//  IncomeViewController.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 12/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

class IncomeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var txtIncomeDescription: UITextField!
    @IBOutlet weak var btnIncomeType: UIButton!
    @IBOutlet weak var txtIncomeAmount: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var incomeArray:[Income] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        // Get all incomes from Data Store
        incomeArray = DataStoreManager.sharedInstance.getIncomes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeIncomeType(_ sender: Any) {
        if self.btnIncomeType.tag == 0 {
            self.btnIncomeType.setTitle("Income Type: Recurring", for: .normal)
            self.btnIncomeType.tag = 1
        }
        else{
            self.btnIncomeType.setTitle("Income Type: AdHoc", for: .normal)
            self.btnIncomeType.tag = 0
        }
    }
    
    
    @IBAction func addIncomeAction(_ sender: Any) {
        
        if txtIncomeDescription.text == "" {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter income description", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }

        if Double(txtIncomeAmount.text!) == nil {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter valid amount", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        if Double(txtIncomeAmount.text!)! > 99999999999.0 || Double(txtIncomeAmount.text!)! < 0 {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter valid amount e.g. 99999999999(max)", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        let amount : Decimal = Decimal(floatLiteral: Double(txtIncomeAmount.text!)!)
        guard DataStoreManager.sharedInstance.addIncome(incomeDescription: txtIncomeDescription.text!, isRecurring: self.btnIncomeType.tag == 1 ? true : false , amount: amount) else {
            print("Error in Add Income")
            return
        }

        resetForm()
        
        incomeArray = DataStoreManager.sharedInstance.getIncomes()
        tableView.reloadData()
    }
    
    func resetForm() {
        
        // Reset form to initial blank state
        txtIncomeDescription.text   = ""
        txtIncomeAmount.text        = ""
        self.btnIncomeType.setTitle("Income Type: AdHoc", for: .normal)
        self.btnIncomeType.tag      = 0
    }
    
    // TableView data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Income List"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell")!
        
        let income:Income = incomeArray[indexPath.row]

        let descriptionLabel:UILabel    = cell.viewWithTag(100) as! UILabel
        let amountLabel:UILabel         = cell.viewWithTag(101) as! UILabel
        let recurringTypeLabel:UILabel  = cell.viewWithTag(102) as! UILabel
        
        descriptionLabel.text   = income.incomeDescription
        amountLabel.text        = "$\(String(describing: income.amount!))"
        recurringTypeLabel.text = income.isRecurring ? "Recurring" : "AdHoc"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataStoreManager.sharedInstance.deleteIncome(income: incomeArray[indexPath.row]) ? print("Deleted") : print("Error!")
            incomeArray = DataStoreManager.sharedInstance.getIncomes()
            tableView.reloadData()

        }
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
