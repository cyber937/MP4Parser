//
//  QTMovieHeaderBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

class QTMovieHeaderBox: QTFullBox {
    
    // Movie Header Box properties
    var creationTime: Date?
    var modificationTime: Date?
    var timeScale: UInt32?
    var duration: UInt32?
    var rate: Float?
    var volume: Float?
    var reserved: Data?
    var matrix = [Float]()
    var predefines: Data?
    var nextTrackID: UInt32?
    
    init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        
        initialSetting()
    }
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
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
        
        rate = data[offSet..<offSet+4].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
        volume = data[offSet+4..<offSet+6].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)
        
        reserved = self.data[offSet+6..<offSet+16]
        
        matrix = data[offSet+16..<offSet+52].QTMatrixConvert()
        
        predefines = self.data[offSet+52..<offSet+76]
        
        nextTrackID = data[offSet+76..<offSet+80].QTUtilConvert(type: UInt32.self)
    }
    
    override var extDescription: String? {
        get {
            
            guard let creationTime, let modificationTime, let timeScale, let duration, let rate, let volume, let nextTrackID else { return nil }
            
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
            \(indent)| Rate - \(rate)
            \(indent)| Volume - \(volume)
            \(indent)| Next Track ID - \(nextTrackID)
            """
            
            return output
        }
        
        set {}
    }
}