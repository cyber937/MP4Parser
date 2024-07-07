//
//  QTUtility.swift
//  MP4Parser
//
//  Created by Kiyoshi Nagahama on 7/7/24.
//

import Foundation

extension Data {
    func QTUtilConvert<T: BinaryInteger>(type: T.Type) -> T {
        let result = self.reduce(0, { soFar, new in
            (soFar << 8) | T(new)
        })
        
        return result
    }
    
    func QTFixedPointConvert<Above: UnsignedInteger, Below: UnsignedInteger>(aboveType: Above.Type, belowType: Below.Type) -> Float {
        
        let aboveTypeSize = MemoryLayout<Above>.size
        let belowTypeSize = MemoryLayout<Below>.size
        
        //guard endIndex - startIndex == aboveTypeSize + belowTypeSize else { preconditionFailure() }
        
        let aboveDecimalPoint = self[startIndex..<startIndex + aboveTypeSize]
            .reduce(0, { soFar, new in
                (soFar << 8) | Above(new)
            })
        
        let belowDecimalPoint = self[startIndex + aboveTypeSize..<startIndex + aboveTypeSize + belowTypeSize]
            .reduce(0, { soFar, new in
                (soFar << 8) | Below(new)
            })
        
        let result = Float(aboveDecimalPoint) + Float(belowDecimalPoint) / Float(10 * belowDecimalPoint.words.count)
        
        return result
    }
    
    func QTMatrixConvert() -> [Float] {
        
        var result = [Float]()
        var i: Int = 0
        
        while i != 36 {
            
            var matrixValue: Float
            
            if i%3 == 2 {
                let aboveDecimalPoint = self[startIndex..<startIndex + 3]
                    .reduce(0, { soFar, new in
                        (soFar << 8) | Int(new)
                    })
                
                let belowDecimalPoint = self[startIndex+3..<startIndex + 4]
                    .reduce(0, { soFar, new in
                        (soFar << 8) | Int(new)
                    })
     
                matrixValue = Float(aboveDecimalPoint) / Float(10 * belowDecimalPoint.words.count)
            } else {
                matrixValue = self.QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
            }
                
            result.append(matrixValue)
            i = i + 4
        }
        
        return result
    }
}

func QTUtilUTCConvert(data: Data) -> Date {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let utcMidnightJan01904DateTime = formatter.date(from: "1904/01/01 00:00")
    
    let tempCtrationTimeSecond = data
        .reduce(0, { soFar, new in
            (soFar << 8) | UInt64(new)
        })
    
    let tempCtrationTimeInterval = TimeInterval(tempCtrationTimeSecond)
    let result = Date(timeInterval: tempCtrationTimeInterval, since: utcMidnightJan01904DateTime!)
    
    return result
}

