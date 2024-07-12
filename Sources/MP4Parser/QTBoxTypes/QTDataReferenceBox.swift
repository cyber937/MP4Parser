//
//  QTDataReferenceBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTDataReferenceBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    
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
