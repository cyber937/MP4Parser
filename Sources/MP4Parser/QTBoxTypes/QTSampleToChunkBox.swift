//
//  QTSampleToChunkBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTSampleToChunkBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    public private(set) var firstChunk = [UInt32]()
    public private(set) var samplePerChunk = [UInt32]()
    public private(set) var sampleDescriptionIndex = [UInt32]()
    
    public init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        var offSet = location.lowerBound+12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
            for _ in 0..<entryCount! {
                let tempFirstChunk = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
                firstChunk.append(tempFirstChunk)
                
                let tempSamplePerChunk = data[offSet+8..<offSet+12].QTUtilConvert(type: UInt32.self)
                samplePerChunk.append(tempSamplePerChunk)
                
                let tempSampleDescriptionIndex = data[offSet+12..<offSet+16].QTUtilConvert(type: UInt32.self)
                sampleDescriptionIndex.append(tempSampleDescriptionIndex)
                
                offSet += 12
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
            \(indent)| First Chunk - \(firstChunk)
            \(indent)| Sample Per Chunk - \(samplePerChunk)
            \(indent)| Sample Description Index - \(sampleDescriptionIndex)
            """
            
            return output
        }
        
        set {}
    }
}
