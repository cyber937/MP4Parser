//
//  QTAVCDecoderConfigutationRecordTests.swift
//  MP4ParserTests
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import XCTest
@testable import MP4Parser

final class QTAVCDecoderConfigutationRecordTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {

        let avcDecoderConfigurationRecord = QTAVCDecoderConfigurationRecord(data: testData!, location: 602..<642)

        XCTAssertEqual(avcDecoderConfigurationRecord.configurationVersion, 1)

        XCTAssertEqual(avcDecoderConfigurationRecord.avcProfileIndication, 66)

        XCTAssertEqual(avcDecoderConfigurationRecord.profileCompatibility, 192)
        
        XCTAssertEqual(avcDecoderConfigurationRecord.avcLevelIndication, 30)
        
        XCTAssertEqual(avcDecoderConfigurationRecord.lengthSizeMinusOne, 3)
        
        XCTAssertEqual(avcDecoderConfigurationRecord.numOfSequenceParameterSets, 1)
        
        XCTAssertEqual(avcDecoderConfigurationRecord.sequenceParameterSetLength, [25])
        
        XCTAssertEqual(avcDecoderConfigurationRecord.sequenceParameterSetNALUnitRange, [610..<635])

        XCTAssertEqual(avcDecoderConfigurationRecord.numOfPictureParameterSets, 1)
        
        XCTAssertEqual(avcDecoderConfigurationRecord.pictureParameterSetLength, [4])
        
        XCTAssertEqual(avcDecoderConfigurationRecord.pictureParameterSetNALUnitRange, [638..<642])
    }

}


