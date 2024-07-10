//
//  QTFileTypeBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

class QTFileTypeBox: QTBox {
    var userType: [Int8]?
    
    // File Type Box properties
    var majorBrand: String?
    var minorVersion: UInt32?
    var compatibleBrands = [String]()
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        
        let offSet = location.lowerBound+8
        
        // Extract major brand as String
        guard let majorBrandTemp = String(data: data[offSet..<offSet+4], encoding: .utf8) else {
            preconditionFailure()
        }
        majorBrand = majorBrandTemp
        
        // Extract minot version as Int
        minorVersion = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
        
        // Extract compatible brands as [String]
        compatibleBrands = [String]()
        
        var i: UInt32 = offSet+8
        
        while i != location.upperBound {
            
            guard let compatibleBrand = String(data: data[i..<i+4], encoding: .utf8) else {
                preconditionFailure()
            }
            
            compatibleBrands.append(compatibleBrand)
            
            i += 4
        }
    }
    
    override var extDescription: String? {
        get {
            
            guard let majorBrand, let minorVersion else { return nil }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
                    \n\(indent)|
                    \(indent)| Major Brand - \(majorBrand)
                    \(indent)| Minor Version  - \(minorVersion)
                    \(indent)| Compatible Brands - \(compatibleBrands)
                    """
            
            return output
        }
        
        set {}
    }
    
}