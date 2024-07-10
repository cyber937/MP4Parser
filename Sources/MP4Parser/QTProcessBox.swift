//
//  QTProcessBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/10/24.
//

import Foundation

class QTProcessBox: QTBox {
    
    func process() async {
        
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
                await (qtBox as? QTProcessBox)?.process()
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
                await (qtBox as? QTProcessBox)?.process()
            case .tkhd:
                qtBox = QTTrackHeaderBox(data: data, location: location, type: type)
            case .mdia:
                qtBox = QTMediaBox(data: data, location: location, type: type)
                await (qtBox as? QTProcessBox)?.process()
            case .mdhd:
                qtBox = QTMediaHeaderBox(data: data, location: location, type: type)
            case .hdlr:
                qtBox = QTHandlerBox(data: data, location: location, type: type)
            case .minf:
                qtBox = QTMediaInformationBox(data: data, location: location, type: type)
                await (qtBox as? QTProcessBox)?.process()
            case .vmhd:
                qtBox = QTVideoMediaHeaderBox(data: data, location: location, type: type)
            case .smhd:
                qtBox = QTSoundMediaHeaderBox(data: data, location: location, type: type)
            case .dinf:
                qtBox = QTDataInformationBox(data: data, location: location, type: type)
                await (qtBox as? QTProcessBox)?.process()
            case .dref:
                qtBox = QTDataReferenceBox(data: data, location: location, type: type)
            case .stbl:
                qtBox = QTSampleTableBox(data: data, location: location, type: type)
                await (qtBox as? QTProcessBox)?.process()
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
                await (qtBox as? QTProcessBox)?.process()
            case .elst:
                qtBox = QTEditListBox(data: data ,location: location, type: type)
            case .avcC:
                qtBox = QTAVCConfigurationBox(data: data, location: location, type: type)
                
            default:
                qtBox = nil
            }
            
            guard let qtBox else {
                print("Missing Type ... \(typeString)")
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
