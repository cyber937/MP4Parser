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
    
    init(fullBox: QTFullBox) {
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        initialization()
    }
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        initialization()
    }
        
        func initialization() {
        let offSet = location.lowerBound+12 // Offset ... size(4) + type(4) + version(1) + flags(3) = 12
        
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
        
        if let handlerTypeStr = String(data: data[offSet+20..<location.upperBound], encoding: .utf8) {
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
