//
//  QTSampleSizeBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTSampleSizeBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 1695)
        
        let sampleSizeBox = QTSampleSizeBox(fullBox: fullBox!)

        XCTAssertEqual(sampleSizeBox.type, .stsz)

        XCTAssertEqual(sampleSizeBox.range, 1695..<5319)

        XCTAssertEqual(sampleSizeBox.sampleSize, 0)

        XCTAssertEqual(sampleSizeBox.sampleCount, 901)

        XCTAssertEqual(sampleSizeBox.entrySize.count, 901)
    }
}
