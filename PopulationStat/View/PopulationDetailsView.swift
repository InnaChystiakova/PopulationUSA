//
//  PopulationDetailsView.swift
//  PopulationStat
//
//  Created by Inna Chystiakova on 20/08/2024.
//

import SwiftUI

struct PopulationDetailsView: View {
    @StateObject private var viewModel = PopulationViewModel()
    @Environment(\.dismiss) var dismiss
    let year: String
    
    var body: some View {
        List {
            ForEach($viewModel.stateData, id: \.self) { $data in
                VStack(alignment:.leading) {
                    Text(data.state ?? "Unknown state")
                        .font(.headline)
                    let populationString = String(data.population ?? 0)
                    Text("Population: \(populationString)")
                        .font(.subheadline)
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
            viewModel.fetchStateData(by: year)
        }
        .refreshable {
            viewModel.fetchStateData(by: year)
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
        .navigationTitle("State Data for \(year)")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.left"))")
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.automatic)
        .tint(.white)
    }
}

struct PopulationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PopulationDetailsView(year: "2020")
    }
}
