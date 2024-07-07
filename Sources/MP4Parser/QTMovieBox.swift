//
//  QTMovieBox.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

class QTMovieBox: QTBox {
    
    override init(data: Data, location: Range<UInt32>, type: QTBoxType) {
        super.init(data: data, location: location, type: type)
        
        process()
    }
    
}
