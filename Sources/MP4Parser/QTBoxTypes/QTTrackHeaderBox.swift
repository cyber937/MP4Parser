//
//  QTTrackHeaderBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTTrackHeaderBox: QTFullBox {
    
    // Movie Header Box properties
    public private(set) var creationTime: Date?
    public private(set) var modificationTime: Date?
    public private(set) var trackID: UInt32?
    public private(set) var duration: UInt64?
    public private(set) var layer: Int16 = 0
    public private(set) var volume: Float?
    public private(set) var matrix = [Float]()
    public private(set) var width: Float?
    public private(set) var height: Float?
    
    public init(fullBox: QTFullBox)  {
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        var offSet = location.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
        if version == 1 {
            creationTime = QTUtilUTCConvert(data: data[offSet..<offSet+8]) // 4...12 (8x8=64)
            
            offSet += 8  // 12
            modificationTime = QTUtilUTCConvert(data: data[offSet..<offSet+8]) // 12...20 (8x8=64)
            
            offSet += 8  // 20
            trackID = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self) // 20...24 (8x4=32)
            
            offSet += 8 // 28
            duration = data[offSet..<offSet+8].QTUtilConvert(type: UInt64.self) // 24..32 (8x8=64)
            
            offSet += 8 // 32
            
        } else {
            
            creationTime = QTUtilUTCConvert(data: data[offSet..<offSet+4]) // 0...4 (8x4=32)
            
            offSet += 4 // 4
            modificationTime = QTUtilUTCConvert(data: data[offSet..<offSet+4]) // 8...12 (8x4=32)
            
            offSet += 4 // 12
            trackID = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self) // 12...16 (8x4=32)
            
            offSet += 8 // 20
            duration = UInt64(data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)) // 16...20 (8x4=32)
            
            offSet += 4 // 20
            
        }
        
        offSet += 12
        
        volume = data[offSet..<offSet+2].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)
        
        matrix = data[offSet+4..<offSet+40].QTMatrixConvert()
        
        width = data[offSet+40..<offSet+44].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
        height = data[offSet+44..<offSet+48].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
    }
    
    override var extDescription: String? {
        get {
            
            guard let creationTime, let modificationTime, let trackID, let duration, let volume, let width, let height else {
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
            \(indent)| Track ID - \(trackID)
            \(indent)| Duration - \(duration)
            \(indent)| Volume - \(volume)
            \(indent)| Width - \(width)
            \(indent)| Height - \(height)
            """
            
            return output
        }
        
        set {}
    }
}
