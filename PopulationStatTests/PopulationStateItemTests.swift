//
//  PopulationNationItemTests.swift
//  PopulationStatTests
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import XCTest
@testable import PopulationStat

final class StateItemTests: XCTestCase {
    
    func testStateItemEqualityWithoutID() {
        let item1 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        let item2 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        
        XCTAssertEqual(item1.idState, item2.idState)
        XCTAssertEqual(item1.state, item2.state)
        XCTAssertEqual(item1.idYear, item2.idYear)
        XCTAssertEqual(item1.year, item2.year)
        XCTAssertEqual(item1.population, item2.population)
        XCTAssertEqual(item1.slugState, item2.slugState)
    }
    
    func testStateItemDecoding() {
        let json = """
        {
            "ID State": "67890",
            "State": "California",
            "ID Year": 2023,
            "Year": "2023",
            "Population": 39538223,
            "Slug State": "california"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(StateItem.self, from: json)
            XCTAssertEqual(item.idState, "67890")
            XCTAssertEqual(item.state, "California")
            XCTAssertEqual(item.idYear, 2023)
            XCTAssertEqual(item.year, "2023")
            XCTAssertEqual(item.population, 39538223)
            XCTAssertEqual(item.slugState, "california")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testStateItemProperties() {
        let item = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        
        XCTAssertEqual(item.idState, "67890")
        XCTAssertEqual(item.state, "California")
        XCTAssertEqual(item.idYear, 2023)
        XCTAssertEqual(item.year, "2023")
        XCTAssertEqual(item.population, 39538223)
        XCTAssertEqual(item.slugState, "california")
    }
    
    func testStateItemUniqueID() {
        let item1 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        let item2 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        
        XCTAssertNotEqual(item1.id, item2.id, "Each StateItem should have a unique UUID for its id.")
    }
    
    func testStateItemDecodingWithMissingValues() {
        let json = """
        {
            "ID State": "67890",
            "State": "California",
            "ID Year": 2023
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(StateItem.self, from: json)
            XCTAssertEqual(item.idState, "67890")
            XCTAssertEqual(item.state, "California")
            XCTAssertEqual(item.idYear, 2023)
            XCTAssertNil(item.year)
            XCTAssertNil(item.population)
            XCTAssertNil(item.slugState)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testNationItemEquality() {
        let item1 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        let item2 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")

        XCTAssertEqual(item1.idState, item2.idState)
        XCTAssertEqual(item1.state, item2.state)
        XCTAssertEqual(item1.idYear, item2.idYear)
        XCTAssertEqual(item1.year, item2.year)
        XCTAssertEqual(item1.population, item2.population)
        XCTAssertEqual(item1.slugState, item2.slugState)
    }
    
    func testNationItemInequality() {
        let item1 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")
        let item2 = StateItem(idState: "67890", state: "California", idYear: 2023, year: "2023", population: 39538223, slugState: "california")

        XCTAssertNotEqual(item1, item2)
    }
}
