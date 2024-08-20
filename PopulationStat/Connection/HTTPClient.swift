//
//  HTTPClient.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
