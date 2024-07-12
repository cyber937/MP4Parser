//
//  QTFullBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/10/24.
//

import Foundation

public class QTFullBox: QTBox {
    
    var version: UInt8?
    var flags = [Int8]()
    
    override init(data: Data, range: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, range: range, type: type)
        
        let offset = range.lowerBound + 8
        version = data[offset..<offset+1].QTUtilConvert(type: UInt8.self)
        
        flags = [data[offset+1..<offset+2].QTUtilConvert(type: Int8.self),
                 data[offset+2..<offset+3].QTUtilConvert(type: Int8.self),
                 data[offset+3..<offset+4].QTUtilConvert(type: Int8.self)]
    }
}
