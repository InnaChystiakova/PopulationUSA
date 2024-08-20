//
//  ContentView.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import SwiftUI

struct PopulationStatView: View {
    @StateObject private var viewModel = PopulationViewModel()
    @State private var selectedYear: String?
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    ForEach($viewModel.nationData, id: \.self) { $data in
                        NavigationLink() {
                            PopulationDetailsView(year: data.year ?? "")
                        } label: {
                            VStack(alignment: .leading) {
                                Text(data.year ?? "Default")
                                    .font(.headline)
                                let populationString = String(data.population ?? 0)
                                Text("Population: \(populationString)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .overlay {
                    if (viewModel.fetching) {
                        ProgressView("Fetching data, please wait...")
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .accentColor)
                            )
                    }
                }
                .onAppear {
                    viewModel.fetchNationData()
                }
                .onChange(of: viewModel.nationData) {
                    if selectedYear == nil, let firstYear = viewModel.nationData.first?.year {
                        selectedYear = firstYear
                    }
                }
                .refreshable {
                    viewModel.fetchNationData()
                }
                .alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? "An unknown error occurred"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea())
                .navigationTitle("Population Data")
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.automatic)
                .tint(.clear)
            }
        } detail: {
            if let selectedYear = selectedYear {
                PopulationDetailsView(year: selectedYear)
            } else {
                Text("Please select a year")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PopulationStatView()
    }
}
