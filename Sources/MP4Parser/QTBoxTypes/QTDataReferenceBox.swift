//
//  QTDataReferenceBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTDataReferenceBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    public private(set) var dataEntry = [QTBox?]()
    
    public init(fullBox: QTFullBox) {
        super.init(data: fullBox.data, range: fullBox.range, type: fullBox.type)
        initialSetting()
    }
    
    public override init(data: Data, range: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, range: range, type: type)
        initialSetting()
    }
    
    func initialSetting() {
        let offSet = range.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
        if let entryCount {
            
            var dataEntotyRangeOffset = offSet + 4
            
            for i in 0..<entryCount {
                
                var size: UInt32 = 0
                var extSize: UInt64?
                var range: Range<UInt32>
                
                guard let typeString = String(data: data[dataEntotyRangeOffset+4..<dataEntotyRangeOffset+8], encoding: .utf8) else {
                    preconditionFailure()
                }
                
                let type = QTBoxType(rawValue: typeString)
                
                size = data[dataEntotyRangeOffset..<dataEntotyRangeOffset+4].QTUtilConvert(type: UInt32.self)
                
                if size == 1 {
                    extSize = data[dataEntotyRangeOffset+8..<dataEntotyRangeOffset+16].QTUtilConvert(type: UInt64.self)
                    
                    range = dataEntotyRangeOffset..<i+UInt32(extSize!)
                    dataEntotyRangeOffset += UInt32(extSize!)
                } else {
                    range = i..<i+UInt32(size)
                    dataEntotyRangeOffset += UInt32(size)
                }
                
                var qtBox: QTBox?
                
                guard let type else { continue }
                
                switch type {
                case .url:
                    qtBox = QTDataEntryUrlBox(data: data, range: range, type: type)
                    
                default:
                    qtBox = nil
                }
                
                if let qtBox {
                    addChild(qtBox: qtBox)
                }
            }
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
            """
            
            return output
        }
        
        set {}
    }
}
