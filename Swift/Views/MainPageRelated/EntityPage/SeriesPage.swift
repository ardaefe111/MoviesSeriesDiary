//
//  SeriesPage.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 24.04.2025.
//

import SwiftUI
import UIKit
import CoreGraphics
import FirebaseFirestore

struct SeriesPage: View {
    @ObservedObject var vM: BindingPageViewModel
    @Binding var series: Series
    @State var dominantColor = Color("backColor")
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        
                        ZStack(alignment: .top) {
                            
                            VStack(spacing: 0) {
                                dominantColor
                                    .ignoresSafeArea()
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("backColor"), dominantColor]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .frame(height: 200)
                                .ignoresSafeArea()
                            }
                            .frame(height: 500)
                            .position(x: UIScreen.main.bounds.width / 2, y: 0)
                            
                            VStack {
                                HStack(alignment: .top){
                                    VStack(alignment: .center){
                                        
                                        Text(series.releaseYear == series.lastReleaseYear ? "\(String(series.releaseYear)) • Directed by" : "\(String(series.releaseYear)) - \(String(series.lastReleaseYear)) • Directed by")
                                            .font(.system(size: 14, weight: .light))
                                            .padding(.top, 20)
                                        
                                        Text(series.director)
                                        
                                        Text("\(series.category) • \(series.seasons) Seasons")
                                            .font(.system(size: 14, weight: .light))
                                            .padding(.top, 5)
                                        
                                        Text(series.country.components(separatedBy: ",").first ?? "")
                                            .font(.system(size: 14, weight: .light))
                                            .padding(.top, 3)

                                        if vM.user != nil {
                                            HStack {
                                                if vM.user!.alreadyWatchedIds.contains(series.id) {
                                                    Button {
                                                        vM.removeAlreadyWatched(id: series.id)
                                                    } label: {
                                                        VStack {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 20, weight: .bold))
                                                            
                                                            Text("Watched")
                                                                .font(.system(size: 10))
                                                        }
                                                        .foregroundStyle(.green)
                                                    }
                                                    .padding(.horizontal, 10)
                                                } else {
                                                    Button {
                                                        vM.addAlreadyWatched(id: series.id)
                                                    } label: {
                                                        VStack {
                                                            Image(systemName: "eye")
                                                                .font(.system(size: 20))
                                                            
                                                            Text("Watched")
                                                                .font(.system(size: 10))
                                                        }
                                                    }
                                                    .padding(.horizontal, 10)
                                                }
                                                
                                                if vM.user!.watchLaterIds.contains(series.id) {
                                                    Button {
                                                        vM.removeWatchLater(id: series.id)
                                                    } label: {
                                                        VStack {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 20, weight: .bold))
                                                            
                                                            Text("Later")
                                                                .font(.system(size: 10))
                                                        }
                                                        .foregroundStyle(.green)
                                                    }
                                                    .padding(.horizontal, 10)
                                                } else {
                                                    Button {
                                                        vM.addWatchLater(id: series.id)
                                                    } label: {
                                                        VStack {
                                                            Image(systemName: "clock")
                                                                .font(.system(size: 20))
                                                            
                                                            Text("Later")
                                                                .font(.system(size: 10))
                                                        }
                                                    }
                                                    .padding(.horizontal, 10)
                                                }
                                                
                                                if series.comments.map( {$0.senderId} ).contains(vM.user!.id) {
                                                    Button {
                                                        withAnimation(.easeInOut(duration: 0.3)) {
                                                            proxy.scrollTo(vM.user!.id, anchor: .center)
                                                        }
                                                    } label: {
                                                        VStack {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 20, weight: .bold))
                                                            
                                                            Text("Comment")
                                                                .font(.system(size: 10))
                                                        }
                                                        .foregroundStyle(.green)
                                                    }
                                                } else {
                                                    Button {
                                                        withAnimation(.easeInOut(duration: 0.3)) {
                                                            vM.writeComment = true
                                                        }
                                                    } label: {
                                                        VStack {
                                                            Image(systemName: "text.bubble")
                                                                .font(.system(size: 20))
                                                            
                                                            Text("Comment")
                                                                .font(.system(size: 10))
                                                        }
                                                    }
                                                    .padding(.horizontal, 10)
                                                }
                                            }
                                            .foregroundStyle(Color("textColor"))
                                            .padding(.top, 15)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if let url = URL(string: series.posterURL) {
                                        AsyncImage(url: url) { image in
                                            ZStack {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 130, height: 190) // Set a consistent height
                                                    .clipped()
                                                    .cornerRadius(20)
                                                    .onAppear {
                                                        vM.getDominantColor(from: url) { dominantColor in
                                                            if let color = dominantColor {
                                                                withAnimation(.easeInOut(duration: 0.75)) {
                                                                    self.dominantColor = Color(color)
                                                                }
                                                            }
                                                        }
                                                    }
                                                
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray, lineWidth: 1)
                                                    .frame(width: 130, height: 190)
                                            }
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 50, height: 75)
                                        }
                                    } else {
                                        Text("!")
                                    }
                                }
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .padding(.top)
                                
                                Text(series.description)
                                    .font(.system(size: 15))
                                    .padding(.top, 15)
                                    .padding(.horizontal)
                                    .minimumScaleFactor(0.75)
                                
                                HStack {
                                    Text("ACTORS")
                                        .font(.system(size: 14, weight: .thin))
                                    Spacer()
                                    Color.gray
                                        .frame(height: 1)
                                }
                                .padding(.horizontal)
                                .padding(.top)
                                
                                VStack{
                                    ForEach(series.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }, id: \.self) { actor in
                                        HStack {
                                            Text(actor)
                                                .font(.system(size: 15, weight: .semibold))
                                            
                                            Spacer()
                                        }
                                        .padding(.leading)
                                        .padding(.vertical, 4)
                                    }
                                }
                                
                                HStack {
                                    Text("RATINGS")
                                        .font(.system(size: 14, weight: .thin))
                                    Spacer()
                                    Color.gray
                                        .frame(height: 1)
                                }
                                .padding(.horizontal)
                                .padding(.top)
                                
                                HStack{
                                    Image("imdb")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 65)
                                    
                                    Text("\(series.imdbCount) Votes")
                                        .font(.system(size: 17, weight: .thin))
                                        .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    Text(String(series.imdb))
                                        .padding(5)
                                        .foregroundStyle(Color("textColor"))
                                        .font(.system(size: 17, weight: .bold))
                                        .background(.yellow.opacity(0.6))
                                        .cornerRadius(5)
                                        .padding(.trailing)
                                }
                                .padding(10)
                                .background(.black.opacity(0.4))
                                .cornerRadius(5)
                                .padding(.horizontal)
                                .padding(.top, 4)
                                
                                HStack {
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50)
                                        .padding(.trailing, 15)
                                    
                                    if series.avgRating != 0 {
                                        ForEach(0..<5, id: \.self) { index in
                                            let fullStarRating = Double(index + 1) // 1 to 5
                                            if fullStarRating <= series.avgRating {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                                
                                            } else if fullStarRating - 0.5 <= series.avgRating {
                                                Image(systemName: "star.leadinghalf.filled")
                                                    .foregroundColor(.yellow)
                                            } else {
                                                Image(systemName: "star")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Text(String(format: "%.1f", series.avgRating))
                                            .padding(5)
                                            .foregroundStyle(Color("textColor"))
                                            .font(.system(size: 17, weight: .bold))
                                            .background(.yellow.opacity(0.6))
                                            .cornerRadius(5)
                                            .padding(.trailing)
                                    } else {
                                        Text("Not rated yet!")
                                            .font(.system(size: 17, weight: .thin))
                                            .padding(.leading)
                                        Spacer()
                                        if vM.user != nil {
                                            Button {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    vM.giveRating = true
                                                }
                                            } label: {
                                                VStack {
                                                    Image(systemName: "star")
                                                        .font(.system(size: 20))
                                                    Text("Rate")
                                                        .font(.system(size: 10))
                                                }
                                                .padding(.trailing)
                                            }
                                            .foregroundStyle(.yellow.opacity(0.5))
                                        }
                                    }
                                }
                                .padding(10)
                                .background(.black.opacity(0.4))
                                .cornerRadius(5)
                                .padding(.horizontal)
                                .padding(.top, 4)
                                
                                if series.awards != "N/A" {
                                    HStack {
                                        Text("AWARDS")
                                            .font(.system(size: 14, weight: .thin))
                                        Spacer()
                                        Color.gray
                                            .frame(height: 1)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                    
                                    HStack {
                                        Text(series.awards)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 4)
                                }
                                
                                HStack {
                                    Text("COMMENTS")
                                        .font(.system(size: 14, weight: .thin))
                                    Spacer()
                                    Color.gray
                                        .frame(height: 1)
                                }
                                .padding(.horizontal)
                                .padding(.top)
                                
                                if series.comments.isEmpty {
                                    HStack {
                                        Spacer()
                                        Text("No comments yet!")
                                        Spacer()
                                    }
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.black.opacity(0.5))
                                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                                    )
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                } else {
                                    ForEach(series.comments, id: \.self) { comment in
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(spacing: 12) {
                                                // User info with avatar placeholder
                                                HStack(spacing: 8) {
                                                    Text(comment.senderId)
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color("textColor"))
                                                }
                                                
                                                Spacer()
                                                
                                                Text(vM.formatDate(comment.date))
                                                    .font(.system(size: 12, weight: .light))
                                                    .foregroundColor(Color("textColor").opacity(0.6))
                                            }
                                            
                                            Text(comment.text)
                                                .font(.system(size: 15))
                                                .foregroundColor(Color("textColor"))
                                                .padding(.vertical, 4)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .id(comment.senderId)
                                        .padding(14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.black.opacity(0.5))
                                                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                                        )
                                        .contextMenu {
                                            if vM.user != nil && comment.senderId == vM.user!.id {
                                                Button {
                                                    vM.removeComment(name: series.name)
                                                } label: {
                                                    HStack {
                                                        Text("Remove")
                                                        Image(systemName: "trash")
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(series.name)
                            .font(.system(size: 17, weight: .bold))
                            .minimumScaleFactor(0.75)
                            .lineLimit(1)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if vM.user != nil {
                            if vM.user!.ratings.map( {$0.entityName} ).contains(series.name) {
                                Button {
                                    vM.unrate(id: series.id)
                                } label: {
                                    Image(systemName: "star.fill")
                                }
                                .foregroundStyle(.yellow)
                            } else {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        vM.giveRating = true
                                    }
                                } label: {
                                    Image(systemName: "star")
                                }
                                .foregroundStyle(.yellow)
                            }
                        }
                    }
                }
                .background(Color("backColor"))
            }
            if vM.giveRating {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        vM.giveRating = false
                    }
                
                givingRating()
            }
            
            if vM.writeComment {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        vM.writeComment = false
                    }
                
                writeCommentArea()
            }
        }
    }
    
    func writeCommentArea() -> some View {
        VStack {
            Text("Write a comment")
                .font(.headline)
                .padding(.top, 4)
                .padding(.vertical, 3)
            Spacer()
            HStack {
                TextField("Write a comment...", text: $vM.commentText, axis: .vertical)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.leading)
                    .font(.body)
                    .submitLabel(.send)
                    .onSubmit {
                        vM.sendComment(name: series.name)
                    }
                
                Button {
                    vM.sendComment(name: series.name)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(.black.opacity(0.25))
                        .cornerRadius(.infinity)
                        .padding(.trailing, 5)
                }
                .disabled(vM.commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.width * 0.4)
        .background(Color(.systemGray4))
        .cornerRadius(10)
        .padding(.horizontal)
        .onDisappear() {
            vM.commentText = ""
        }
    }
    
    func givingRating() -> some View {
            VStack(spacing: 16) {
                Text("Give a Rating")
                    .font(.headline)
                    .foregroundColor(.white)
                
                StarRatingView(rating: $vM.userRating)
                
                Text("Selected: \(String(format: "%.1f", vM.userRating))")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top, 8)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        withAnimation {
                            vM.giveRating = false
                        }
                    }
                    .foregroundColor(.white)
                    
                    Button("Confirm") {
                        vM.rate(id: series.id)
                        withAnimation {
                            vM.giveRating = false
                        }
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(Color("accentColor"))
                    .cornerRadius(5)
                }
                .padding(.top, 16)
            }
            .padding(.vertical)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding()
            .padding(.horizontal, 20)
            .onDisappear() {
                vM.userRating = 0.0
            }
        }
}

