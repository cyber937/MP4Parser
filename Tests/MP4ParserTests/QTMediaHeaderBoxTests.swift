//
//  QTMediaHeaderBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTMediaHeaderBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 334)
        
        let movieHeaderBox = QTMovieHeaderBox(fullBox: fullBox!)

        XCTAssertEqual(movieHeaderBox.type, .mdhd)

        XCTAssertEqual(movieHeaderBox.range, 334..<366)
        
        XCTAssertEqual(movieHeaderBox.creationTime?.description, "2015-08-07 16:13:02 +0000")
        
        XCTAssertEqual(movieHeaderBox.modificationTime?.description, "2015-08-07 16:13:02 +0000")
        
        XCTAssertEqual(movieHeaderBox.timeScale, 30)
        
        XCTAssertEqual(movieHeaderBox.duration, 901)
    }

}
