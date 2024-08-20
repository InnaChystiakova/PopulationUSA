//
//  PopulationStatItemTests.swift
//  PopulationStatTests
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import XCTest
@testable import PopulationStat

final class NationItemTests: XCTestCase {

    func testDecodingSuccess() throws {
        let json = """
        {
            "ID Nation": "12345",
            "Nation": "United States",
            "ID Year": 2023,
            "Year": "2023",
            "Population": 331002651,
            "Slug Nation": "united-states"
        }
        """.data(using: .utf8)!
        
        let decodedItem = try JSONDecoder().decode(NationItem.self, from: json)
        
        XCTAssertEqual(decodedItem.idNation, "12345")
        XCTAssertEqual(decodedItem.nation, "United States")
        XCTAssertEqual(decodedItem.idYear, 2023)
        XCTAssertEqual(decodedItem.year, "2023")
        XCTAssertEqual(decodedItem.population, 331002651)
        XCTAssertEqual(decodedItem.slugNation, "united-states")
    }

    func testDecodingWithMissingOptionalFields() throws {
        let json = """
        {
            "ID Nation": "12345",
            "ID Year": 2023,
            "Year": "2023",
            "Population": 331002651
        }
        """.data(using: .utf8)!
        
        let decodedItem = try JSONDecoder().decode(NationItem.self, from: json)
        
        XCTAssertEqual(decodedItem.idNation, "12345")
        XCTAssertNil(decodedItem.nation)
        XCTAssertEqual(decodedItem.idYear, 2023)
        XCTAssertEqual(decodedItem.year, "2023")
        XCTAssertEqual(decodedItem.population, 331002651)
        XCTAssertNil(decodedItem.slugNation)
    }

    func testDecodingFailsWhenMandatoryFieldIsMissing() throws {
        let json = """
        {
            "Nation": "United States",
            "ID Year": 2023,
            "Year": "2023",
            "Population": 331002651,
            "Slug Nation": "united-states"
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(NationItem.self, from: json)) { error in
            guard case DecodingError.keyNotFound(let key, _) = error else {
                XCTFail("Expected keyNotFound error but got \(error)")
                return
            }
            XCTAssertEqual(key.stringValue, "ID Nation")
        }
    }
    
    func testDecodingFailsWithInvalidType() throws {
        let json = """
        {
            "ID Nation": 12345,
            "Nation": "United States",
            "ID Year": "2023",
            "Year": "2023",
            "Population": "331002651",
            "Slug Nation": "united-states"
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(NationItem.self, from: json)) { error in
            guard case DecodingError.typeMismatch(let type, _) = error else {
                XCTFail("Expected typeMismatch error but got \(error)")
                return
            }
            XCTAssertTrue(type == String.self || type == Int.self)
        }
    }
    
    func testNationItemEquality() {
        let item1 = NationItem(idNation: "12345", nation: "United States", idYear: 2023, year: "2023", population: 331002651, slugNation: "united-states")
        let item2 = NationItem(idNation: "12345", nation: "United States", idYear: 2023, year: "2023", population: 331002651, slugNation: "united-states")
        
        XCTAssertEqual(item1.idNation, item2.idNation)
        XCTAssertEqual(item1.nation, item2.nation)
        XCTAssertEqual(item1.idYear, item2.idYear)
        XCTAssertEqual(item1.year, item2.year)
        XCTAssertEqual(item1.population, item2.population)
        XCTAssertEqual(item1.slugNation, item2.slugNation)
    }
    
    func testNationItemInequality() {
        let item1 = NationItem(idNation: "12345", nation: "United States", idYear: 2023, year: "2023", population: 331002651, slugNation: "united-states")
        let item2 = NationItem(idNation: "54321", nation: "Canada", idYear: 2022, year: "2022", population: 38005238, slugNation: "canada")
        
        XCTAssertNotEqual(item1, item2)
    }
}


