//
//  QTTimeToSampleBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

class QTTimeToSampleBox: QTFullBox {
    
    var entryCount: UInt32?
    var sampleCount = [UInt32]()
    var sampleDelta = [UInt32]()
    
    init(fullBox: QTFullBox)  {
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        
        initialSetting()
    }
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        let offSet = location.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
        for i in 0..<entryCount! {
            
            let sampleOffset = i * 8
            
            let tempSampleCount: UInt32 = data[offSet+4+sampleOffset..<offSet+8+sampleOffset].QTUtilConvert(type: UInt32.self)
            sampleCount.append(tempSampleCount)
            
            let tempSampleDelta: UInt32 = data[offSet+8+sampleOffset..<offSet+12+sampleOffset].QTUtilConvert(type: UInt32.self)
            
            sampleDelta.append(tempSampleDelta)
        }
    }
    
    override var extDescription: String? {
        get {
            
            guard let entryCount else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Entry Count - \(entryCount)
            \(indent)| Sample Count - \(sampleCount)
            \(indent)| Sample Delta - \(sampleDelta)
            """
            
            return output
        }
        
        set {}
    }
}
