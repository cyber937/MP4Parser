//
//  QTCompositionOffsetBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTCompositionOffsetBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    public private(set) var sampleCount = [UInt32]()
    public private(set) var sampleOffset = [UInt32]()
    
    public init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        let offSet = location.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
        for i in 0..<entryCount! {
            
            let indexOffset = i * 8
            
            let tempSampleCount: UInt32 = data[offSet+4+indexOffset..<offSet+8+indexOffset].QTUtilConvert(type: UInt32.self)
            sampleCount.append(tempSampleCount)
            
            let tempSampleOffset: UInt32 = data[offSet+8+indexOffset..<offSet+12+indexOffset].QTUtilConvert(type: UInt32.self)
            
            sampleOffset.append(tempSampleOffset)
        }
    }
    
    override var extDescription: String? {
        get {
            
            guard let entryCount else { return nil }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Entry Count - \(entryCount)
            \(indent)| Sample Count - \(sampleCount)
            \(indent)| Sample Offset - \(sampleOffset)
            """
            
            return output
        }
        
        set {}
    }
}
