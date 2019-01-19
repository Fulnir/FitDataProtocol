//
//  WorkoutStepMessageKeys.swift
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
extension WorkoutStepMessage: FitMessageKeys {
    /// CodingKeys for FIT Message Type
    public typealias FitCodingKeys = MessageKeys

    /// FIT Message Keys
    public enum MessageKeys: Int, CodingKey, CaseIterable {
        /// Message Index
        case messageIndex           = 254

        /// Step Name
        case stepName               = 0
        /// Duration Type
        case durationType           = 1
        /// Duration Value
        case durationValue          = 2
        /// Target Type
        case targetType             = 3
        /// Target Value
        case targetValue            = 4
        /// Custom Target Value Low
        case customTargetValueLow   = 5
        /// Custom Target Value Hight
        case customTargetValueHigh  = 6
        /// Intensity
        case intensity              = 7
        /// Notes
        case notes                  = 8
        /// Equipment
        case equipment              = 9
        /// Categroy
        case category               = 10
    }
}

public extension WorkoutStepMessage.FitCodingKeys {

    /// Key Base Type
    public var baseType: BaseType {
        switch self {
        case .messageIndex:
            return .uint16

        case .stepName:
            return .string //16
        case .durationType:
            return .enumtype
        case .durationValue:
            return .uint32
        case .targetType:
            return .enumtype
        case .targetValue:
            return .uint32
        case .customTargetValueLow:
            return .uint32
        case .customTargetValueHigh:
            return .uint32
        case .intensity:
            return .enumtype
        case .notes:
            return .string  //50
        case .equipment:
            return .enumtype
        case .category:
            return .uint16
        }
    }
}

internal extension WorkoutStepMessage.FitCodingKeys {

    /// Key Base Type Resolution
    var resolution: Resolution {
        switch self {
        case .messageIndex:
            return Resolution(scale: 1.0, offset: 0.0)

        case .stepName:
            return Resolution(scale: 1.0, offset: 0.0)
        case .durationType:
            return Resolution(scale: 1.0, offset: 0.0)
        case .durationValue:
            return Resolution(scale: 1.0, offset: 0.0)
        case .targetType:
            return Resolution(scale: 1.0, offset: 0.0)
        case .targetValue:
            return Resolution(scale: 1.0, offset: 0.0)
        case .customTargetValueLow:
            return Resolution(scale: 1.0, offset: 0.0)
        case .customTargetValueHigh:
            return Resolution(scale: 1.0, offset: 0.0)
        case .intensity:
            return Resolution(scale: 1.0, offset: 0.0)
        case .notes:
            return Resolution(scale: 1.0, offset: 0.0)
        case .equipment:
            return Resolution(scale: 1.0, offset: 0.0)
        case .category:
            return Resolution(scale: 1.0, offset: 0.0)
        }
    }
}

// Encoding
internal extension WorkoutStepMessage.FitCodingKeys {

    internal func encodeKeyed(value: WorkoutStepDurationType) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: WorkoutStepTargetType) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: ExerciseCategory) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: Intensity) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }

    internal func encodeKeyed(value: WorkoutEquipment) throws -> Data {
        return try self.baseType.encodedResolution(value: value.rawValue, resolution: self.resolution)
    }
}

// Encoding
extension WorkoutStepMessage.FitCodingKeys: EncodeKeyed {

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

internal extension WorkoutStepMessage.FitCodingKeys {

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
