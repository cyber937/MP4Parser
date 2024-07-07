////
////  QTFreeBoxTests.swift
////  
////
////  Created by Kiyoshi Nagahama on 5/28/24.
////
//
//import XCTest
//@testable import MP4Parser
//
//final class QTFreeBoxTests: XCTestCase {
//
//    var testData: Data?
//    
//    override func setUpWithError() throws {
//        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
//        let url = URL(fileURLWithPath: path!)
//        testData = try Data(contentsOf: url, options: .mappedIfSafe)
//    }
//
//    func testExample() throws {
//     
//        let testBaseBox = try testData?.parseForBox(offset: 11856) as! BaseBox
//        
//        var freeBox = QTMovieBox(baseBox: testBaseBox)
//        
//        freeBox.level = 1
//        
//        XCTAssertEqual(freeBox.type, .free)
//        
//        XCTAssertEqual(freeBox.location, 11856..<11864)
//
//        let testDescription =    "   Type: free - Name\n   | Size - 8\n   | Range - 11856..<11864\n   | Level - 1\n\n"
//        
//        XCTAssertEqual(freeBox.description, testDescription)
//    }
//
//}
