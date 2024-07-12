//
//  QTMediaHeaderBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTMediaHeaderBox: QTFullBox {
    
    // Movie Header Box properties
    public private(set) var creationTime: Date?
    public private(set) var modificationTime: Date?
    public private(set) var timeScale: UInt32?
    public private(set) var duration: UInt32?
    public private(set) var language: String?
    
    public init(fullBox: QTFullBox) {
        super.init(data: fullBox.data, location: fullBox.range, type: fullBox.type)
        initialization()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        initialization()
    }
    
    func initialization() {
        var offSet = range.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
        if version == 1 {
            creationTime = QTUtilUTCConvert(data: data[offSet..<offSet+8]) // 4...12 (8x8=64)
            
            offSet += 8  // 12
            modificationTime = QTUtilUTCConvert(data: data[offSet..<offSet+8]) // 12...20 (8x8=64)
            
            offSet += 8  // 20
            timeScale = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self) // 20...24 (8x4=32)
            
            offSet += 4 // 24
            duration = data[offSet..<offSet+8].QTUtilConvert(type: UInt32.self) // 24..32 (8x8=64)
            
            offSet += 8 // 32
            
        } else {
            
            creationTime = QTUtilUTCConvert(data: data[offSet..<offSet+4]) // 4...8 (8x4=32)
            
            offSet += 4 // 8
            modificationTime = QTUtilUTCConvert(data: data[offSet..<offSet+4]) // 8...12 (8x4=32)
            
            offSet += 4 // 12
            timeScale = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self) // 12...16 (8x4=32)
            
            offSet += 4 // 16
            duration = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self) // 16...20 (8x4=32)
            
            offSet += 4 // 20
            
        }
        
    }
    
    override var extDescription: String? {
        get {
            
            guard let creationTime, let modificationTime, let timeScale, let duration else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Creation Time - \(creationTime)
            \(indent)| Modification Time  - \(modificationTime)
            \(indent)| Time Scale - \(timeScale)
            \(indent)| Duration - \(duration)
            """
            
            return output
        }
        
        set {}
    }
}
