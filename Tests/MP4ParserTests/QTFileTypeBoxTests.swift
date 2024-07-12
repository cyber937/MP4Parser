import XCTest
@testable import MP4Parser

final class FileTypeBoxTests: XCTestCase {

    var testData: Data?
    
    override func setUpWithError() throws {
        let path = Bundle.module.path(forResource: "file_example_MP4_480_1_5MG", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        testData = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    func testExample() throws {
        
        let testBox = try testData!.parseForBox()
        
        let fileTypeBox = QTFileTypeBox(data: testData!, location: testBox.range, type: testBox.type)
        
        XCTAssertEqual(fileTypeBox.majorBrand, "mp42")
        
        XCTAssertEqual(fileTypeBox.minorVersion, 0)
        
        XCTAssertEqual(fileTypeBox.compatibleBrands, ["mp42", "mp41", "isom", "avc1"])
        
        let testDescription = "Type: ftyp - File Type Box\n| Size - 32\n| Range - 0..<32\n| Level - 0\n|\n| Major Brand - mp42\n| Minor Version  - 0\n| Compatible Brands - [\"mp42\", \"mp41\", \"isom\", \"avc1\"]\n\n"
        
        XCTAssertEqual(fileTypeBox.description, testDescription)
    }

}
