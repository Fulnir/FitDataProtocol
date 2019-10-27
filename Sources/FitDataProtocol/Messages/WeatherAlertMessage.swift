//
//  WeatherAlertMessage.swift
//  FitDataProtocol
//
//  Created by Kevin Hoogheem on 4/29/18.
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
import FitnessUnits
import AntMessageProtocol

/// FIT Weather Alert Message
@available(swift 4.2)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class WeatherAlertMessage: FitMessage {

    /// FIT Message Global Number
    public override class func globalMessageNumber() -> UInt16 { return 129 }

    /// Timestamp
    private(set) public var timeStamp: FitTime?

    /// Report ID
    ///
    /// Unique identifier from GCS report ID
    private(set) public var reportID: String?

    /// Issue Time
    ///
    /// Time alert was issued
    private(set) public var issueTime: FitTime?

    /// Expire Time
    ///
    /// Time alert expires
    private(set) public var expireTime: FitTime?

    /// Weather Severity
    private(set) public var severity: WeatherSeverity?

    /// Alert Type
    private(set) public var alertType: WeatherSeverityType?

    public required init() {}

    public init(timeStamp: FitTime? = nil,
                reportID: String? = nil,
                issueTime: FitTime? = nil,
                expireTime: FitTime? = nil,
                severity: WeatherSeverity? = nil,
                alertType: WeatherSeverityType? = nil) {
        
        self.timeStamp = timeStamp
        self.reportID = reportID
        self.issueTime = issueTime
        self.expireTime = expireTime
        self.severity = severity
        self.alertType = alertType

    }

    /// Decode Message Data into FitMessage
    ///
    /// - Parameters:
    ///   - fieldData: FileData
    ///   - definition: Definition Message
    ///   - dataStrategy: Decoding Strategy
    /// - Returns: FitMessage Result
    override func decode<F: WeatherAlertMessage>(fieldData: FieldData, definition: DefinitionMessage, dataStrategy: FitFileDecoder.DataDecodingStrategy) -> Result<F, FitDecodingError> {
        var timestamp: FitTime?
        var reportID: String?
        var issueTime: FitTime?
        var expireTime: FitTime?
        var severity: WeatherSeverity?
        var alertType: WeatherSeverityType?

        let arch = definition.architecture

        var localDecoder = DecodeData()

        for definition in definition.fieldDefinitions {

            let fitKey = FitCodingKeys(intValue: Int(definition.fieldDefinitionNumber))

            switch fitKey {
            case .none:
                // We still need to pull this data off the stack
                let _ = localDecoder.decodeData(fieldData.fieldData, length: Int(definition.size))
                //print("WeatherAlertMessage Unknown Field Number: \(definition.fieldDefinitionNumber)")

            case .some(let key):
                switch key {
                case .timestamp:
                    timestamp = FitTime.decode(decoder: &localDecoder,
                                               endian: arch,
                                               definition: definition,
                                               data: fieldData)

                case .reportId:
                    reportID = String.decode(decoder: &localDecoder,
                                             definition: definition,
                                             data: fieldData,
                                             dataStrategy: dataStrategy)

                case .issueTime:
                    issueTime = FitTime.decode(decoder: &localDecoder,
                                               endian: arch,
                                               definition: definition,
                                               data: fieldData)


                case .expireTime:
                    expireTime = FitTime.decode(decoder: &localDecoder,
                                                endian: arch,
                                                definition: definition,
                                                data: fieldData)

                case .severity:
                    severity = WeatherSeverity.decode(decoder: &localDecoder,
                                                      definition: definition,
                                                      data: fieldData,
                                                      dataStrategy: dataStrategy)

                case .alertType:
                    alertType = WeatherSeverityType.decode(decoder: &localDecoder,
                                                           definition: definition,
                                                           data: fieldData,
                                                           dataStrategy: dataStrategy)

                }

            }
        }

        let msg = WeatherAlertMessage(timeStamp: timestamp,
                                      reportID: reportID,
                                      issueTime: issueTime,
                                      expireTime: expireTime,
                                      severity: severity,
                                      alertType: alertType)
        
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
            case .timestamp:
                if let _ = timeStamp { fileDefs.append(key.fieldDefinition()) }

            case .reportId:
                if let stringData = reportID?.data(using: .utf8) {
                    //12 typical size... but we will count the String

                    guard stringData.count <= UInt8.max else {
                        return.failure(FitEncodingError.properySize("reportID size can not exceed 255"))
                    }

                    fileDefs.append(key.fieldDefinition(size: UInt8(stringData.count)))
                }
            case .issueTime:
                if let _ = issueTime { fileDefs.append(key.fieldDefinition()) }
            case .expireTime:
                if let _ = expireTime { fileDefs.append(key.fieldDefinition()) }
            case .severity:
                if let _ = severity { fileDefs.append(key.fieldDefinition()) }
            case .alertType:
                if let _ = alertType { fileDefs.append(key.fieldDefinition()) }
            }
        }

        if fileDefs.count > 0 {

            let defMessage = DefinitionMessage(architecture: .little,
                                               globalMessageNumber: WeatherAlertMessage.globalMessageNumber(),
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
            case .timestamp:
                if let timestamp = timeStamp {
                    msgData.append(timestamp.encode())
                }

            case .reportId:
                if let reportId = reportID {
                    if let stringData = reportId.data(using: .utf8) {
                        msgData.append(stringData)
                    }
                }

            case .issueTime:
                if let issueTime = issueTime {
                    msgData.append(issueTime.encode())
                }

            case .expireTime:
                if let expireTime = expireTime {
                    msgData.append(expireTime.encode())
                }

            case .severity:
                if let severity = severity {
                    if let error = msgData.shouldAppend(key.encodeKeyed(value: severity)) {
                        return.failure(error)
                    }
                }

            case .alertType:
                if let alertType = alertType {
                    if let error = msgData.shouldAppend(key.encodeKeyed(value: alertType)) {
                        return.failure(error)
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
