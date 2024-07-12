//
//  QTSampleDescriptionBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

public class QTSampleDescriptionBox: QTFullBox {
    
    public private(set) var entryCount: UInt32?
    
    public init(fullBox: QTFullBox) {
        
        super.init(data: fullBox.data, range: fullBox.range, type: fullBox.type)
        
        initialSetting()
    }
    
    public override init(data: Data, range: Range<UInt32>, type: QTBoxType) {
        
        super.init(data: data, range: range, type: type)
        
        initialSetting()
    }
    
    func initialSetting() {
        
        let offSet = range.lowerBound+12
        
        entryCount = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
    }
    
    func sampleEntryProcess(handleType: QTBoxHandlerType) {
        
        do {
            
            let box = try data.parseForBox(offset: range.lowerBound + 16)
            
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

public class QTSampleEntry: QTBox {
    
    public private(set) var dataReferenceIndex: UInt16?
    
    public init(box: QTBox) {
        super.init(data: box.data, range: box.range, type: box.type)
        
        let offset = box.range.lowerBound + 8 + 6
        
        dataReferenceIndex = data[offset..<offset + 2].QTUtilConvert(type: UInt16.self)
    }
}

public class QTVisualSampleEntry: QTSampleEntry {
    
    public private(set) var width: UInt16?
    public private(set) var height: UInt16?
    public private(set) var horizresolution: Float?
    public private(set) var vertresolution: Float?
    public private(set) var frameCount: UInt16?
    public private(set) var compressorname: String?
    public private(set) var depth: Float?
    public private(set) var offset: UInt32 = 0
    
    public override init(box: QTBox) {
        super.init(box: box)
        
        offset = box.range.lowerBound + 8 + 6 + 2 + 16
        
        width = data[offset..<offset + 2].QTUtilConvert(type: UInt16.self)
        
        height = data[offset + 2..<offset + 4].QTUtilConvert(type: UInt16.self)
        
        horizresolution = data[offset + 4..<offset + 8].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
        vertresolution = data[offset + 8..<offset + 12].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        
        frameCount = data[offset + 16..<offset + 18].QTUtilConvert(type: UInt16.self)
        
        compressorname = String(data: data[offset + 18..<offset + 50], encoding: .utf8)
        let filteredChars = "\"\n\\\0"
        compressorname = compressorname?.filter{ filteredChars.range(of: String($0)) == nil }
        
        depth = data[offset + 50..<offset + 52].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)

        offset += 54
    }
    
    public override var extDescription: String? {
        get {
            
            guard let width, let height, let horizresolution, let vertresolution, let frameCount, let compressorname, let depth else {
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
            \(indent)| Compression Name - \(compressorname)
            \(indent)| Depth - \(depth)
            """
            
            return output
        }
        
        set {}
    }
}

public class QTAVCSampleEntry: QTVisualSampleEntry {
    
    public private(set) var config: QTAVCConfigurationBox?
    
    public override init(box: QTBox) {
        super.init(box: box)
        
        let size = data[offset..<offset+4].QTUtilConvert(type: UInt32.self)
        
        guard let typeString = String(data: data[offset+4..<offset+8], encoding: .utf8) else {
            preconditionFailure()
        }
        
        let type = QTBoxType(rawValue: typeString)
        
        let range = offset..<offset+size
        
        config = QTAVCConfigurationBox(data: data, range: range, type: type!)
        
        addChild(qtBox: config!)
    }
    
    public override var extDescription: String? {
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

public class QTAVCConfigurationBox: QTBox {
    
    public private(set) var avcConfig: QTAVCDecoderConfigurationRecord?
    
    public override init(data: Data, range: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, range: range, type: type)
        
        let newLocation = range.lowerBound + 8 ..< range.upperBound
        
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

public class QTAVCDecoderConfigurationRecord {
    public private(set) var configurationVersion: UInt8?
    public private(set) var avcProfileIndication: UInt8?
    public private(set) var profileCompatibility: UInt8?
    public private(set) var avcLevelIndication: UInt8?
    public private(set) var lengthSizeMinusOne: UInt8?
    public private(set) var numOfSequenceParameterSets: UInt8?
    public private(set) var sequenceParameterSetLength = [UInt16]()
    public private(set) var sequenceParameterSetNALUnitRange = [Range<UInt32>]()
    public private(set) var numOfPictureParameterSets: UInt8?
    public private(set) var pictureParameterSetLength = [UInt16]()
    public private(set) var pictureParameterSetNALUnitRange = [Range<UInt32>]()
    
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

public class QTAudioSampleEntry: QTSampleEntry {
    
    public private(set) var channelCount: UInt16?
    public private(set) var sampleSize: UInt16?
    public private(set) var sampleRate: Float?
    
    public override init(box: QTBox) {
        super.init(box: box)
        
        let offset = box.range.lowerBound + 8 + 6 + 2 + 8
        
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
