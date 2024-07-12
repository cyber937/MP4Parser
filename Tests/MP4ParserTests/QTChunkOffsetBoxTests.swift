//
//  QTChunkOffsetBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTChunkOffsetBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 5319)
        
        let chunkOffsetBox = QTChunkOffsetBox(fullBox: fullBox!)

        XCTAssertEqual(chunkOffsetBox.type, .stco)

        XCTAssertEqual(chunkOffsetBox.range, 5319..<5455)

        XCTAssertEqual(chunkOffsetBox.entryCount, 30)

        XCTAssertEqual(chunkOffsetBox.chunkOffset.count, 30)
    }
}

