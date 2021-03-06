//
//  CafeManagerUITests.swift
//  CafeManagerUITests
//
//  Created by Hishara Dilshan on 2021-04-27.
//

import XCTest

private extension XCUIApplication {
    var txtEmail: XCUIElement { self.textFields["txtEmail"] }
    var txtPassword: XCUIElement { self.secureTextFields["txtPassword"] }
    var btnSignIn: XCUIElement { self.buttons["btnSignIn"] }
    var tblFood: XCUIElement { self.tables["tableViewFoodItems"] }
    
}

class TestLogin: XCTestCase {
    private var result: XCTestExpectation!
    var userFound = false
    
    func testLogin() {
        let app = XCUIApplication()
        app.launch()
                
        app.txtEmail.tap()
        app.txtEmail.typeText("hisharadilshan3@gmail.com")
        app.txtPassword.tap()
        app.txtPassword.typeText("idmcc3")
        
        app.btnSignIn.tap()
        
        expectation(for: NSPredicate(format : "exists == 1"), evaluatedWith: app.tblFood, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

class CafeManagerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
