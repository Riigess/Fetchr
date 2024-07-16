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
    func testLaunchAndRunPallasRequest() async throws {
        let app = try launchApp()
        try await testRowTapAndHeaderAddButton()
//        let textFields = app.descendants(matching: .textField).allElementsBoundByIndex
//        for field in textFields {
//            if let val = field.value as? String {
//                while val.contains("https://") {
//                    field.tap()
//                    field.tap()
//                    selectAll(app: app)
//                    tapDeleteKey(app: app)
//                    field.typeText("https://gdmf.apple.com/v2/assets")
//                    if field.value != nil && (field.value as! String).count == 0 {
//                        break
//                    }
//                }
//            }
//        }
        let scrollViews = app.scrollViews
        let urlField = scrollViews.textFields["URL"]
        urlField.tap()
        urlField.tap()
        while !app.collectionViews.staticTexts["Select All"].exists {
            urlField.tap()
            sleep(1)
        }
        tapSelectAll(app: app)
        tapDeleteKey(app: app)
        urlField.typeText("https://gdmf.apple.com/v2/assets")
        
        //Get Header Elements
        let elements = app.descendants(matching: .textField).allElementsBoundByIndex
        for element in elements {
            if let val = element.value as? String {
                if val.contains("Key") {
                    element.tap()
                    element.typeText("Content-Type")
                } else if val.contains("Value") {
                    element.tap()
                    element.typeText("application/json")
                }
            }
        }
        let submitButton = app.buttons["done"]
        submitButton.tap()
        //Select "POST" to make a POST request
        let pickerPost = app.buttons["POST"]
        pickerPost.tap()
//        let scrollViews = app.scrollViews
        //Add the body data
        let textEditor = scrollViews.otherElements.containing(.textField, identifier: "URL").children(matching: .textView).element
        textEditor.tap()
        //Format body data to be added
        let macos_generic_audience = "02d8e57e-dd1c-4090-aa50-b4ed2aef0062"
        let clientVersion = 2
        let assetType = "UAF.FM.Overrides"
        let certIssuanceDay = "2023-12-10"
        let deviceName = "Mac"
        let trainName = "GlowSeed"
        let bodyData = "{\"AssetAudience\":\"\(macos_generic_audience)\", \"ClientVersion\":\(clientVersion), \"AssetType\":\"\(assetType)\", \"CertIssuanceDay\":\"\(certIssuanceDay)\", \"DeviceName\":\"\(deviceName)\", \"TrainName\":\"\(trainName)\"}"
        //Type that data
        app.typeText(bodyData)
        //Tap the "Make Request" button at the bottom of the window
        let makeRequestButton = app.buttons["Make Request"]
        makeRequestButton.tap()
        //Popover should be presented
        XCTAssertTrue(false)
    }

    //TODO: Figure out how to handle a launch performance benchmark, goal should be under 2 seconds I guess
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func tapSelectAll(app:XCUIApplication) {
        app.collectionViews.staticTexts["Select All"].tap()
    }
    
    func tapDeleteKey(app:XCUIApplication) {
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
    }
}


//Auto-generated code by Xcode

//XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["done"]/*[[".keyboards",".otherElements[\"UIKeyboardLayoutStar Preview\"]",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.tap()


// -----------------

//let app = XCUIApplication()
//let scrollViewsQuery = app.scrollViews
//scrollViewsQuery.otherElements.buttons["Row02, https://api.riotgames.com/v3/nah/nah/blah/blah, PUT"].staticTexts["https://api.riotgames.com/v3/nah/nah/blah/blah"].tap()
//scrollViewsQuery.otherElements.containing(.textField, identifier:"URL").children(matching: .textView).element.tap()
//app/*@START_MENU_TOKEN@*/.keys["F"]/*[[".keyboards",".otherElements[\"UIKeyboardLayoutStar Preview\"].keys[\"F\"]",".keys[\"F\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

// -----------------

//let elementsQuery = XCUIApplication().scrollViews.otherElements
//elementsQuery.buttons["Row02, https://api.riotgames.com/v3/nah/nah/blah/blah, PUT"].staticTexts["https://api.riotgames.com/v3/nah/nah/blah/blah"].tap()
//elementsQuery/*@START_MENU_TOKEN@*/.buttons["POST"]/*[[".segmentedControls.buttons[\"POST\"]",".buttons[\"POST\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

// -----------------

//let app = XCUIApplication()
//let elementsQuery = app.scrollViews.otherElements
//elementsQuery.buttons["Row02, https://api.riotgames.com/v3/nah/nah/blah/blah, PUT"].staticTexts["https://api.riotgames.com/v3/nah/nah/blah/blah"].tap()
//
//let urlTextField = elementsQuery.textFields["URL"]
//urlTextField.tap()
//urlTextField.tap()
//app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Select All"]/*[[".menuItems[\"Select All\"].staticTexts[\"Select All\"]",".staticTexts[\"Select All\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards",".otherElements[\"UIKeyboardLayoutStar Preview\"].keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//deleteKey.tap()
//deleteKey.tap()
//urlTextField.tap()
