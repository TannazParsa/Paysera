//
//  WebserviceError.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation

enum WebServiceError: Error {
    case invalidUrl
    case invalidData
    case invalidResponse

    var description: String {
        switch self {
        case .invalidUrl:
            return Constants.Error.invalidUrl
        case .invalidData:
            return Constants.Error.invalidData
        case .invalidResponse:
            return Constants.Error.invalidResponse
        }
    }
}
