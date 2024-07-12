//
//  QTDataInformationBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTDataInformationBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let dataInformationBox = try testData?.parseForBox(offset: 448)
        
        XCTAssertEqual(dataInformationBox?.type, .dinf)
        
        XCTAssertEqual(dataInformationBox?.range, 448..<484)
    }

}
