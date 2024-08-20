//
//  PopulationLoaderTests.swift
//  PopulationStatTests
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import XCTest
@testable import PopulationStat

final class PopulationLoaderTests: XCTestCase {
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: URLSessionHTTPClient {
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        override func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: PopulationLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PopulationLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expectNation(_ sut: PopulationLoader, toCompleteWithResult expectedResult: PopulationLoaderResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.fetchNationData() { receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.nationResult(.success(receivedItems)), .nationResult(.success(expectedItems))):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.nationResult(.failure(receivedError)), .nationResult(.failure(expectedError))):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult), file: file, line: line")
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Tests
    
    func testInitDoesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func testFetchNationDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.fetchNationData { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func testFetchStateDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.fetchStateData { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func testErrorOnNationFetching() {
        let (sut, client) = makeSUT()
        
        expectNation(sut, toCompleteWithResult: .nationResult(.failure(.connectivity))) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func testErrorOn200HTTPResponseWithInvalidNationJSON() {
        let (sut, client) = makeSUT()
        
        expectNation(sut, toCompleteWithResult: .nationResult(.failure(.invalidData))) {
            let invalidJSON = Data("invald json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func testNoItemsOn200HTTPResponseWithEmptyNationJSON() {
        let (sut, client) = makeSUT()
        
        expectNation(sut, toCompleteWithResult: .nationResult(.success([]))) {
            let emptyListJSON = """
            {"data": [] }
            """.data(using: .utf8)!
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func testLoadDoesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        let emptyListJSON = """
        {"data": [] }
        """.data(using: .utf8)!
        
        var sut: PopulationLoader? = PopulationLoader(url: url, client: client)
        
        var capturedResults = [PopulationLoaderResult]()
        sut?.fetchNationData() { [weak sut] result in
            guard sut != nil else { return }
            capturedResults.append(result)
        }
        
        sut = nil
        client.complete(withStatusCode: 200, data: emptyListJSON)
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
 
}
