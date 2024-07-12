//
//  QTSampleToChunkBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTSampleToChunkBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 1655)
        
        let sampleToChunkBox = QTSampleToChunkBox(fullBox: fullBox!)

        XCTAssertEqual(sampleToChunkBox.type, .stsc)

        XCTAssertEqual(sampleToChunkBox.range, 1655..<1695)

        XCTAssertEqual(sampleToChunkBox.entryCount, 2)

        XCTAssertEqual(sampleToChunkBox.firstChunk, [1, 30])

        XCTAssertEqual(sampleToChunkBox.samplePerChunk, [31, 2])
        
        XCTAssertEqual(sampleToChunkBox.sampleDescriptionIndex, [1, 1])
    }
}

