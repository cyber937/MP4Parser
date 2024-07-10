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

public class QTBox: Identifiable {
    let data: Data
    var location: Range<UInt32>
    
    public var type: QTBoxType
    
    public var typeReadable: String {
        return QTBoxTypeReadableName(type: type)
    }
    
    var size: Int
    var level: Int {
        
        var tempLevel: Int = 0
        
        var tempParent = self.parent
        
        while tempParent != nil {
            tempLevel += 1
            tempParent = tempParent?.parent
        }
        
        return tempLevel
    }
    var extDescription: String?
    
    public var children: [QTBox]? = nil
    
    weak var parent: QTBox?
    
    public var description: String {
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        var output = ""
        
        output += "\(indent)Type: \(type) - \(QTBoxTypeReadableName(type: type))\n"
        output += "\(indent)| Size - \(size)\n"
        output += "\(indent)| Range - \(location)\n"
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
        self.location = location
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

extension Data {
    
    public func parseForMP4Data() async throws -> QTBox {
        
        let rootBox = QTRootBox(data: self, location: 0..<UInt32(self.count), type: .root)
        await rootBox.process()
        return rootBox
    }
    
    func parseForBox(offset: UInt32 = 0) throws -> QTBox {
        
        // Getting size
        let size: UInt32 = self[offset..<4+offset].QTUtilConvert(type: UInt32.self)
        
        // Getting boxType
        guard let boxTypeString = String(data: self[4+offset..<8+offset], encoding: .utf8), let type = QTBoxType(rawValue: boxTypeString) else {
            throw QTBoxError.unableToGetBoxType
        }
        
        let box = QTBox(data: self, location: offset..<offset + size, type: type)
        
        return box
    }
    
    func parseForFullBox(offset: UInt32 = 0) throws -> QTFullBox {
        
        // Getting size
        let size: UInt32 = self[offset..<4+offset].QTUtilConvert(type: UInt32.self)
        
        // Getting boxType
        guard let boxTypeString = String(data: self[4+offset..<8+offset], encoding: .utf8), let type = QTBoxType(rawValue: boxTypeString) else {
            throw QTBoxError.unableToGetBoxType
        }
        
        let fullbox = QTFullBox(data: self, location: offset..<offset + size, type: type)
        
        return fullbox
    }
}
