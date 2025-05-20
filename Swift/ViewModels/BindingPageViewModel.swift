//
//  BindingPageViewModel.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 25.04.2025.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class BindingPageViewModel: ObservableObject {
    @Published var seriesList: [Series] = []
    @Published var moviesList: [Movie] = []
    @Published var user: User? = nil
    @Published var giveRating = false
    @Published var userRating: Double = 0.0
    @Published var writeComment = false
    @Published var commentText = ""
    var apiLink = "https://450b-78-180-75-2.ngrok-free.app"

    init(seriesList: [Series] = [], moviesList: [Movie] = [], user: User? = nil) {
        self.seriesList = seriesList
        self.moviesList = moviesList
        self.user = user
    }
    
    struct Entity: Decodable {
        let id: String
    }

    func reorderEntityList(list: [Any], apiExtension: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "\(apiLink)\(apiExtension)") else {
            // If the URL is invalid, return an empty array.
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let data = data,
                let entities = try? JSONDecoder().decode([Entity].self, from: data) // Decode to array of Entity
            else {
                // If there's an error or no data, return an empty array
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            // Extract the "id" fields
            let orderedIds = entities.map { $0.id }

            // Return the ordered IDs
            DispatchQueue.main.async {
                completion(orderedIds)
            }
        }.resume()
    }
    
    func reorderSeriesList(seriesList: [Series], orderedIds: [String]) -> [Series] {
        // Create a dictionary for fast lookup by ID
        let seriesDictionary = Dictionary(uniqueKeysWithValues: seriesList.map { ($0.id, $0) })

        // Reorder the seriesList based on the orderedIds
        let reorderedList = orderedIds.compactMap { seriesDictionary[$0] }

        return reorderedList
    }
    
    func reorderMoviesList(moviesList: [Movie], orderedIds: [String]) -> [Movie] {
        // Create a dictionary for fast lookup by ID
        let seriesDictionary = Dictionary(uniqueKeysWithValues: moviesList.map { ($0.id, $0) })

        // Reorder the seriesList based on the orderedIds
        let reorderedList = orderedIds.compactMap { seriesDictionary[$0] }

        return reorderedList
    }

    
    func fetchUserData(email: String, completion: @escaping (Bool) -> Void) {
        var db = Firestore.firestore().collection("users")
        
        db.getDocuments() { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                
                if data["email"] as? String ?? "" == email.lowercased() {
                    let username = document.documentID
                    let alreadyWatchedIds = data["alreadyWatchedIds"] as? [String] ?? []
                    let watchLaterIds = data["watchLaterIds"] as? [String] ?? []

                    // Initialize empty arrays
                    var ratings: [Rating] = []
                    var comments: [Comment] = []

                    // Group to wait for both Firestore queries
                    let group = DispatchGroup()

                    // Load Ratings
                    group.enter()
                    Firestore.firestore().collection("ratings")
                        .whereField("userId", isEqualTo: username)
                        .getDocuments { snapshot, error in
                            if let docs = snapshot?.documents {
                                ratings = docs.compactMap { doc in
                                    let data = doc.data()
                                    guard let targetId = data["targetId"] as? String,
                                          let score = data["score"] as? Double,
                                          let date = (data["createdDate"] as? Timestamp)?.dateValue() else {
                                        return nil
                                    }
                                    return Rating(senderId: username, entityName: targetId, rating: score, date: date)
                                }
                            }
                            group.leave()
                        }

                    // Load Comments
                    group.enter()
                    Firestore.firestore().collection("comments")
                        .whereField("userId", isEqualTo: username)
                        .getDocuments { snapshot, error in
                            if let docs = snapshot?.documents {
                                comments = docs.compactMap { doc in
                                    let data = doc.data()
                                    guard let targetId = data["targetId"] as? String,
                                          let content = data["content"] as? String,
                                          let date = (data["createdDate"] as? Timestamp)?.dateValue() else {
                                        return nil
                                    }
                                    return Comment(senderId: username, entityName: targetId, text: content, date: date)
                                }
                            }
                            group.leave()
                        }

                    // After both Firestore reads complete
                    group.notify(queue: .main) {
                        let user = User(id: username,
                                        email: email,
                                        watchLaterIds: watchLaterIds,
                                        alreadyWatchedIds: alreadyWatchedIds,
                                        ratings: ratings,
                                        comments: comments)
                        self.objectWillChange.send()
                        self.user = user
                        completion(true)
                    }
                }
            }
        }
    }
    
    func sendComment(name: String) {
        var comment = Comment(senderId: user!.id, entityName: name, text: commentText, date: Date())
        var type = "series"
        withAnimation(.easeInOut(duration: 0.3)) {
        user!.comments.append(comment)
        
            
            if let seriesIndex = seriesList.firstIndex(where: {$0.name == name} ) {
                seriesList[seriesIndex].comments.append(comment)
            }
            
            if let movieIndex = moviesList.firstIndex(where: {$0.name == name} ) {
                moviesList[movieIndex].comments.append(comment)
                type = "movie"
            }
        }
        
        Firestore.firestore().collection("comments").document(comment.commentId).setData([
            "content": commentText,
            "createdDate": comment.date,
            "targetId": comment.entityName,
            "type": type,
            "userId": comment.senderId
        ])
        
        writeComment = false
        commentText = ""
    }
    
    func removeComment(name: String) {
        self.objectWillChange.send()
        var index = user!.comments.firstIndex(where: {$0.entityName == name} )!
        var comment = user!.comments[index]
        withAnimation(.easeInOut(duration: 0.3)) {
        user!.comments.remove(at: index)
        
            if let seriesIndex = seriesList.firstIndex(where: { $0.name == name }) {
                if let commentIndex = seriesList[seriesIndex].comments.firstIndex(where: { $0.senderId == user!.id }) {
                    seriesList[seriesIndex].comments.remove(at: commentIndex)
                }
            }
            
            if let movieIndex = moviesList.firstIndex(where: { $0.name == name }) {
                if let commentIndex = moviesList[movieIndex].comments.firstIndex(where: { $0.senderId == user!.id }) {
                    moviesList[movieIndex].comments.remove(at: commentIndex)
                }
            }
        }
        
        Firestore.firestore().collection("comments").document(comment.commentId).delete()
    }
    
    func addWatchLater(id: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            user!.watchLaterIds.append(id)
            removeAlreadyWatched(id: id)
        }
        
        Firestore.firestore().collection("users").document(user!.id).setData([
            "watchLaterIds": user!.watchLaterIds
        ], merge: true)
    }
    
    func removeWatchLater(id: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            user!.watchLaterIds.removeAll(where: { $0 == id})
            objectWillChange.send()
        }
        
        Firestore.firestore().collection("users").document(user!.id).setData([
            "watchLaterIds": user!.watchLaterIds
        ], merge: true)
    }
    
    func addAlreadyWatched(id: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            user!.alreadyWatchedIds.append(id)
            removeWatchLater(id: id)
        }
        
        Firestore.firestore().collection("users").document(user!.id).setData([
            "alreadyWatchedIds": user!.alreadyWatchedIds
        ], merge: true)
    }
    
    func removeAlreadyWatched(id: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            user!.alreadyWatchedIds.removeAll(where: { $0 == id})
            objectWillChange.send()
        }
        
        Firestore.firestore().collection("users").document(user!.id).setData([
            "alreadyWatchedIds": user!.alreadyWatchedIds
        ], merge: true)
    }
    
    func getDominantColor(from url: URL, completion: @escaping (UIColor?) -> Void) {
        // Use URLSession for better async handling
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data),
                  let cgImage = image.cgImage else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Reduce image size for faster processing
            let width = 64
            let height = 64
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
            guard let context = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: 8,
                                          bytesPerRow: width * 4,
                                          space: CGColorSpaceCreateDeviceRGB(),
                                          bitmapInfo: bitmapInfo) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            guard let pixelBuffer = context.data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let pixelData = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * 4)
            
            // Use color binning - reduce color space to improve clustering
            var colorBins = [String: (count: Int, color: UIColor)]()
            let binSize = 16 // Color precision - smaller means fewer unique colors
            
            for x in 0..<width {
                for y in 0..<height {
                    let offset = 4 * (y * width + x)
                    let r = pixelData[offset]
                    let g = pixelData[offset + 1]
                    let b = pixelData[offset + 2]
                    let a = pixelData[offset + 3]
                    
                    // Skip transparent pixels
                    guard a > 127 else { continue }
                    
                    // Skip very dark or very light colors that might affect results
                    let brightness = (CGFloat(r) + CGFloat(g) + CGFloat(b)) / (3 * 255)
                    if brightness < 0.1 || brightness > 0.9 {
                        continue
                    }
                    
                    // Bin the colors to group similar shades
                    let rBin = Int(r) / binSize
                    let gBin = Int(g) / binSize
                    let bBin = Int(b) / binSize
                    
                    let colorKey = "\(rBin),\(gBin),\(bBin)"
                    
                    if let existing = colorBins[colorKey] {
                        colorBins[colorKey] = (existing.count + 1, existing.color)
                    } else {
                        let actualColor = UIColor(red: CGFloat(r)/255.0,
                                                  green: CGFloat(g)/255.0,
                                                  blue: CGFloat(b)/255.0,
                                                  alpha: 1.0)
                        colorBins[colorKey] = (1, actualColor)
                    }
                }
            }
            
            // Find the most common color
            let dominantColorInfo = colorBins.max(by: { $0.value.count < $1.value.count })?.value
            
            DispatchQueue.main.async {
                completion(dominantColorInfo?.color)
            }
        }.resume()
    }
    
    func unrate(id: String) {
        self.objectWillChange.send()
        // Check if it's a series
        if let seriesIndex = seriesList.firstIndex(where: { $0.id == id }) {
            let entityName = seriesList[seriesIndex].name
            
            // Remove from user's ratings
            if let userRatingIndex = user!.ratings.firstIndex(where: { $0.entityName == entityName }) {
                let rating = user!.ratings[userRatingIndex]
                self.user!.ratings.remove(at: userRatingIndex)

                // Remove from series' ratings
                if let ratingIndex = seriesList[seriesIndex].ratings.firstIndex(where: { $0.senderId == user!.id }) {
                    seriesList[seriesIndex].ratings.remove(at: ratingIndex)
                }

                // Delete from Firestore
                Firestore.firestore().collection("ratings").document(rating.ratingId).delete()
            }
        }

        // Check if it's a movie
        if let movieIndex = moviesList.firstIndex(where: { $0.id == id }) {
            let entityName = moviesList[movieIndex].name
            
            // Remove from user's ratings
            if let userRatingIndex = user!.ratings.firstIndex(where: { $0.entityName == entityName }) {
                let rating = user!.ratings[userRatingIndex]
                self.user!.ratings.remove(at: userRatingIndex)

                // Remove from movie's ratings
                if let ratingIndex = moviesList[movieIndex].ratings.firstIndex(where: { $0.senderId == user!.id }) {
                    moviesList[movieIndex].ratings.remove(at: ratingIndex)
                }

                // Delete from Firestore
                Firestore.firestore().collection("ratings").document(rating.ratingId).delete()
            }
        }
    }

    
    func rate(id: String) {
        if let seriesIndex = seriesList.firstIndex(where: {$0.id == id} ) {
            var rating = Rating(senderId: self.user!.id, entityName: seriesList[seriesIndex].name, rating: userRating, date: Date())

            seriesList[seriesIndex].ratings.append(rating)
            
            self.user!.ratings.append(rating)
            
            Firestore.firestore().collection("ratings").document(rating.ratingId).setData([
                "createdDate": rating.date,
                "score": rating.rating,
                "targetId": rating.entityName,
                "type": "series",
                "userId": self.user!.id
            ])
        }
        if let movieIndex = moviesList.firstIndex(where: {$0.id == id} ) {
            var rating = Rating(senderId: self.user!.id, entityName: moviesList[movieIndex].name, rating: userRating, date: Date())

            moviesList[movieIndex].ratings.append(rating)
            
            self.user!.ratings.append(rating)
            
            Firestore.firestore().collection("ratings").document(rating.ratingId).setData([
                "createdDate": rating.date,
                "score": rating.rating,
                "targetId": rating.entityName,
                "type": "movie",
                "userId": self.user!.id
            ])
        }
    }
    
    func fetchEverything() {
        fetchComments() { comments in
            self.fetchRatings() { ratings in
                self.fetchSeries(comments: comments, ratings: ratings)
                self.fetchMovies(comments: comments, ratings: ratings)

            }
        }
    }
    
    
    func fetchComments(completion: @escaping ([Comment]) -> Void) {
        var comments: [Comment] = []
        var db = Firestore.firestore().collection("comments")
        db.getDocuments() { snapshot, error in
            guard let snapshot = snapshot, error == nil else { return }
            
            for document in snapshot.documents {
                var data = document.data()
                
                let comment = Comment(
                    senderId: data["userId"] as? String ?? "",
                    entityName: data["targetId"] as? String ?? "",
                    text: data["content"] as? String ?? "",
                    date: (data["createdDate"] as? Timestamp)?.dateValue() ?? Date()
                )
                comments.append(comment)
            }
            completion(comments)
        }
    }
    
    func fetchRatings(completion: @escaping ([Rating]) -> Void) {
        var ratings: [Rating] = []
        var db = Firestore.firestore().collection("ratings")
        db.getDocuments() { snapshot, error in
            guard let snapshot = snapshot, error == nil else { return }
            
            for document in snapshot.documents {
                var data = document.data()
                
                var rating = Rating(senderId: data["userId"] as? String ?? "", entityName: data["targetId"] as? String ?? "", rating: data["score"] as? Double ?? 0, date: (data["createdDate"] as? Timestamp)?.dateValue() ?? Date())

                ratings.append(rating)
            }
            completion(ratings)
        }
    }
    
    func fetchSeries(comments: [Comment], ratings: [Rating]) {
        var series: [Series] = []
        let db = Firestore.firestore().collection("series")
        
        db.getDocuments() { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()

                let name = document.documentID
                let category = data["category"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let director = data["director"] as? String ?? ""
                let imdb = data["imdb"] as? Double ?? 0
                let lastReleaseYear = data["lastReleaseYear"] as? Int ?? 0
                let releaseYear = data["releaseYear"] as? Int ?? 0
                let seasons = data["season"] as? Int ?? 0
                let id = data["id"] as? String ?? ""
                let posterURL = data["posterURL"] as? String ?? ""
                let actors = data["actors"] as? String ?? ""
                let country = data["country"] as? String ?? ""
                let awards = data["awards"] as? String ?? ""
                let imdbCount = data["imdbCount"] as? String ?? ""
                let belongComments = comments.filter( { $0.entityName == name })
                let belongRatings = ratings.filter( { $0.entityName == name })

                
                let newSeries = Series(id: id, name: name, releaseYear: releaseYear, lastReleaseYear: lastReleaseYear, seasons: seasons, category: category, director: director, actors: actors, description: description, country: country, awards: awards, posterURL: posterURL, imdb: imdb, imdbCount: imdbCount, comments: belongComments, ratings: belongRatings)

                series.append(newSeries)
            }
            self.seriesList = series
        }
    }
    
    func fetchMovies(comments: [Comment], ratings: [Rating]) {
        var movies: [Movie] = []
        let db = Firestore.firestore().collection("movies")
        
        db.getDocuments() { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()

                let name = document.documentID
                let category = data["category"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let director = data["director"] as? String ?? ""
                let imdb = data["imdb"] as? Double ?? 0
                let releaseYear = data["releaseYear"] as? Int ?? 0
                let id = data["id"] as? String ?? ""
                let posterURL = data["posterURL"] as? String ?? ""
                let runtime = data["runtime"] as? Int ?? 0
                let actors = data["actors"] as? String ?? ""
                let country = data["country"] as? String ?? ""
                let awards = data["awards"] as? String ?? ""
                let imdbCount = data["imdbCount"] as? String ?? ""
                let belongComments = comments.filter( { $0.entityName == name })
                let belongRatings = ratings.filter( { $0.entityName == name })
                
                let newMovie = Movie(id: id, name: name, releaseYear: releaseYear, runtime: runtime, category: category, director: director, actors: actors, description: description, country: country, awards: awards, posterURL: posterURL, imdb: imdb, imdbCount: imdbCount, comments: belongComments, ratings: belongRatings)

                movies.append(newMovie)
            }
            self.moviesList = movies
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    func entityRow(name: String, releaseYear: Int, lastReleaseYear: Int? = nil, runtime: Int? = nil, seasons: Int? = nil, category: String, imdb: Double, posterURL: String) -> some View {
        HStack {
            if let url = URL(string: posterURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 75)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 75)
                    
                }
            } else {
                Text("problem")
            }
            
            VStack(alignment: .leading, spacing: 10){
                HStack {
                    VStack {
                        Text(name)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.75)
                            .padding(.top, 7)
                            .lineLimit(2)
                        Spacer()

                    }
                    
                    VStack {
                        HStack {
                            if let lastReleaseYear = lastReleaseYear, lastReleaseYear != releaseYear {
                                Text("\(String(releaseYear))-\(String(lastReleaseYear))")
                                    .foregroundStyle(.gray)
                                    .padding(.top, 7)
                                    .padding(.trailing, 20)
                            } else {
                                Text(String(releaseYear))
                                    .foregroundStyle(.gray)
                                    .padding(.top, 7)
                                    .padding(.trailing, 20)
                            }
                            
                        }
                        Spacer()
                        
                    }
                }
                
                if let runtime = runtime{
                    Text("\(runtime) mins")
                        .foregroundStyle(.gray)
                } else {
                    if let seasons = seasons {
                        Text("\(seasons) seasons")
                    }
                }
            }
            .padding(.vertical, 5)
            
            Spacer()
            Text(String(imdb))
                .padding(5)
                .foregroundStyle(Color("textColor"))
                .font(.system(size: 17, weight: .bold))
                .background(.yellow.opacity(0.6))
                .cornerRadius(5)
                .padding(.leading)
        }
        .foregroundStyle(Color("textColor"))
        .padding(.horizontal)
        .background(Color(.systemGray6))
    }
}


struct StarRatingView: View {
    @Binding var rating: Double

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: self.starImageName(for: index))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .foregroundColor(.yellow)
                }
            }
            .frame(width: geometry.size.width, height: 36)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let sectionWidth = geometry.size.width / 5
                        let x = min(max(0, value.location.x), geometry.size.width)
                        let index = Int(x / sectionWidth)
                        let offsetInSection = x - CGFloat(index) * sectionWidth

                        if offsetInSection < sectionWidth / 2 {
                            rating = Double(index) + 0.5
                        } else {
                            rating = Double(index + 1)
                        }

                        rating = max(0.5, min(5.0, rating))
                    }
            )
        }
        .frame(height: 36)
    }

    private func starImageName(for index: Int) -> String {
        if rating >= Double(index + 1) {
            return "star.fill"
        } else if rating >= Double(index) + 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
