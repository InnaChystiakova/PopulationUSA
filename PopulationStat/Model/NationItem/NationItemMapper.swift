//
//  NationItemMapper.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

internal final class NationItemMapper {
    private struct NationFeed: Decodable {
        let data: [Item]
        
        var nationFeed: [NationItem] {
            return data.map { $0.item }
        }
    }
    
    private struct Item: Decodable {
        let idNation: String
        let nation: String?
        let idYear: Int?
        let year: String?
        let population: Int?
        let slugNation: String?
        
        private enum CodingKeys: String, CodingKey {
            case idNation = "ID Nation"
            case nation = "Nation"
            case idYear = "ID Year"
            case year = "Year"
            case population = "Population"
            case slugNation = "Slug Nation"
        }
        
        var item: NationItem {
            return NationItem(idNation: idNation, nation: nation, idYear: idYear, year: year, population: population, slugNation: slugNation)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> NationResult {
        guard response.statusCode == OK_200 else {
            return .failure(.invalidData)
        }
        
        do {
            let root = try JSONDecoder().decode(NationFeed.self, from: data)
            return .success(root.nationFeed)
        } catch {
            print("Decoding error: \(error)")
            return .failure(.invalidData)
        }
    }
}
