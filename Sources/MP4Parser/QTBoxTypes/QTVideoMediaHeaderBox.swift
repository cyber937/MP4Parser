//
//  QTVideoMediaHeaderBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTVideoMediaHeaderBox: QTFullBox {
    
    public private(set) var graphicsmode: UInt16?
    public private(set) var opcolor = [UInt16]()
    
    public init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.range, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        let offSet = range.lowerBound+12 //
        
        graphicsmode = data[offSet..<offSet+2].QTUtilConvert(type: UInt16.self)
        
        opcolor = [data[offSet+2..<offSet+4].QTUtilConvert(type: UInt16.self),
                   data[offSet+4..<offSet+6].QTUtilConvert(type: UInt16.self),
                   data[offSet+6..<offSet+8].QTUtilConvert(type: UInt16.self)
        ]
    }
    
    override var extDescription: String? {
        get {
            
            guard let graphicsmode else { return nil }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Graphicsmode - \(graphicsmode)
            \(indent)| Opcolor  - \(opcolor)
            """
            
            return output
        }
        
        set {}
    }
}
