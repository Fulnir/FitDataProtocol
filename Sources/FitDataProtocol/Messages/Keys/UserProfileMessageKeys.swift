//
//  UserProfileMessageKeys.swift
//  FitDataProtocol
//
//  Created by Kevin Hoogheem on 8/18/18.
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
import AntMessageProtocol
import FitnessUnits

@available(swift 4.2)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
extension UserProfileMessage: FitMessageKeys {
    /// CodingKeys for FIT Message Type
    public typealias FitCodingKeys = MessageKeys

    /// FIT Message Keys
    public enum MessageKeys: Int, CodingKey, CaseIterable {
        /// Message Index
        case messageIndex                   = 254
        /// Timestamp
        case timestamp                      = 253

        /// Friendly Name
        case friendlyName                   = 0
        /// Gender
        case gender                         = 1
        /// Age
        case age                            = 2
        /// Height
        case height                         = 3
        /// Weight
        case weight                         = 4
        /// Language
        case language                       = 5
        /// Elevation Setting
        case elevationSetting               = 6
        /// Weight Setting
        case weightSetting                  = 7
        /// Resting Heart Rate
        case restingHeartRate               = 8
        /// Default Max Running Heart Rate
        case defaultMaxRunningHeartRate     = 9
        /// Default Max Biking Heart Rate
        case defaultMaxBikingHeartRate      = 10
        /// Default Max Heart Rate
        case defaultMaxHeartRate            = 11
        /// Heart Rate Setting
        case heartRateSetting               = 12
        /// Speed Setting
        case speedSetting                   = 13
        /// Distance Setting
        case distanceSetting                = 14
        /// Power Setting
        case powerSetting                   = 16
        /// Activity Class
        case activityClass                  = 17
        /// Position Setting
        case positionSetting                = 18
        /// Temperature Setting
        case temperatureSetting             = 21
        /// Local ID
        case localID                        = 22
        /// Global ID
        case globalID                       = 23
        /// Height Setting
        case heightSetting                  = 30
        /// Running Step Length
        case runningStepLength              = 31
        /// Walking Step Length
        case walkingStepLength              = 32
    }
}

public extension UserProfileMessage.FitCodingKeys {

    /// Key Base Type
    public var baseType: BaseType {
        switch self {
        case .messageIndex:
            return .uint16
        case .timestamp:
            return .uint32

        case .friendlyName:
            return .string //16
        case .gender:
            return .enumtype
        case .age:
            return .uint8
        case .height:
            return .uint8
        case .weight:
            return .uint16
        case .language:
            return .enumtype
        case .elevationSetting:
            return .enumtype
        case .weightSetting:
            return .enumtype
        case .restingHeartRate:
            return .uint8
        case .defaultMaxRunningHeartRate:
            return .uint8
        case .defaultMaxBikingHeartRate:
            return .uint8
        case .defaultMaxHeartRate:
            return .uint8
        case .heartRateSetting:
            return .enumtype
        case .speedSetting:
            return .enumtype
        case .distanceSetting:
            return .enumtype
        case .powerSetting:
            return .enumtype
        case .activityClass:
            return .enumtype
        case .positionSetting:
            return .enumtype
        case .temperatureSetting:
            return .enumtype
        case .localID:
            return .uint16
        case .globalID:
            return .byte    //6
        case .heightSetting:
            return .enumtype
        case .runningStepLength:
            return .uint16
        case .walkingStepLength:
            return .uint16
        }
    }
}

internal extension UserProfileMessage.FitCodingKeys {

    /// Key Base Type Resolution
    var resolution: Resolution {
        switch self {
        case .messageIndex:
            return Resolution(scale: 1.0, offset: 0.0)
        case .timestamp:
            return Resolution(scale: 1.0, offset: 0.0)

        case .friendlyName:
            return Resolution(scale: 1.0, offset: 0.0)
        case .gender:
            return Resolution(scale: 1.0, offset: 0.0)
        case .age:
            /// 1 * years
            return Resolution(scale: 1.0, offset: 0.0)
        case .height:
            //  100 * m + 0
            return Resolution(scale: 100.0, offset: 0.0)
        case .weight:
            //  10 * kg + 0
            return Resolution(scale: 10.0, offset: 0.0)
        case .language:
            return Resolution(scale: 1.0, offset: 0.0)
        case .elevationSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .weightSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .restingHeartRate:
            // 1 * bpm + 0
            return Resolution(scale: 1.0, offset: 0.0)
        case .defaultMaxRunningHeartRate:
            // 1 * bpm + 0
            return Resolution(scale: 1.0, offset: 0.0)
        case .defaultMaxBikingHeartRate:
            // 1 * bpm + 0
            return Resolution(scale: 1.0, offset: 0.0)
        case .defaultMaxHeartRate:
            // 1 * bpm + 0
            return Resolution(scale: 1.0, offset: 0.0)
        case .heartRateSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .speedSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .distanceSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .powerSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .activityClass:
            return Resolution(scale: 1.0, offset: 0.0)
        case .positionSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .temperatureSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .localID:
            return Resolution(scale: 1.0, offset: 0.0)
        case .globalID:
            return Resolution(scale: 1.0, offset: 0.0)
        case .heightSetting:
            return Resolution(scale: 1.0, offset: 0.0)
        case .runningStepLength:
            // 1000 * m + 0, User defined running step length set to 0 for auto length
            return Resolution(scale: 1000.0, offset: 0.0)
        case .walkingStepLength:
            // 1000 * m + 0, User defined running step length set to 0 for auto length
            return Resolution(scale: 1000.0, offset: 0.0)
        }
    }
}

// Encoding
internal extension UserProfileMessage.FitCodingKeys {

    internal func encodeKeyed(value: Gender) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: Language) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: MeasurementDisplayType) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: HeartRateDisplayType) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: PositionDisplayType) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: PowerDisplayType) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }
}

// Encoding
extension UserProfileMessage.FitCodingKeys: KeyedEncoder {

    internal func encodeKeyed(value: Bool) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: UInt8) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: ValidatedBinaryInteger<UInt8>) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: UInt16) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: ValidatedBinaryInteger<UInt16>) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: UInt32) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: ValidatedBinaryInteger<UInt32>) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }

    internal func encodeKeyed(value: Double) throws -> Data {
        return try self.baseType.encodedResolution(value: value, resolution: self.resolution)
    }
}

extension UserProfileMessage.FitCodingKeys: KeyedFieldDefintion {

    /// Create a Field Definition Message From the Key
    ///
    /// - Parameter size: Data Size, if nil will use the keys predefined size
    /// - Returns: FieldDefinition
    internal func fieldDefinition(size: UInt8) -> FieldDefinition {

        let fieldDefinition = FieldDefinition(fieldDefinitionNumber: UInt8(self.rawValue),
                                              size: size,
                                              endianAbility: self.baseType.hasEndian,
                                              baseType: self.baseType)

        return fieldDefinition
    }

    /// Create a Field Definition Message From the Key
    ///
    /// - Returns: FieldDefinition
    internal func fieldDefinition() -> FieldDefinition {

        let fieldDefinition = FieldDefinition(fieldDefinitionNumber: UInt8(self.rawValue),
                                              size: self.baseType.dataSize,
                                              endianAbility: self.baseType.hasEndian,
                                              baseType: self.baseType)

        return fieldDefinition
    }
}
