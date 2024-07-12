//
//  QTHandlerBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTHandlerBox: QTFullBox {
    
    public private(set) var handlerType: QTBoxHandlerType?
    public private(set) var name: String?
    
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
        
        guard let handlerTypeStr = String(data: data[offSet+4..<offSet+8], encoding: .utf8) else {
            preconditionFailure()
        }
        
        switch handlerTypeStr {
        case "vide":
            handlerType = .vide
        case "soun":
            handlerType = .soun
        case "hint":
            handlerType = .hint
        case "meta":
            handlerType = .meta
            
        default:
            print("Handler Error ... \(handlerTypeStr)")
        }
        
        // reserved unsigned int (32) [3] // 96
        
        if let handlerTypeStr = String(data: data[offSet+20..<range.upperBound], encoding: .utf8) {
            name = handlerTypeStr
        } else {
            name = "Undifined"
        }
    }
    
    override var extDescription: String? {
        get {
            
            guard let handlerType, let name else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Handler Type - \(handlerType)
            \(indent)| Name - \(name)
            """
            
            return output
        }
        
        set {}
    }
}
