//
//  QTBoxTest.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class MP4ParserTests: XCTestCase {
    
    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }
    
    func testCreateQTBox() throws {
        
        let testBox = try testData?.parseForBox()
        
        XCTAssertEqual(testBox!.data, testData!)
        
        XCTAssertEqual(testBox!.location, 0..<32)
        
        XCTAssertEqual(testBox!.size, 32)
        
        XCTAssertEqual(testBox!.type, .ftyp)
        
        let testDescription = "Type: ftyp - File Type Box\n| Size - 32\n| Range - 0..<32\n| Level - 0\n\n"
        
        XCTAssertEqual(testBox!.description, testDescription)
        
        
    }
    
    func testFailQTBoxParse() throws {
        
        XCTAssertThrowsError(try testData?.parseForBox(offset: 1)) { error in
            XCTAssertEqual(error as! QTBoxError, QTBoxError.unableToGetBoxType)
        }
    }
    
    func testCreateQTFullBox() throws {
        
//        let testBaseBox = try testData?.parseForBox(offset: 40) as! BaseBox
//        
//        var testBaseFullBox = try testData?.parseForFullBox(baseBox: testBaseBox) as! BaseFullBox
//        
//        XCTAssertEqual(testBaseFullBox.data, testData!)
//        
//        XCTAssertEqual(testBaseFullBox.location, 40..<148)
//        
//        XCTAssertEqual(testBaseFullBox.size, 108)
//        
//        XCTAssertEqual(testBaseBox.type, .mvhd)
//        
//        testBaseFullBox.level = 1
//        
//        let testDescription = "   Type: mvhd - Name\n   | Size - 108\n   | Range - 40..<148\n   | Level - 1\n\n"
//        
//        XCTAssertEqual(testBaseFullBox.description, testDescription)
//        
//        XCTAssertNil(testBaseFullBox.userType)
    }
    
    func testParseForMP4Data() throws {
        let testRootBox = try testData?.parseForMP4Data()

        print(testRootBox!.description)
    }

}
