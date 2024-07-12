//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 7/12/24.
//

import Foundation

public class QTDataEntryUrlBox: QTFullBox {
    
    public private(set) var locationSize: UInt32?
    
    public init(fullBox: QTFullBox) {
        super.init(data: fullBox.data, range: fullBox.range, type: fullBox.type)
        initialization()
    }
    
    public override init(data: Data, range: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, range: range, type: type)
        initialization()
    }
    
    func initialization() {
        let offSet = range.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
        let lengthOfLocation = UInt32(size) - offSet
        
        locationSize = lengthOfLocation
    }
    
    override var extDescription: String? {
        get {
            
            guard let locationSize else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Location Size - \(locationSize)
            """
            
            return output
        }
        
        set {}
    }
}
