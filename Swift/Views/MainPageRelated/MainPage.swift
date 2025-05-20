//
//  ContentView.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 12.04.2025.
//

import SwiftUI
import SwiftSoup
import FirebaseFirestore

struct MainPage: View {
    @ObservedObject var vM: BindingPageViewModel
    @State var selectedType = 0
    @State var sortTableOpened = false

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedType) {
                    
                    ZStack(alignment: .top) {
                        
                        ScrollView {
                            Color.clear
                                .frame(height: 55) // height of sort or filter
                            LazyVStack {
                                ForEach(vM.seriesList, id: \.self) { series in
                                    if let index = vM.seriesList.firstIndex(where: { $0.id == series.id }) {
                                        NavigationLink(destination: SeriesPage(vM: vM, series: $vM.seriesList[index])) {
                                            vM.entityRow(
                                                name: series.name,
                                                releaseYear: series.releaseYear,
                                                lastReleaseYear: series.lastReleaseYear,
                                                seasons: series.seasons,
                                                category: series.category,
                                                imdb: series.imdb,
                                                posterURL: series.posterURL
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 0) {
                            sortButton()
                            
                            Spacer()
                            
                        }
                    }
                    .tag(0)
                    
                    ZStack(alignment: .top) {
                        
                        ScrollView {
                            Color.clear
                                .frame(height: 55) // height of sort or filter
                            LazyVStack {
                                ForEach(vM.moviesList, id:\.self) { movie in
                                    if let index = vM.moviesList.firstIndex(where: { $0.id == movie.id }) {
                                        NavigationLink(destination: MoviePage(vM: vM, movie: $vM.moviesList[index])) {
                                            vM.entityRow(
                                                name: movie.name,
                                                releaseYear: movie.releaseYear,
                                                runtime: movie.runtime,
                                                category: movie.category,
                                                imdb: movie.imdb,
                                                posterURL: movie.posterURL
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 0) {
                            sortButton()
                            
                            Spacer()
                            
                        }
                    }
                    .tag(1)
                }
                if sortTableOpened {
                    Color.black.opacity(0.75)
                        .onTapGesture {
                            sortTableOpened = false
                        }
                    sortTable()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    
                    ZStack(alignment: selectedType == 0 ? .leading : .trailing) {
                        Color(.systemGray3)
                            .frame(height: 30)
                            .cornerRadius(20)
                        
                        Color.gray
                            .frame(width: 75, height: 30)
                            .cornerRadius(20)
                            .animation(.bouncy(duration: 0.4), value: selectedType)
                        
                        HStack(spacing: 0) {
                            Button {
                                withAnimation(.bouncy(duration: 0.4)) {
                                    selectedType = 0
                                }
                            } label: {
                                Text("Series")
                                    .frame(width: 60, height: 30)
                                    .foregroundColor(selectedType == 0 ? .white : .black)
                            }
                            
                            Button {
                                withAnimation(.bouncy(duration: 0.4)) {
                                    selectedType = 1
                                }
                            } label: {
                                Text("Movies")
                                    .frame(width: 60, height: 30)
                                    .foregroundColor(selectedType == 1 ? .white : .black)
                            }
                        }
                        if sortTableOpened {
                            Color.black.opacity(0.75)
                                .onTapGesture {
                                    sortTableOpened = false
                                }
                        }
                    }
                    .frame(width: 150, height: 30)
                    .disabled(sortTableOpened)
                }
            }
        }
    }
    
    func sortTable() -> some View {
        VStack(spacing: 20) {
            
            
            // Button Table to reorder
            ScrollView {
                if selectedType == 0 {
                    sortButton(label: "IMDB Descending", apiExtension: "/api/series/get/sorted/imdb-desc")
                    sortButton(label: "IMDB Ascending", apiExtension: "/api/series/get/sorted/imdb-asc")
                    sortButton(label: "IMDB Count Descending", apiExtension: "/api/series/get/sorted/imdbcount-desc")
                    sortButton(label: "IMDB Count Ascending", apiExtension: "/api/series/get/sorted/imdbcount-asc")
                    sortButton(label: "Release Year Descending", apiExtension: "/api/series/get/sorted/releaseyear-desc")
                    sortButton(label: "Release Year Ascending", apiExtension: "/api/series/get/sorted/releaseyear-asc")
                    sortButton(label: "Season Number Descending", apiExtension: "/api/series/get/sorted/season-desc")
                    sortButton(label: "Season Number Ascending", apiExtension: "/api/series/get/sorted/season-asc")
                    
                } else {
                    sortButton(label: "IMDB Descending", apiExtension: "/api/movies/get/sorted/imdb-desc")
                    sortButton(label: "IMDB Ascending", apiExtension: "/api/movies/get/sorted/imdb-asc")
                    sortButton(label: "IMDB Count Descending", apiExtension: "/api/movies/get/sorted/imdb-count-desc")
                    sortButton(label: "IMDB Count Ascending", apiExtension: "/api/movies/get/sorted/imdb-count-asc")
                    sortButton(label: "Release Year Descending", apiExtension: "/api/movies/get/sorted/releaseyear-desc")
                    sortButton(label: "Release Year Ascending", apiExtension: "/api/movies/get/sorted/releaseyear-asc")
                    sortButton(label: "Runtime Descending", apiExtension: "/api/movies/get/sorted/runtime-desc")
                    sortButton(label: "Runtime Ascending", apiExtension: "/api/movies/get/sorted/runtime-asc")
                    
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(height: UIScreen.main.bounds.height * 0.7)
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
        .shadow(radius: 10)
        
    }
    
    func sortButton(label: String, apiExtension: String) -> some View {
         Button(action: {
             sortTableOpened = false

             if selectedType == 0 {
                 vM.reorderEntityList(list: vM.seriesList, apiExtension: apiExtension) { orderedIds in
                     let reorderedSeries = vM.reorderSeriesList(seriesList: vM.seriesList, orderedIds: orderedIds)
                     
                     DispatchQueue.main.async {
                         vM.seriesList = reorderedSeries
                     }
                 }
             } else {
                 vM.reorderEntityList(list: vM.moviesList, apiExtension: apiExtension) { orderedIds in
                     let reorderedSeries = vM.reorderMoviesList(moviesList: vM.moviesList, orderedIds: orderedIds)
                     
                     DispatchQueue.main.async {
                         vM.moviesList = reorderedSeries
                     }
                 }
             }
         }) {
             Text(label)
                 .font(.subheadline)
                 .fontWeight(.medium)
                 .padding()
                 .foregroundColor(.white)
                 .background(Color.blue)
                 .cornerRadius(10)
                 .shadow(radius: 3)
         }
         .padding(.horizontal, 5)
         .padding(.vertical, 3)
     }

    
    func sortButton() -> some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    sortTableOpened = true
                }
            } label: {
                Spacer()
                Text("Sort")
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: 50)
        }
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .foregroundStyle(Color("textColor"))
        .background(Color("accentColor"))
    }
}


#Preview {
    MainPage(vM: BindingPageViewModel(seriesList: [Series(id: "", name: "r3", releaseYear: 0, lastReleaseYear: 0, seasons: 0, category: "", director: "", actors: "", description: "", country: "", awards: "", posterURL: "", imdb: 0, imdbCount: "", comments: [], ratings: [])]))
}
