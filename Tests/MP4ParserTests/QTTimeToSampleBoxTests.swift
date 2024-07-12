//
//  QTTimeToSampleBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTTimeToSampleBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 658)
        
        let timeToSampleBox = QTTimeToSampleBox(fullBox: fullBox!)

        XCTAssertEqual(timeToSampleBox.type, .stts)

        XCTAssertEqual(timeToSampleBox.range, 658..<682)
        
        XCTAssertEqual(timeToSampleBox.entryCount, 1)

        XCTAssertEqual(timeToSampleBox.sampleCount, [901])
        
        XCTAssertEqual(timeToSampleBox.sampleDelta, [1])
    }

}
