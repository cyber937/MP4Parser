//
//  QTMovieBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTMovieBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let movieDataBox = try testData?.parseForBox(offset: 32)
        
        XCTAssertEqual(movieDataBox?.type, .moov)
        
        XCTAssertEqual(movieDataBox?.range, 32..<11856)

        let testDescription =    "Type: moov - Movie Box\n| Size - 11824\n| Range - 32..<11856\n| Level - 0\n\n"
        
        XCTAssertEqual(movieDataBox?.description, testDescription)
    }

}
