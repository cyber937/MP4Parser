//
//  File.swift
//  
//
//  Created by Kiyoshi Nagahama on 7/11/24.
//

import Foundation

extension Data {
    
    public func parseForMP4Data() async throws -> QTBox {
        
        let rootBox = QTRootBox(data: self, range: 0..<UInt32(self.count), type: .root)
        await rootBox.process()
        return rootBox
    }
    
    public func parseForBox(offset: UInt32 = 0) throws -> QTBox {
        
        // Getting size
        let size: UInt32 = self[offset..<4+offset].QTUtilConvert(type: UInt32.self)
        
        // Getting boxType
        guard let boxTypeString = String(data: self[4+offset..<8+offset], encoding: .utf8), let type = QTBoxType(rawValue: boxTypeString) else {
            throw QTBoxError.unableToGetBoxType
        }
        
        let box = QTBox(data: self, range: offset..<offset + size, type: type)
        
        return box
    }
    
    public func parseForFullBox(offset: UInt32 = 0) throws -> QTFullBox {
        
        // Getting size
        let size: UInt32 = self[offset..<4+offset].QTUtilConvert(type: UInt32.self)
        
        // Getting boxType
        guard let boxTypeString = String(data: self[4+offset..<8+offset], encoding: .utf8), let type = QTBoxType(rawValue: boxTypeString) else {
            throw QTBoxError.unableToGetBoxType
        }
        
        let fullbox = QTFullBox(data: self, range: offset..<offset + size, type: type)
        
        return fullbox
    }
}
