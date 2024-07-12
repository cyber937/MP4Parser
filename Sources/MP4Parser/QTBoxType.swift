//
//  QTBoxType.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/10/24.
//

import Foundation

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
    
    case url = "url " // Data Entory URL Box
    
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
        
    case .url:
        return "Data Entory URL Box"
        
    case .avc1:
        return "AVC Sample Entry"
    case .avcC:
        return "AVC Configuration Box"
    case .mp4a:
        return "MP4 Audio Sample Entry"
    }
}
