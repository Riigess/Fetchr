//
//  REST_RequesterUITests.swift
//  REST RequesterUITests
//
//  Created by Austin Bennett on 6/21/24.
//

import XCTest
import SwiftUI

final class FetchrUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func launchApp()throws -> XCUIApplication {
        let app = XCUIApplication()
        if app.state != .runningForeground {
            if app.state != .notRunning {
                app.terminate()
            }
            app.launch()
        }
        return app
    }
    
    func getTabBar(app:XCUIApplication) -> XCUIElement {
        let tabBar = app.descendants(matching: .tabBar).firstMatch
        return tabBar
    }
    
    func getScrollView(app:XCUIApplication) -> XCUIElement {
        let scrollView = app.descendants(matching: .scrollView)
        return scrollView.firstMatch
    }
    
    func getMenuRowsFromScrollView(scrollView:XCUIElement) -> [XCUIElement] {
        let otherElements = scrollView.children(matching: .other)
        return otherElements.allElementsBoundByIndex
    }
    
    func getAddButton(app:XCUIApplication) -> XCUIElement {
        let buttons = app.descendants(matching: .button)
        let addButtons = buttons.element(matching: NSPredicate(format: "label CONTAINS[c] 'Add'"))
        return addButtons.firstMatch
    }
    
    private var lastFetchedView:XCUIElement?
    
    func doesTextFieldExist(app:XCUIApplication, fieldContent:String, isVerbose:Bool = false) -> Bool {
        let textFields = app.descendants(matching: .textField).allElementsBoundByIndex
        if isVerbose {
            print("Text field count: \(textFields.count)")
        }
        for field in textFields {
            if let fieldVal = field.value as? String {
                if isVerbose {
                    print("\tField Value == \(fieldVal)")
                }
                if fieldVal.contains(fieldContent) {
                    if isVerbose {
                        print("TextField width is \(field.frame.width) with screen bounds width of \(UIScreen.main.bounds.width)")
                    }
                    lastFetchedView = field
                    return true
                }
            }
        }
        return false
    }
    
    func testTapHomeTabBarItem(app:XCUIApplication) throws {
        let tabBar = getTabBar(app: app)
        let tabBarHomeView = tabBar.descendants(matching: .button).firstMatch
        tabBarHomeView.tap()
    }
    
    @MainActor
    func testRowTapAndHeaderAddButton() async throws {
        let app = try launchApp()
        try testTapHomeTabBarItem(app: app)
        let rows = getMenuRowsFromScrollView(scrollView: getScrollView(app: app))
        rows[0].tap() //Tap first MenuRow item in View
        let addButton = getAddButton(app: app)
        addButton.tap()
        //Tap Add button in View
        XCTAssertTrue(doesTextFieldExist(app: app, fieldContent: "api.riotgames.com", isVerbose: true))
    }
    
    @MainActor
    func testCheckRowWidthInSetupConnView() async throws {
        let app = try launchApp()
        try testTapHomeTabBarItem(app: app)
        let rows = getMenuRowsFromScrollView(scrollView: getScrollView(app: app))
        rows[0].tap()
        var urlFieldWidth:CGFloat = 0
        if doesTextFieldExist(app: app, fieldContent: "api.riotgames.com", isVerbose: false) {
            if let fetchedView = lastFetchedView {
                urlFieldWidth = fetchedView.frame.width
            }
            XCTAssertFalse(urlFieldWidth == 0) //Validate field exists
        }
        let addButton = getAddButton(app: app)
        addButton.tap()
        XCTAssertTrue(doesTextFieldExist(app: app, fieldContent: "api.riotgames.com"))
        if let fetchedView = lastFetchedView {
            XCTAssertTrue(fetchedView.frame.width == urlFieldWidth)
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
