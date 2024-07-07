//
//  QTHandlerBoxTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTHandlerBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
     
        let fullBox = try testData?.parseForFullBox(offset: 366)
        
        let handlerbBox = QTHandlerBox(fullBox: fullBox!)

        XCTAssertEqual(handlerbBox.type, .hdlr)

        XCTAssertEqual(handlerbBox.location, 366..<420)
        
        XCTAssertEqual(handlerbBox.handlerType, .vide)
        
        XCTAssertEqual(handlerbBox.name, "L-SMASH Video Handler\0")

    }

}
