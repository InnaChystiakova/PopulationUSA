//
//  StateLoader.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

public enum StateFeedResult<PopulationError> {
    case success([StateItem])
    case failure(PopulationError)
}

public protocol StateLoader {
    func load(completion: @escaping (StateFeedResult<PopulationError>) -> Void)
}

public typealias StateResult = StateFeedResult<PopulationError>
