//
//  DataStoreManager.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 12/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataStoreManager {
    private init (){
    }
    
    // shared instance for DataStoreManager
    static let sharedInstance : DataStoreManager = DataStoreManager()
    
    // private method to get ManagedObjectContext instance
    fileprivate func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    // Update bank account balance
    func updateBankAccountBalance(_ newBalance:Decimal) -> Bool {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<BankAccount> = BankAccount.fetchRequest()
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            if searchResults.count == 0 {
                let entity =  NSEntityDescription.entity(forEntityName: "BankAccount", in: context)
                let record = NSManagedObject(entity: entity!, insertInto: context)
                record.setValue(newBalance, forKey: "balance")
            }
            else{
                for record in searchResults as [NSManagedObject] {
                    record.setValue(newBalance, forKey: "balance")
                }
            }
        } catch {
            print("Error with request: \(error)")
        }

        //save the object
        do {
            try context.save()
            print("updatedBankAccountBalance!")
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        return false
    }
    
    // Get bank account balance
    func getBankAccountBalance() -> Double {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<BankAccount> = BankAccount.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for record in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(record.value(forKey: "balance")!)")
                return record.value(forKey: "balance") as! Double
            }
        } catch {
            print("Error with request: \(error)")
        }
        return 0.0
    }
    
    // Add a new Income
    func addIncome(incomeDescription description:String, isRecurring:Bool, amount:Decimal) -> Bool {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Income", in: context)
        
        let income:Income = NSManagedObject(entity: entity!, insertInto: context) as! Income
        
        //set the entity values
        income.incomeDescription    = description
        income.amount               = amount as NSDecimalNumber?
        income.isRecurring          = isRecurring
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        return true
    }
    
    // Get all incomes
    func getIncomes() -> [Income] {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    // Give total of incomes
    func getAdHocIncomesTotal() -> Double {
        let searchResults = getIncomes()
        var totalAdHocIncome = 0.0
        for income in searchResults {
            if !income.isRecurring {
                totalAdHocIncome += (income.amount?.doubleValue)!
            }
        }
        return totalAdHocIncome
    }
    
    // Give total of recurring incomes in a month
    func getRecurringIncomesTotal() -> Double {
        let searchResults = getIncomes()
        var totalRecurringIncome = 0.0
        for income in searchResults {
            if income.isRecurring {
                totalRecurringIncome += (income.amount?.doubleValue)!
            }
        }
        return totalRecurringIncome
    }
    
    // Delete Income item
    func deleteIncome(income:Income) -> Bool {
        let context = getContext()
        context.delete(income)
        //save the object
        do {
            try context.save()
            print("deleted!")
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        return false
    }
    
    // Add a new expense
    func addExpense(expenseDescription description:String, isRecurring:Bool, amount:Decimal, category:ExpenseCatagory) -> Bool {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Expense", in: context)
        
        let expense:Expense = NSManagedObject(entity: entity!, insertInto: context) as! Expense
        
        expense.expenseDescription   = description
        expense.isRecurring          = isRecurring
        expense.amount               = amount as NSDecimalNumber?
        expense.expenseCatagory      = category
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    // Get all expenses
    func getExpenses() -> [Expense] {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    // Delete Expense item
    func deleteExpense(expense:Expense) -> Bool {
        let context = getContext()
        context.delete(expense)
        //save the object
        do {
            try context.save()
            print("deleted!")
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        return false
    }
    
    // Give total of expenses
    func getAdHocExpensesTotal() -> Double {
        let searchResults = self.getExpenses()
        var totalAdHocExpenses = 0.0
        for expense in searchResults {
            if !expense.isRecurring {
                totalAdHocExpenses += (expense.amount?.doubleValue)!
            }
        }
        return totalAdHocExpenses
    }
    
    // Give total of recurring expenses in a month
    func getRecurringExpensesTotal() -> Double {
        let searchResults = self.getExpenses()
        var totalRecurringIncome = 0.0
        for expense in searchResults {
            if expense.isRecurring {
                totalRecurringIncome += (expense.amount?.doubleValue)!
            }
        }
        return totalRecurringIncome
    }
    
    // Add a new expense category
    func addExpenseCategory(expenseCategoryName name:String, color:UIColor) -> Bool {
        let context = getContext()
        
        let entityCategory =  NSEntityDescription.entity(forEntityName: "ExpenseCatagory", in: context)
        let expenseCategory:ExpenseCatagory = NSManagedObject(entity: entityCategory!, insertInto: context) as! ExpenseCatagory
        expenseCategory.categoryName = name
        expenseCategory.categoryColor = color.encode() as NSObject?
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        } catch {
            
        }
        return true
    }

    // get ExpenseCatagory for categoryName
    func getExpenseCategoryFor(categoryName:String) -> ExpenseCatagory? {
        let fetchRequest: NSFetchRequest<ExpenseCatagory> = ExpenseCatagory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        do {
            return try getContext().fetch(fetchRequest).first
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    // Get all ExpenseCatagory
    func getExpenseCategory() -> [ExpenseCatagory] {
        let fetchRequest: NSFetchRequest<ExpenseCatagory> = ExpenseCatagory.fetchRequest()
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }

}
