//
//  PopulationViewModel.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import Foundation

class PopulationViewModel: ObservableObject {
    @Published var nationData: [NationItem] = []
    @Published var stateData: [StateItem] = []
    @Published var showErrorAlert: Bool = false
    @Published var fetching = true
    
    var errorMessage: String? = nil
    
    private let baseURL = "https://datausa.io/api/data"
    
    func fetchNationData() {
        let urlString = "\(baseURL)?drilldowns=Nation&measures=Population"
        guard let url = URL(string: urlString) else {
            self.finishWithError(error: .invalidURL)
            return
        }
        
        let populationLoader = PopulationLoader.init(url: url, client: URLSessionHTTPClient(session: .shared))
        populationLoader.fetchNationData() { [weak self] result in
            DispatchQueue.main.async {
                self?.fetching = true
                self?.finishWithResult(result: result)
            }
        }
    }
    
    func fetchStateData(by year: String) {
        let urlString = "\(baseURL)?drilldowns=State&measures=Population&year=\(year)"
        guard let url = URL(string: urlString) else {
            self.finishWithError(error: .invalidURL)
            return
        }
        
        let populationLoader = PopulationLoader.init(url: url, client: URLSessionHTTPClient(session: .shared))
        populationLoader.fetchStateData() { [weak self] result in
            DispatchQueue.main.async {
                self?.fetching = true
                self?.finishWithResult(result: result)
            }
        }
    }
    
    // MARK: - Inner methods
    
    private func finishWithResult(result: PopulationLoaderResult) {
        switch result {
        case .nationResult(let res):
            switch res {
            case .success(let data):
                self.nationData = data
                self.fetching = false
            case .failure(let error):
                self.finishWithError(error: error)
            }
        case .stateResult(let res):
            switch res {
            case .success(let data):
                self.stateData = data
                self.fetching = false
            case .failure(let error):
                self.finishWithError(error: error)
            }
        }
    }

    private func finishWithError(error: PopulationError) {
        self.errorMessage = error.errorDescription
        self.showErrorAlert = true
        self.fetching = false
    }
}
