//
//  QTSyncSampleBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTSyncSampleBox: QTFullBox {
    
    private(set) var entryCount: UInt32?
    private(set) var sampleNumber = [UInt32]()
    
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
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
            for _ in 0..<entryCount! {
                
                let tempSampleNumber = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
                sampleNumber.append(tempSampleNumber)
                
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
            \(indent)| Sample Number - \(sampleNumber)
            """
            
            return output
        }
        
        set {}
    }
}

