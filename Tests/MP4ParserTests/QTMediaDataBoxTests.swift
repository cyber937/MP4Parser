//
//  QTMediaDataBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTMediaDataBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let mediaDataBox = try testData?.parseForBox(offset: 11864)
        
        XCTAssertEqual(mediaDataBox?.type, .mdat)
        
        XCTAssertEqual(mediaDataBox?.range, 11864..<1570024)
        
        let testDescription =    "Type: mdat - Media Data Box\n| Size - 1558160\n| Range - 11864..<1570024\n| Level - 0\n\n"
        
        XCTAssertEqual(mediaDataBox?.description, testDescription)
    }

}
