//
//  defactorTests.swift
//  defactorTests
//
//  Created by Rockford Wei on 2022-03-04.
//

import XCTest
@testable import defactor

class defactorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWebServiceShareSuccess() throws {
        let expection = expectation(description: "web service share success")
        WebService.shared.query(value: 100) { listModel in
            XCTAssertEqual(listModel.key, 100)
            XCTAssertEqual(listModel.items, [
                    DetailModel(id: 1, text: "one"),
                    DetailModel(id: 2, text: "two"),
                    DetailModel(id: 4, text: "four"),
                    DetailModel(id: 5, text: "five"),
                    DetailModel(id: 10, text: "ten")
            ])
            expection.fulfill()
        }
        wait(for: [expection], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
