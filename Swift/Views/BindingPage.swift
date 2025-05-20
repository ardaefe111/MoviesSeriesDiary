//
//  BindingPage.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 25.04.2025.
//

import SwiftUI
import FirebaseFirestore

struct BindingPage: View {
    @ObservedObject var vM: BindingPageViewModel
    
    var notReady: Bool {
        vM.seriesList.isEmpty || vM.moviesList.isEmpty
    }
    
    var body: some View {
        TabView {
            tabItem(
                view: MainPage(vM: vM),
                icon: "house",
                label: "Home",
                tag: 0
            )
            
            tabItem(
                view: SearchPage(vM: vM),
                icon: "magnifyingglass",
                label: "Search",
                tag: 1
            )
            
            tabItem(
                view: profileTab,
                icon: "person",
                label: "Profile",
                tag: 2 
            )
        }
        .navigationTitle("")
    }
    
    @ViewBuilder
    var profileTab: some View {
        Group {
            if let user = vM.user {
                ProfilePage(vM: vM)
            } else {
                LoginPage(firstPage: false, vM: vM)
            }
        }
    }
     
    @ViewBuilder
    func tabItem<Content: View>(view: Content, icon: String, label: String, tag: Int) -> some View {
        Group {
            if notReady {
                loading()
            } else {
                view
            }
        }
        .tabItem {
            Image(systemName: icon)
            Text(label) 
        }
        .tag(tag)
    }

    func loading() -> some View {
        ProgressView()
    }
} 

#Preview {
    BindingPage(vM: BindingPageViewModel())
}
