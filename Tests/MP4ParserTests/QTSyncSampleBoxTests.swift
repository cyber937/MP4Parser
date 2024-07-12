//
//  QTSyncSampleBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTSyncSampleBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 682)
        
        let synSampleBox = QTSyncSampleBox(fullBox: fullBox!)

        XCTAssertEqual(synSampleBox.type, .stss)

        XCTAssertEqual(synSampleBox.range, 682..<742)

        XCTAssertEqual(synSampleBox.entryCount, 11)

        XCTAssertEqual(synSampleBox.sampleNumber.count, 11)
    }
}


