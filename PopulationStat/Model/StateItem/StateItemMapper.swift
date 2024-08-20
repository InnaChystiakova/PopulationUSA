//
//  StateItemMapper.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

internal final class StateItemMapper {
    private struct StateFeed: Decodable {
        let data: [Item]
        
        var stateFeed: [StateItem] {
            return data.map { $0.item}
        }
    }
    
    private struct Item: Decodable {
        let idState: String
        let state: String?
        let idYear: Int?
        let year: String?
        let population: Int?
        let slugState: String?
        
        private enum CodingKeys: String, CodingKey {
            case idState = "ID State"
            case state = "State"
            case idYear = "ID Year"
            case year = "Year"
            case population = "Population"
            case slugState = "Slug State"
        }
        
        var item: StateItem {
            return StateItem(idState: idState, state: state, idYear: idYear, year: year, population: population, slugState: slugState)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> StateResult {
        guard response.statusCode == OK_200 else {
            return .failure(.invalidData)
        }
        
        do {
            let root = try JSONDecoder().decode(StateFeed.self, from: data)
            return .success(root.stateFeed)
        } catch {
            print("Decoding error: \(error)")
            return .failure(.noData)
        }
    }
}
