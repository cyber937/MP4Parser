//
//  QTMovieHeaderBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTMovieHeaderBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
        
        let fullBox = try testData?.parseForFullBox(offset: 40)
        
        let movieHeaderBox = QTMovieHeaderBox(fullBox: fullBox!)

        XCTAssertEqual(movieHeaderBox.type, .mvhd)

        XCTAssertEqual(movieHeaderBox.location, 40..<148)
        
        XCTAssertEqual(movieHeaderBox.creationTime?.description, "2015-08-07 16:13:02 +0000")
        
        XCTAssertEqual(movieHeaderBox.modificationTime?.description, "2015-08-07 16:13:02 +0000")
        
        XCTAssertEqual(movieHeaderBox.timeScale, 600)
        
        XCTAssertEqual(movieHeaderBox.duration, 18316)
        
        XCTAssertEqual(movieHeaderBox.rate, 1.0)
        
        XCTAssertEqual(movieHeaderBox.volume, 1.0)
        
        XCTAssertEqual(movieHeaderBox.nextTrackID, 3)
        
        let testDescription =    "Type: mvhd - Movie Header Box\n| Size - 108\n| Range - 40..<148\n| Level - 0\n|\n| Creation Time - 2015-08-07 16:13:02 +0000\n| Modification Time  - 2015-08-07 16:13:02 +0000\n| Time Scale - 600\n| Duration - 18316\n| Rate - 1.0\n| Volume - 1.0\n| Next Track ID - 3\n\n"

        XCTAssertEqual(movieHeaderBox.description, testDescription)
    }

}
