//
//  QTEditListBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTEditListBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    public private(set) var segmentDuration = [UInt32]()
    public private(set) var mediaTime = [Int32]()
    public private(set) var mediaRateInteger = [Int16]()
    public private(set) var mediaRateFraction = [Int16]()
    
    public init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.range, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        var offSet = range.lowerBound+12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
        for _ in 0..<entryCount! {
            let tempSegmentDuration = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
            segmentDuration.append(tempSegmentDuration)
            
            let tempMediaTime = data[offSet+8..<offSet+12].QTUtilConvert(type: Int32.self)
            mediaTime.append(tempMediaTime)
            
            let tempMediaRateInteger = data[offSet+12..<offSet+14].QTUtilConvert(type: Int16.self)
            mediaRateInteger.append(tempMediaRateInteger)
            
            let tempMediaRateFraction = data[offSet+14..<offSet+16].QTUtilConvert(type: Int16.self)
            mediaRateFraction.append(tempMediaRateFraction)
            
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
            \(indent)| Media Time - \(mediaTime)
            \(indent)| Media Rate Interger - \(mediaRateInteger)
            \(indent)| Media Rate Fraction - \(mediaRateFraction)
            """
            
            return output
        }
        
        set {}
    }
}

