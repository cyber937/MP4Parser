//
//  QTSampleDescriptionBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTSampleDescriptionBox: QTFullBox {
    
    private(set) var entryCount: UInt32?
    
    init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, location: fullBox.location, type: fullBox.type)
        
        initialSetting()
    }
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, location: location, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        let offSet = location.lowerBound+12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
    }
    
    func sampleEntryProcess(handleType: QTBoxHandlerType) {
        
        do {
            
            let box = try data.parseForBox(offset: location.lowerBound + 16)
            
            if handleType == .vide {
                
                if box.type == .avc1 {
                    
                    let sampleEntoryBox = QTAVCSampleEntry(box: box)
                    
                    addChild(qtBox: sampleEntoryBox)
                    
                }
                    
            } else if handleType == .soun {
                
                let sampleEntoryBox = QTAudioSampleEntry(box: box)
                
                addChild(qtBox: sampleEntoryBox)
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override var extDescription: String? {
        get {
            
            guard let entryCount else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Entry Count - \(entryCount)
            """
            
            return output
        }
        
        set {}
    }
}

class QTSampleEntry: QTBox {
    
    var dataReferenceIndex: UInt16?
    
    init(box: QTBox) {
        super.init(data: box.data, location: box.location, type: box.type)
        
        let offset = box.location.lowerBound + 8 + 6
        
        dataReferenceIndex = data[offset..<offset + 2].QTUtilConvert(type: UInt16.self)
    }
}

class QTVisualSampleEntry: QTSampleEntry {
    
    var width: UInt16?
    var height: UInt16?
    var horizresolution: Float?
    var vertresolution: Float?
    var frameCount: UInt16?
    var compressionname: String?
    var depth: Float?
    var offset: UInt32 = 0
    
    override init(box: QTBox) {
        super.init(box: box)
        
        offset = box.location.lowerBound + 8 + 6 + 2 + 16
        
        width = data[offset..<offset + 2].QTUtilConvert(type: UInt16.self)
        
        height = data[offset + 2..<offset + 4].QTUtilConvert(type: UInt16.self)
        
        horizresolution = data[offset + 4..<offset + 8].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
        vertresolution = data[offset + 8..<offset + 12].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
        frameCount = data[offset + 16..<offset + 18].QTUtilConvert(type: UInt16.self)
        
        compressionname = String(data: data[offset + 18..<offset + 50], encoding: .utf8)
        
        depth = data[offset + 50..<offset + 52].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)

        offset += 54
    }
    
    override var extDescription: String? {
        get {
            
            guard let width, let height, let horizresolution, let vertresolution, let frameCount, let compressionname, let depth else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Width - \(width)
            \(indent)| Height  - \(height)
            \(indent)| Horizonal Resolution - \(horizresolution)
            \(indent)| Vertical Resolution - \(vertresolution)
            \(indent)| Frame Count - \(frameCount)
            \(indent)| Compression Name - \(compressionname)
            \(indent)| Depth - \(depth)
            """
            
            return output
        }
        
        set {}
    }
}

class QTAVCSampleEntry: QTVisualSampleEntry {
    
    var config: QTAVCConfigurationBox?
    
    override init(box: QTBox) {
        super.init(box: box)
        
        let size = data[offset..<offset+4].QTUtilConvert(type: UInt32.self)
        
        guard let typeString = String(data: data[offset+4..<offset+8], encoding: .utf8) else {
            preconditionFailure()
        }
        
        let type = QTBoxType(rawValue: typeString)
        
        let location = offset..<offset+size
        
        config = QTAVCConfigurationBox(data: data, location: location, type: type!)
        
        addChild(qtBox: config!)
    }
    
    override var extDescription: String? {
        get {
            
            guard let superExtDescription = super.extDescription
                else {
                    return nil
                }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \(superExtDescription)
            """
            
            return output
        }
        
        set {}
    }
    
}

class QTAVCConfigurationBox: QTBox {
    
    var avcConfig: QTAVCDecoderConfigurationRecord?
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        
        let newLocation = location.lowerBound + 8 ..< location.upperBound
        
        avcConfig = QTAVCDecoderConfigurationRecord(data: data, location: newLocation)
    }
    
    override var extDescription: String? {
        get {
            
            guard let avcConfig, let configurationVersion = avcConfig.configurationVersion, let avcProfileIndication = avcConfig.avcProfileIndication, let profileCompatibility = avcConfig.profileCompatibility, let avcLevelIndication = avcConfig.avcLevelIndication, let lengthSizeMinusOne = avcConfig.lengthSizeMinusOne, let numOfSequenceParameterSets = avcConfig.numOfSequenceParameterSets, let numOfPictureParameterSets = avcConfig.numOfPictureParameterSets else { return nil }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Configuration Version - \(configurationVersion)
            \(indent)| AVC Profile Indication  - \(avcProfileIndication)
            \(indent)| Profile Compatibility - \(profileCompatibility)
            \(indent)| AVC Level Indication - \(avcLevelIndication)
            \(indent)| Length Size Minus One - \(lengthSizeMinusOne)
            \(indent)| Number Of Sequence Parameter Sets - \(numOfSequenceParameterSets)
            \(indent)| Sequence Parameter Set Length - \(avcConfig.sequenceParameterSetLength)
            \(indent)| Sequence Parameter Set NAL Unit Range - \(avcConfig.sequenceParameterSetNALUnitRange)
            \(indent)| Number Of Picture Parameter Sets - \(numOfPictureParameterSets)
            \(indent)| Picture Parameter Set Length - \(avcConfig.pictureParameterSetLength)
            \(indent)| Picture Parameter Set NAL Unit Range - \(avcConfig.pictureParameterSetNALUnitRange)
            """
            
            return output
        }
        
        set {}
    }
}

class QTAVCDecoderConfigurationRecord {
    var configurationVersion: UInt8?
    var avcProfileIndication: UInt8?
    var profileCompatibility: UInt8?
    var avcLevelIndication: UInt8?
    var lengthSizeMinusOne: UInt8?
    var numOfSequenceParameterSets: UInt8?
    var sequenceParameterSetLength = [UInt16]()
    var sequenceParameterSetNALUnitRange = [Range<UInt32>]()
    var numOfPictureParameterSets: UInt8?
    var pictureParameterSetLength = [UInt16]()
    var pictureParameterSetNALUnitRange = [Range<UInt32>]()
    
    init(data: Data, location: Range<UInt32>) {
        
        var offset = location.lowerBound
        
        var tempData: UInt8
        
        configurationVersion = data[offset..<offset+1].QTUtilConvert(type: UInt8.self)
        
        avcProfileIndication = data[offset+1..<offset+2].QTUtilConvert(type: UInt8.self)
        
        profileCompatibility = data[offset+2..<offset+3].QTUtilConvert(type: UInt8.self)
        
        avcLevelIndication = data[offset+3..<offset+4].QTUtilConvert(type: UInt8.self)
        
        tempData = data[offset+4..<offset+5].QTUtilConvert(type: UInt8.self)
        lengthSizeMinusOne = UInt8(tempData & 0b0000_0011)
        
        tempData = data[offset+5..<offset+6].QTUtilConvert(type: UInt8.self)
        numOfSequenceParameterSets = tempData & 0b0001_1111
        
        for _ in 0..<numOfSequenceParameterSets! {
            let tempSequenceParameterSetLength = data[offset+6..<offset+8].QTUtilConvert(type: UInt16.self)
            sequenceParameterSetLength.append(tempSequenceParameterSetLength)
            sequenceParameterSetNALUnitRange.append(offset+8..<UInt32(tempSequenceParameterSetLength) + offset + 8)
            offset += UInt32(tempSequenceParameterSetLength)
        }
        
        numOfPictureParameterSets = data[offset+8..<offset+9].QTUtilConvert(type: UInt8.self)
        
        for _ in 0..<numOfPictureParameterSets! {
            let tempPictureParameterSetLength = data[offset+9..<offset+11].QTUtilConvert(type: UInt16.self)
            pictureParameterSetLength.append(tempPictureParameterSetLength)
            pictureParameterSetNALUnitRange.append(offset+11..<UInt32(tempPictureParameterSetLength) + offset + 11)
            offset += UInt32(tempPictureParameterSetLength)
        }
    }
    
    
}

class QTAudioSampleEntry: QTSampleEntry {
    
    var channelCount: UInt16?
    var sampleSize: UInt16?
    var sampleRate: Float?
    
    override init(box: QTBox) {
        super.init(box: box)
        
        let offset = box.location.lowerBound + 8 + 6 + 2 + 8
        
        channelCount = data[offset..<offset + 2].QTUtilConvert(type: UInt16.self)
        
        sampleSize = data[offset + 2..<offset + 4].QTUtilConvert(type: UInt16.self)
        
        sampleRate = data[offset + 8..<offset + 12].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
    }
    
    override var extDescription: String? {
        get {
            
            guard let channelCount, let sampleSize, let sampleRate else {
                return nil
            }
            
            var indent: String = ""
            
            for _ in 0..<level {
                indent = indent + "   "
            }
            
            let output = """
            \n\(indent)|
            \(indent)| Channel Count - \(channelCount)
            \(indent)| Sample Size  - \(sampleSize)
            \(indent)| Sample Rate - \(sampleRate)
            """
            
            return output
        }
        
        set {}
    }
}
