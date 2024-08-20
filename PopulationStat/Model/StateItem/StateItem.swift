//
//  StateItem.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

public struct StateItem: Equatable, Identifiable {
    public let id = UUID()
    
    public let idState: String
    public let state: String?
    public let idYear: Int?
    public let year: String?
    public let population: Int?
    public let slugState: String?
    
    public init(idState: String, state: String?, idYear: Int?, year: String?, population: Int?, slugState: String?) {
        self.idState = idState
        self.state = state
        self.idYear = idYear
        self.year = year
        self.population = population
        self.slugState = slugState
    }
}

extension StateItem: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case idState = "ID State"
        case state = "State"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugState = "Slug State"
    }
}

extension StateItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(idState)
        hasher.combine(state)
        hasher.combine(idYear)
        hasher.combine(year)
        hasher.combine(population)
        hasher.combine(slugState)
    }
}
