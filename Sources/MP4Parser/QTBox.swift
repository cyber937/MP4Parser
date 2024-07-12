//
//  QTBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

enum QTBoxError: Error {
    case unableToGetBoxType
    case failedToProcessBoxes
}

public enum QTBoxHandlerType {
    case vide
    case soun
    case hint
    case meta
}

public class QTBox: Identifiable, Hashable {
    
    // Hashable protocol
    public static func == (lhs: QTBox, rhs: QTBox) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    let data: Data
    
    public private(set) var range: Range<UInt32>
    
    public private(set) var type: QTBoxType
    
    public var typeReadable: String {
        return QTBoxTypeReadableName(type: type)
    }
    
    public private(set) var size: Int
    
    var level: Int {
        
        var tempLevel: Int = 0
        
        var tempParent = self.parent
        
        while tempParent != nil {
            tempLevel += 1
            tempParent = tempParent?.parent
        }
        
        return tempLevel
    }
    
    internal var extDescription: String?
    
    public var children: [QTBox]? = nil
    
    public private(set) weak var parent: QTBox?
    
    public var description: String {
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        var output = ""
        
        output += "\(indent)Type: \(type) - \(QTBoxTypeReadableName(type: type))\n"
        output += "\(indent)| Size - \(size)\n"
        output += "\(indent)| Range - \(range)\n"
        output += "\(indent)| Level - \(level)"
        
        if let extDescription = extDescription {
            output += extDescription
        }
        
        output += "\n\n"
        
        if let children {
            for child in children {
                output += child.description
            }
        }
        
        return output
    }
    
    init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        self.data = data
        self.range = location
        self.type = type
        self.size = Int(location.upperBound - location.lowerBound)
    }
    
    func addChild(qtBox: QTBox) {
        qtBox.parent = self
        
        if children == nil {
            children = [QTBox]()
        }
        
        children?.append(qtBox)
        
    }
    
    public func search(type: QTBoxType) -> [QTBox] {
        
        var founds = [QTBox]()
        
        if type == self.type {
            founds.append(self)
            return founds
        }
        
        if let children {
            for child in children {
                founds.append(contentsOf: child.search(type: type))
            }
        }
        
        return founds
    }
}
