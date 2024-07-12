//
//  QTSampleTableBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTSampleTableBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let sampleTableBox = try testData?.parseForBox(offset: 484)
        
        XCTAssertEqual(sampleTableBox?.type, .stbl)
        
        XCTAssertEqual(sampleTableBox?.range, 484..<5507)
    }

}
