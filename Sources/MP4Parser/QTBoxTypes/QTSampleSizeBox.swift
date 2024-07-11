//
//  QTSampleSizeBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTSampleSizeBox: QTFullBox {
    
    public private(set) var sampleSize: UInt32?
    public private(set) var sampleCount: UInt32?
    public private(set) var entrySize = [UInt32]()
    
    init(fullBox: QTFullBox) {
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        initialSetting()
    }
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        initialSetting()
    }
    
    func initialSetting() {
        
        var offSet = location.lowerBound+12
        
        sampleSize = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        sampleCount = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
        
        if sampleSize == 0 {
            for _ in 0..<sampleCount! {
                let tempEntrySize = data[offSet+8..<offSet+12].QTUtilConvert(type: UInt32.self)
                entrySize.append(tempEntrySize)
                offSet += 4
            }
        }
    }
    
    override var extDescription: String? {
        get {
            
            guard let sampleSize, let sampleCount else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Sample Size - \(sampleSize)
            \(indent)| Sample Count - \(sampleCount)
            \(indent)| Entry Size - \(entrySize)
            """
            
            return output
        }
        
        set {}
    }
}
