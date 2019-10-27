//
//  HrvMessage.swift
//  FitDataProtocol
//
//  Created by Kevin Hoogheem on 2/3/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import DataDecoder

/// FIT HRV Message
///
/// Used to record heart rate variability data. The hrv data messages contain an
/// array of RR intervals and are interleaved with record and event messages in chronological order
@available(swift 4.2)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class HrvMessage: FitMessage {

    /// FIT Message Global Number
    public override class func globalMessageNumber() -> UInt16 { return 78 }

    /// Heart Rate Variability
    ///
    /// Time between beats
    private(set) public var hrv: [Measurement<UnitDuration>]?

    public required init() {}

    internal init(_ hrv: [Measurement<UnitDuration>]?) {
        self.hrv = hrv
    }

    public init(hrv: [Measurement<UnitDuration>]) {
        self.hrv = hrv
    }

    /// Decode Message Data into FitMessage
    ///
    /// - Parameters:
    ///   - fieldData: FileData
    ///   - definition: Definition Message
    ///   - dataStrategy: Decoding Strategy
    /// - Returns: FitMessage Result
    override func decode<F: HrvMessage>(fieldData: FieldData, definition: DefinitionMessage, dataStrategy: FitFileDecoder.DataDecodingStrategy) -> Result<F, FitDecodingError> {
        var hrv: [Measurement<UnitDuration>]?
        
        let arch = definition.architecture
        
        var localDecoder = DecodeData()
        
        for definition in definition.fieldDefinitions {
            
            let fitKey = FitCodingKeys(intValue: Int(definition.fieldDefinitionNumber))
            
            switch fitKey {
            case .none:
                // We still need to pull this data off the stack
                let _ = localDecoder.decodeData(fieldData.fieldData, length: Int(definition.size))
                //print("HrvMessage Unknown Field Number: \(definition.fieldDefinitionNumber)")
                
            case .some(let key):
                switch key {
                    
                case .time:
                    let timeData = localDecoder.decodeData(fieldData.fieldData, length: Int(definition.size))
                    
                    var localDecoder = DecodeData()
                    
                    var seconds = arch == .little ? localDecoder.decodeUInt16(timeData).littleEndian : localDecoder.decodeUInt16(timeData).bigEndian
                    
                    while seconds != 0 {
                        /// 1000 * s + 0, Time between beats
                        let value = seconds.resolution(.removing, resolution: key.resolution)
                        let interval = Measurement(value: value, unit: UnitDuration.seconds)
                        
                        if hrv == nil {
                            hrv = [Measurement<UnitDuration>]()
                        }
                        hrv?.append(interval)
                        
                        seconds = arch == .little ? localDecoder.decodeUInt16(timeData).littleEndian : localDecoder.decodeUInt16(timeData).bigEndian
                    }
                    
                }
            }
        }
        
        let msg = HrvMessage(hrv)
        
        let devData = self.decodeDeveloperData(data: fieldData, definition: definition)
        msg.developerData = devData.isEmpty ? nil : devData

        return.success(msg as! F)
    }

    /// Encodes the Definition Message for FitMessage
    ///
    /// - Parameters:
    ///   - fileType: FileType
    ///   - dataValidityStrategy: Validity Strategy
    /// - Returns: DefinitionMessage Result
    internal override func encodeDefinitionMessage(fileType: FileType?, dataValidityStrategy: FitFileEncoder.ValidityStrategy) -> Result<DefinitionMessage, FitEncodingError> {

//        do {
//            try validateMessage(fileType: fileType, dataValidityStrategy: dataValidityStrategy)
//        } catch let error as FitEncodingError {
//            return.failure(error)
//        } catch {
//            return.failure(FitEncodingError.fileType(error.localizedDescription))
//        }
        
        var fileDefs = [FieldDefinition]()

        for key in FitCodingKeys.allCases {

            switch key {
            case .time:
                if let hrv = hrv {
                    if hrv.count > 0 {
                        fileDefs.append(key.fieldDefinition(size: UInt8(hrv.count)))
                    }
                }
            }
        }

        if fileDefs.count > 0 {

            let defMessage = DefinitionMessage(architecture: .little,
                                               globalMessageNumber: HrvMessage.globalMessageNumber(),
                                               fields: UInt8(fileDefs.count),
                                               fieldDefinitions: fileDefs,
                                               developerFieldDefinitions: [DeveloperFieldDefinition]())

            return.success(defMessage)
        } else {
            return.failure(self.encodeNoPropertiesAvailable())
        }
    }

    /// Encodes the Message into Data
    ///
    /// - Parameters:
    ///   - localMessageType: Message Number, that matches the defintions header number
    ///   - definition: DefinitionMessage
    /// - Returns: Data Result
    internal override func encode(localMessageType: UInt8, definition: DefinitionMessage) -> Result<Data, FitEncodingError> {

        guard definition.globalMessageNumber == type(of: self).globalMessageNumber() else  {
            return.failure(self.encodeWrongDefinitionMessage())
        }

        let msgData = MessageData()

        for key in FitCodingKeys.allCases {

            switch key {
            case .time:
                if let hrv = hrv {
                    if hrv.count > 0 {
                        for time in hrv {
                            let hrvTime = time.converted(to: UnitDuration.seconds)
                            if let error = msgData.shouldAppend(key.encodeKeyed(value: hrvTime.value)) {
                                return.failure(error)
                            }
                        }
                    }
                }
            }
        }

        if msgData.message.count > 0 {
            return.success(encodedDataMessage(localMessageType: localMessageType, msgData: msgData.message))
        } else {
            return.failure(self.encodeNoPropertiesAvailable())
        }
    }
}
