//
//  ReportViewController.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 12/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

import PieCharts


class ReportViewController: UIViewController, UITableViewDataSource, PieChartDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartBaseView: UIView!

    var chartView: PieChart?
    
    var totalAdHocIncome        = 0.0
    var totalRecurringIncome    = 0.0
    var totalAdHocExpeses       = 0.0
    var totalRecurringExpeses   = 0.0
    var bankAccountBalance      = 0.0
    
    let noOfMonths              = 12
    
    var chartLegendText:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalAdHocIncome            = DataStoreManager.sharedInstance.getAdHocIncomesTotal()
        totalRecurringIncome        = DataStoreManager.sharedInstance.getRecurringIncomesTotal()

        totalAdHocExpeses           = DataStoreManager.sharedInstance.getAdHocExpensesTotal()
        totalRecurringExpeses       = DataStoreManager.sharedInstance.getRecurringExpensesTotal()

        bankAccountBalance          = DataStoreManager.sharedInstance.getBankAccountBalance()
        
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if((chartView?.superview) != nil){
            chartView?.removeFromSuperview()
            chartView = nil
        }
        chartView  = PieChart(frame: chartBaseView.bounds)
        chartBaseView.addSubview(chartView!)
        chartView?.layers = [createCustomViewsLayer(), createTextLayer()]
        chartView?.innerRadius  = 0.0
        chartView?.outerRadius  = chartBaseView.bounds.size.width * 0.5
        chartView?.delegate = self
        chartView?.models = createModels() // order is important - models have to be set at the end
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noOfMonths
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bank Account Balance"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell")!
        
        let monthLable:UILabel    = cell.viewWithTag(100) as! UILabel
        let balanceLabel:UILabel  = cell.viewWithTag(101) as! UILabel

        monthLable.text = "Month \(indexPath.row+1)"
        
        if calculateBalanceForMonth(index: indexPath.row) < 0 {
            balanceLabel.textColor = UIColor.init(colorLiteralRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        else{
            balanceLabel.textColor = UIColor.init(colorLiteralRed: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        }
        
        balanceLabel.text       = "$\(calculateBalanceForMonth(index: indexPath.row))"
        
        return cell
    }
    
    func calculateBalanceForMonth(index:Int) -> Double {
        let firstMonthBalance = (bankAccountBalance+totalAdHocIncome+totalRecurringIncome)-(totalAdHocExpeses-totalRecurringExpeses)
        let savingOfMonth     = (totalRecurringIncome - totalRecurringExpeses ) * Double(index)
        
        return firstMonthBalance + savingOfMonth
    }
    
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
//        print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Chart Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        var chartModels:[PieSliceModel] = []
        chartLegendText.removeAll()
        for expenseCategory in DataStoreManager.sharedInstance.getExpenseCategory() {
            var categoryExpenseTotal = 0.0
            for expense in expenseCategory.categoryExpenses?.allObjects as! [Expense] {
                categoryExpenseTotal += Double(expense.amount!)
            }

            chartModels.append(PieSliceModel(value: categoryExpenseTotal, color: UIColor.color(withData: expenseCategory.categoryColor as! Data)))
            chartLegendText.append(expenseCategory.categoryName!)
        }
        return chartModels
    }
    
    // MARK: - Chart Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer   = PieCustomViewsLayer()
        let settings    = PieCustomViewsLayerSettings()
        settings.hideOnOverflow = false
        viewLayer.settings      = settings
        viewLayer.viewGenerator = createViewGenerator()
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings               = PiePlainTextLayerSettings()
        textLayerSettings.hideOnOverflow    = true
        textLayerSettings.label.font        = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits         = 1
        textLayerSettings.label.textGenerator   = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer       = PiePlainTextLayer()
        textLayer.settings  = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container           = UIView()
            container.frame.size    = CGSize(width: 100, height: 40)
            container.center        = center
            let specialTextLabel = UILabel()
            specialTextLabel.textAlignment = .center
            specialTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
            specialTextLabel.text = self.chartLegendText[slice.data.id]
            specialTextLabel.sizeToFit()
            specialTextLabel.frame = CGRect(x: 0, y: 35, width: 100, height: 20)
            container.addSubview(specialTextLabel)
            container.frame.size = CGSize(width: 100, height: 60)
            return container
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
