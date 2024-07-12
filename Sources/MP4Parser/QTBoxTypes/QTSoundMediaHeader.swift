//
//  QTSoundMediaHeaderBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTSoundMediaHeaderBox: QTFullBox {
    
    public private(set) var balance: Float?
    
    public init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.range, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        let offSet = range.lowerBound + 12
        
        balance =  data[offSet..<offSet+2].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)
        
    }
    
    override var extDescription: String? {
        get {
            
            guard let balance else { return nil }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Balance - \(balance)
            """
            
            return output
        }
        
        set {}
    }
}