#Preview {
    var series = Series(
        id: "tt2560140",
        name: "Attack on Titan",
        releaseYear: 2013,
        lastReleaseYear: 2023,
        seasons: 5,
        category: "Animation",
        director: "Emirhan GGGGGokalp",
        actors: "emir gokalp, iclal ok, bilmem",
        description: "After his hometown is destroyed, young Eren Jaeger vows to cleanse the earth of the giant humanoid Titans that have brought humanity to the brink of extinction.",
        country: "Turkey",
        awards: "40 wins & 88 nominations total",
        posterURL: "https://m.media-amazon.com/images/M/MV5BNjY4MDQxZTItM2JjMi00NjM5LTk0MWYtOTBlNTY2YjBiNmFjXkEyXkFqcGc@._V1_SX300.jpg",
        imdb: 9.1,
        imdbCount: "578,814",
        comments: [Comment(senderId: "emirg", entityName: "Attack On Titan", text: "Bu filmdflgödfgdglsdgağ sfgfgğ ladgl pdalgadğgp apdgğ la oğfalğfaflağsd flasğdflğasdfasdğfasdflasdğfladsflsadfğasdlğasdğldğlasflğaslfğsalfldasflğasfasdfasfasdfasfasdfpğ asdlfapğsdflasdğflasdf ğçok güzel!", date: Date()), Comment(senderId: "beko", entityName: "Attack On Titan", text: "Hiç ama hiç ama hiç ama hiç ama hiç beğenmedim ASDFASĞLFADSFĞ ALSDFASDFLASDFĞ ASDFLASDĞFLASDF PASDLĞPFAS", date: Date())],
        ratings: []
    )

    
    SeriesPage(vM: BindingPageViewModel(), series: .constant(series))
}
