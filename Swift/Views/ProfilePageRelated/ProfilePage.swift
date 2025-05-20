//
//  ProfilePage.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 25.04.2025.
//

import SwiftUI

struct ProfilePage: View {
    @ObservedObject var vM: BindingPageViewModel
    @State var selectedType = 0
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                HStack {
                    Spacer()
                    ZStack(alignment: selectedType == 0 ? .leading : .trailing) {
                        Color(.systemGray3)
                            .frame(height: 30)
                            .cornerRadius(20)
                        
                        Color.gray
                            .frame(width: 65, height: 30)
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
                                    .padding(.trailing, 5)
                            }
                            
                            Button {
                                withAnimation(.bouncy(duration: 0.4)) {
                                    selectedType = 1
                                }
                            } label: {
                                Text("Movies")
                                    .frame(width: 60, height: 30)
                                    .foregroundColor(selectedType == 1 ? .white : .black)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                    .frame(width: 120, height: 30)
                    .padding(.vertical, 5)
                    Spacer()
                }
                .background(Color("backColor").opacity(0.75))
                
                TabView(selection: $selectedType) {
                    
                    seriesProfile()
                        .tag(0)
                    
                    moviesProfile()
                        .tag(1)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(vM.user?.id ?? "")
                            .font(.system(size: 17, weight: .bold))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            vM.user = nil
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
    
    func seriesProfile() -> some View {
        ScrollView {
            if let user = vM.user {
                VStack(spacing: 20) {
                    sectionView(title: "Watch Later", items: user.watchLaterIds)
                    sectionView(title: "You Watched", items: user.alreadyWatchedIds)
                    sectionView(title: "You Rated", items: user.ratings.map { $0.entityName })
                    sectionView(title: "Your Commented", items: user.comments.map { $0.entityName })
                }
                .padding()
            }
        }
        .background(Color("backColor"))
    }
    
    func moviesProfile() -> some View {
        ScrollView {
            if let user = vM.user {
                VStack(spacing: 20) {
                    sectionView(title: "Watch Later", items: user.watchLaterIds)
                    sectionView(title: "You Watched", items: user.alreadyWatchedIds)
                    sectionView(title: "You Rated", items: user.ratings.map { $0.entityName})
                    sectionView(title: "Your Comments", items: user.comments.map { $0.entityName })
                }
                .padding()
            }
        }
        .background(Color("backColor"))
    }
     
    @ViewBuilder
    func sectionView(title: String, items: [String]) -> some View {
        let list: [Any] = selectedType == 0
            ? vM.seriesList.filter { items.contains($0.id) || items.contains($0.name) }
            : vM.moviesList.filter { items.contains($0.id) || items.contains($0.name) }

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            .padding(.bottom, 5)

            
            if list.isEmpty {
                Text("No items.")
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.top)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(list.enumerated()), id: \.offset) { index, item in
                            if selectedType == 0, let series = item as? Series {
                                let index = vM.seriesList.firstIndex(where: {$0.id == series.id})
                                NavigationLink(destination: SeriesPage(vM: vM, series: $vM.seriesList[index!])) {
                                    card(url: series.posterURL)
                                }
                            } else if selectedType != 0, let movie = item as? Movie {
                                let index = vM.moviesList.firstIndex(where: {$0.id == movie.id})
                                NavigationLink(destination: MoviePage(vM: vM, movie: $vM.moviesList[index!])) {
                                    card(url: movie.posterURL)
                                }
                            }
                        }
                    }
                 }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
    
    func card(url: String) -> some View {
        if let url = URL(string: url) {
            return AnyView(
                AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 130)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)

                    case .failure(_), .empty:
                        fallbackImage
                    @unknown default:
                        fallbackImage
                    }
                }
            )
        } else {
            return AnyView(fallbackImage)
        }
    }

    private var fallbackImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 130)
            
            Image(systemName: "photo")
                .foregroundColor(.gray)
                .font(.system(size: 30))
        }
    }


}

#Preview {
    var user = User(id: "emirg", email: "emirhangok@icloud.com", watchLaterIds: [], alreadyWatchedIds: [], ratings: [], comments: [])
    ProfilePage(vM: BindingPageViewModel(user: user))
}
