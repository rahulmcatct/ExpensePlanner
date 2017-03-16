//
//  BankAccountViewController.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 12/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

class BankAccountViewController: UIViewController {

    @IBOutlet weak var lblBankAccountBalance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBankAccountBalance.text = "$\(DataStoreManager.sharedInstance.getBankAccountBalance().description)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateBankBalance(_ sender: Any) {
        let alertController = UIAlertController(title: "Bank Account", message: "Please enter your updated bank account balance!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            alert -> Void in
            let balance = alertController.textFields![0] as UITextField
            
            if balance.text != "" {
                self.updateAccountBalance(amountString: balance.text!)
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please enter account balance", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Balance"
            textField.textAlignment = .center
            textField.keyboardType = .decimalPad
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateAccountBalance(amountString:String) {
        
        if Double(amountString) == nil {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter valid balance", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        if Double(amountString)! > 99999999999.0  {
            let errorAlert = UIAlertController(title: "Error", message: "Please enter valid balance e.g. 99999999999(max)", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        let amount : Decimal = Decimal(floatLiteral: Double(amountString)!)
        if DataStoreManager.sharedInstance.updateBankAccountBalance(amount) {
            lblBankAccountBalance.text = "$\(DataStoreManager.sharedInstance.getBankAccountBalance().description)"
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
