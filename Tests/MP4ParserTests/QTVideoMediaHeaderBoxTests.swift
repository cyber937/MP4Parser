//
//  QTVideoMediaHeaderBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTVideoMediaHeaderBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 428)
        
        let videoMedaiHeaderBox = QTVideoMediaHeaderBox(fullBox: fullBox!)

        XCTAssertEqual(videoMedaiHeaderBox.type, .vmhd)

        XCTAssertEqual(videoMedaiHeaderBox.range, 428..<448)

        XCTAssertEqual(videoMedaiHeaderBox.graphicsmode, 0)
        
        XCTAssertEqual(videoMedaiHeaderBox.opcolor, [0,0,0])
//
//        XCTAssertEqual(trackHeaderBox.trackID, 1)
//
//        XCTAssertEqual(trackHeaderBox.duration, 18020)
//
//        XCTAssertEqual(trackHeaderBox.width, 480.0)

//        XCTAssertEqual(trackHeaderBox.height, 270.0)
    }

}

