//
//  PopulationError.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

public enum PopulationError: Swift.Error {
    case connectivity
    case invalidData
    case invalidURL
    case noData
}

extension PopulationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .connectivity:
            return NSLocalizedString("Connectivity issue. Please check your internet connection.", comment: "")
        case .invalidData:
            return NSLocalizedString("Received invalid data. Please try again later.", comment: "")
        case .invalidURL:
            return NSLocalizedString("Invalid URL. Please contact support.", comment: "")
        case .noData:
            return NSLocalizedString("There is no any data by your request", comment: "")
        }
    }
}
