//
//  QTTrackHeaderBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTTrackHeaderBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 198)
        
        let trackHeaderBox = QTTrackHeaderBox(fullBox: fullBox!)

        XCTAssertEqual(trackHeaderBox.type, .tkhd)

        XCTAssertEqual(trackHeaderBox.location, 198..<290)

        XCTAssertEqual(trackHeaderBox.creationTime?.description, "2015-08-07 16:13:02 +0000")
        
        XCTAssertEqual(trackHeaderBox.modificationTime?.description, "2015-08-07 16:13:02 +0000")

        XCTAssertEqual(trackHeaderBox.trackID, 1)

        XCTAssertEqual(trackHeaderBox.duration, 18020)

        XCTAssertEqual(trackHeaderBox.width, 480.0)

        XCTAssertEqual(trackHeaderBox.height, 270.0)
    }

}
