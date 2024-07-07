//
//  QTEditListBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTEditListBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 298)
        
        let editListBox = QTEditListBox(fullBox: fullBox!)

        XCTAssertEqual(editListBox.type, .elst)

        XCTAssertEqual(editListBox.location, 298..<326)

        XCTAssertEqual(editListBox.entryCount, 1)

        XCTAssertEqual(editListBox.mediaTime, [0])

        XCTAssertEqual(editListBox.mediaRateInteger, [1])

        XCTAssertEqual(editListBox.mediaRateFraction, [0])
//
//        XCTAssertEqual(trackHeaderBox.width, 480.0)
//
//        XCTAssertEqual(trackHeaderBox.height, 270.0)
    }

}

