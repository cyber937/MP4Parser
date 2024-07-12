//
//  QTDataReferenceBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTDataReferenceBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 456)
        
        let dataReferenceBox = QTDataReferenceBox(fullBox: fullBox!)
        
        XCTAssertEqual(dataReferenceBox.type, .dref)
        
        XCTAssertEqual(dataReferenceBox.range, 456..<484)
        
        XCTAssertEqual(dataReferenceBox.entryCount, 1)
    }

}
