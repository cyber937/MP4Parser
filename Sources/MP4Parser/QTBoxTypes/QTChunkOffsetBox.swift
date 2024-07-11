//
//  QTChunkOffsetBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTChunkOffsetBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    public private(set) var chunkOffset = [UInt32]()
    
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
                
                let tempChunkOffset = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
                chunkOffset.append(tempChunkOffset)
                
                offSet += 4
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
            \(indent)| Chunk Offset - \(chunkOffset)
            """
            
            return output
        }
        
        set {}
    }
}
