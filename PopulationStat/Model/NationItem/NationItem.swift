//
//  NationItem.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

public struct NationItem: Equatable, Identifiable {
    public let id = UUID()

    public let idNation: String
    public let nation: String?
    public let idYear: Int?
    public let year: String?
    public let population: Int?
    public let slugNation: String?
    
    public init(idNation: String, nation: String?, idYear: Int?, year: String?, population: Int?, slugNation: String?) {
        self.idNation = idNation
        self.nation = nation
        self.idYear = idYear
        self.year = year
        self.population = population
        self.slugNation = slugNation
    }
}

extension NationItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case idNation = "ID Nation"
        case nation = "Nation"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugNation = "Slug Nation"
    }
}

extension NationItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(idNation)
        hasher.combine(nation)
        hasher.combine(idYear)
        hasher.combine(year)
        hasher.combine(population)
        hasher.combine(slugNation)
    }
}
