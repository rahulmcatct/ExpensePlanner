//
//  ExpenseTrackerTests.swift
//  ExpenseTrackerTests
//
//  Created by Rahul Tamrakar on 11/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import XCTest
@testable import ExpenseTracker

class ExpenseTrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testUpdaeAccountBalanceUpdate() {
        let result = DataStoreManager.sharedInstance.updateBankAccountBalance(100.0)
        XCTAssert(result)
    }

    func testGetExpenses() {
        
        let result = DataStoreManager.sharedInstance.getExpenses()
        XCTAssertNotNil(result)
    }
    
    func testGetIncomes() {
        
        let result = DataStoreManager.sharedInstance.getIncomes()
        XCTAssertNotNil(result)
    }
    
    func testGetIncomePerformance() {
        // This is an example of a performance test case.
        self.measure {
            let result = DataStoreManager.sharedInstance.getIncomes()
            XCTAssertNotNil(result)
        }
    }
    
}
