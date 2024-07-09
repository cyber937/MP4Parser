//
//  QTBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

enum QTBoxError: Error {
    case unableToGetBoxType
}

public enum QTBoxType: String {
    case root
    
    case ftyp // File Type Box
    case free // Free Space Box
    case mdat // Media Data Box
    case meta // Meta Box
    //case uuid
    case moov // Movie Box
    case mvhd // Movie Header Box
    case trak // Track Box
    case tkhd // Track Header Box
    case mdia // Media Box
    case mdhd // Media Header Box
    case hdlr // Handler Reference Box
    case minf // Media Information Box
    case dinf // Data Information Box
    case dref // Data Reference Box
    case stbl // Sample Table Box
    case vmhd // Video Media Header Box
    case smhd // Sound Media Header Box
    case stsd // Sample Description Box
    case stts // Dacoding Time to Sample Box
    case ctts // Composition Time to Sample Box
    case stsc // Sample To Chunk Box
    case stsz // Sample Size Boxes
    case stco // Chunk Offset Box
    case stss // Sync Sample Box
    case edts // Edit Box
    case elst // Edit List Box
    
    case avc1
    case avcC
    case mp4a
}

func QTBoxTypeReadableName(type: QTBoxType) -> String {
    
    switch type {
    case .root:
        return "Root Box"
    case .ftyp:
        return "File Type Box"
    case .free:
        return "Free Space Box"
    case .mdat:
        return "Media Data Box"
    case .meta:
        return "Meta Box"
        //case .uuid
    case .moov:
        return "Movie Box"
    case .mvhd:
        return "Movie Header Box"
    case .trak:
        return "Track Box"
    case .tkhd:
        return "Track Header Box"
    case .mdia:
        return "Media Box"
    case .mdhd:
        return "Media Header Box"
    case .hdlr:
        return "Handler Reference Box"
    case .minf:
        return "Media Information Box"
    case .dinf:
        return "Data Information Box"
    case .dref:
        return "Data Reference Box"
    case .stbl:
        return "Sample Table Box"
    case .vmhd:
        return "Video Media Header Box"
    case .smhd:
        return "Sound Media Header Box"
    case .stsd:
        return "Sample Description Box"
    case .stts:
        return "Dacoding Time to Sample Box"
    case .ctts:
        return "Composition Time to Sample Box"
    case .stsc:
        return "Sample To Chunk Box"
    case .stsz:
        return "Sample Size Boxe"
    case .stco:
        return "Chunk Offset Box"
    case .stss:
        return "Sync Sample Box"
    case .edts:
        return "Edit Box"
    case .elst:
        return "Edit List Box"
    case .avc1:
        return "AVC Sample Entry"
    case .avcC:
        return "AVC Configuration Box"
    case .mp4a:
        return "MP4 Audio Sample Entry"
    }
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
    var type: QTBoxType
    
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
    
    func process() {
        
        var offSet: UInt32
        
        if type == .root {
            offSet = 0
        } else {
            offSet = 8
        }
        
        var i: UInt32 = location.lowerBound + offSet
        
        while i != location.upperBound {
            
            var size: UInt32 = 0
            var extSize: UInt64?
            var location: Range<UInt32>
            
            guard let typeString = String(data: data[i+4..<i+8], encoding: .utf8) else {
                preconditionFailure()
            }
            
            let type = QTBoxType(rawValue: typeString)
            
            size = data[i..<i+4].QTUtilConvert(type: UInt32.self)
            
            if size == 1 {
                extSize = data[i+8..<i+16].QTUtilConvert(type: UInt64.self)
                
                location = i..<i+UInt32(extSize!)
                i += UInt32(extSize!)
            } else {
                location = i..<i+UInt32(size)
                i += UInt32(size)
            }
            
            var qtBox: QTBox?
            
            guard let type else { continue }
            
            switch type {
            case .ftyp:
                qtBox = QTFileTypeBox(data: data, location: location, type: type)
            case .moov:
                qtBox = QTMovieBox(data: data, location: location, type: type)
            case .mdat:
                qtBox = QTMediaDataBox(data: data, location: location, type: type)
            case .free:
                qtBox = QTFreeBox(data: data, location: location, type: type)
                //            case .meta:
                //                qtAtom = QTMeta(data: data,size: size, extSize: extSize, location: location)
                //            case .uuid:
                //                qtAtom = QTUuid(data: data,size: size, extSize: extSize, location: location)
            case .mvhd:
                qtBox = QTMovieHeaderBox(data: data, location: location, type: type)
            case .trak:
                qtBox = QTTrackBox(data: data, location: location, type: type)
            case .tkhd:
                qtBox = QTTrackHeaderBox(data: data, location: location, type: type)
            case .mdia:
                qtBox = QTMediaBox(data: data, location: location, type: type)
            case .mdhd:
                qtBox = QTMediaHeaderBox(data: data, location: location, type: type)
            case .hdlr:
                qtBox = QTHandlerBox(data: data, location: location, type: type)
            case .minf:
                qtBox = QTMediaInformationBox(data: data, location: location, type: type)
            case .vmhd:
                qtBox = QTVideoMediaHeaderBox(data: data, location: location, type: type)
            case .smhd:
                qtBox = QTSoundMediaHeaderBox(data: data, location: location, type: type)
            case .dinf:
                qtBox = QTDataInformationBox(data: data, location: location, type: type)
            case .dref:
                qtBox = QTDataReferenceBox(data: data, location: location, type: type)
            case .stbl:
                qtBox = QTSampleTableBox(data: data, location: location, type: type)
            case .stts:
                qtBox = QTTimeToSampleBox(data: data, location: location, type: type)
            case .ctts:
                qtBox = QTCompositionOffsetBox(data: data, location: location, type: type)
            case .stsd:
                qtBox = QTSampleDescriptionBox(data: data, location: location, type: type)
            case .stsc:
                qtBox = QTSampleToChunkBox(data: data ,location: location, type: type)
            case .stsz:
                qtBox = QTSampleSizeBox(data: data ,location: location, type: type)
            case .stco:
                qtBox = QTChunkOffsetBox(data: data ,location: location, type: type)
            case .stss:
                qtBox = QTSyncSampleBox(data: data ,location: location, type: type)
            case .edts:
                qtBox = QTEditBox(data: data ,location: location, type: type)
            case .elst:
                qtBox = QTEditListBox(data: data ,location: location, type: type)
            case .avcC:
                qtBox = QTAVCConfigurationBox(data: data, location: location, type: type)
                
            default:
                qtBox = nil
            }
            
            guard let qtBox else {
                continue
            }
            
            addChild(qtBox: qtBox)
            
            if qtBox is QTMediaBox {
                
                guard let children = qtBox.children else { return }
                
                let handlerBox = children.filter { child in child.type == .hdlr }[0] as! QTHandlerBox
                guard let handlerType = handlerBox.handlerType else { return }
                
                let mediaInformationBox = children.filter { child in child.type == .minf }[0] as! QTMediaInformationBox
                
                let sampleTableBox = mediaInformationBox.children?.filter { child in child.type == .stbl }[0] as! QTSampleTableBox
                
                let sampleDescriptionBox = sampleTableBox.children?.filter { child in child.type == .stsd }[0] as! QTSampleDescriptionBox
                
                sampleDescriptionBox.sampleEntryProcess(handleType: handlerType)
            }
        }
    }
}

class QTFullBox: QTBox {
    
    var version: UInt8?
    var flags = [Int8]()
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        
        let offset = location.lowerBound + 8
        version = data[offset..<offset+1].QTUtilConvert(type: UInt8.self)
        
        flags = [data[offset+1..<offset+2].QTUtilConvert(type: Int8.self),
                 data[offset+2..<offset+3].QTUtilConvert(type: Int8.self),
                 data[offset+3..<offset+4].QTUtilConvert(type: Int8.self)]
    }
}

extension Data {
    
    public func parseForMP4Data() throws -> QTBox {
        
        let rootBox = QTRootBox(data: self, location: 0..<UInt32(self.count), type: .root)
        
        rootBox.process()
        
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
