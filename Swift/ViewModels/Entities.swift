//
//  Entities.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 2.05.2025.
//

import Foundation

class Series: Hashable {
    var id: String
    var name: String
    var releaseYear: Int
    var lastReleaseYear: Int
    var seasons: Int
    var category: String
    var director: String
    var actors: String
    var description: String
    var country: String
    var awards: String
    var posterURL: String
    var imdb: Double
    var imdbCount: String
    var comments: [Comment]
    var ratings: [Rating]
    var avgRating: Double {
        guard !ratings.isEmpty else { return 0.0 }
        return Double(ratings.map( {$0.rating} ).reduce(0, +)) / Double(ratings.count)
    }
    
    init(id: String, name: String, releaseYear: Int, lastReleaseYear: Int, seasons: Int, category: String, director: String, actors: String, description: String, country: String, awards: String, posterURL: String, imdb: Double, imdbCount: String, comments: [Comment], ratings: [Rating]) {
        self.id = id
        self.name = name
        self.releaseYear = releaseYear
        self.lastReleaseYear = lastReleaseYear
        self.seasons = seasons
        self.category = category
        self.director = director
        self.actors = actors
        self.description = description
        self.country = country
        self.awards = awards
        self.posterURL = posterURL
        self.imdb = imdb
        self.imdbCount = imdbCount
        self.comments = comments
        self.ratings = ratings
    }
    
    static func ==(lhs: Series, rhs: Series) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

class Movie: Hashable {
    var id: String
    var name: String
    var releaseYear: Int
    var runtime: Int
    var category: String
    var director: String
    var actors: String
    var description: String
    var country: String
    var awards: String
    var posterURL: String
    var imdb: Double
    var imdbCount: String
    var comments: [Comment]
    var ratings: [Rating]
    var avgRating: Double {
        guard !ratings.isEmpty else { return 0.0 }
        return Double(ratings.map( {$0.rating} ).reduce(0, +)) / Double(ratings.count)
    }
    
    init(id: String, name: String, releaseYear: Int, runtime: Int, category: String, director: String, actors: String, description: String, country: String, awards: String, posterURL: String, imdb: Double, imdbCount: String, comments: [Comment], ratings: [Rating]) {
        self.id = id
        self.name = name
        self.releaseYear = releaseYear
        self.runtime = runtime
        self.category = category
        self.director = director
        self.actors = actors
        self.description = description
        self.country = country
        self.awards = awards
        self.posterURL = posterURL
        self.imdb = imdb
        self.imdbCount = imdbCount
        self.comments = comments
        self.ratings = ratings
    }

    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

class Rating: Hashable {
    var senderId: String
    var entityName: String
    var rating: Double
    var date: Date
    var ratingId: String {
        "\(senderId) - \(entityName)"
    }
    
    init(senderId: String, entityName: String, rating: Double, date: Date) {
        self.senderId = senderId
        self.entityName = entityName
        self.rating = rating
        self.date = date
    }
    
    static func ==(lhs: Rating, rhs: Rating) -> Bool {
        return lhs.ratingId == rhs.ratingId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ratingId)
    }
}

class Comment: Hashable {
    var senderId: String
    var entityName: String
    var text: String
    var date: Date
    var commentId: String {
        "\(senderId) - \(entityName)"
    }
    
    init(senderId: String, entityName: String, text: String, date: Date) {
        self.senderId = senderId
        self.entityName = entityName
        self.text = text
        self.date = date
    }
    
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.commentId == rhs.commentId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(commentId)
    }
}

class User: Hashable {
    var id: String
    var email: String
    var watchLaterIds: [String]
    var alreadyWatchedIds: [String]
    var ratings: [Rating]
    var comments: [Comment]
    
    init(id: String, email: String, watchLaterIds: [String], alreadyWatchedIds: [String], ratings: [Rating], comments: [Comment]) {
        self.id = id
        self.email = email
        self.watchLaterIds = watchLaterIds
        self.alreadyWatchedIds = alreadyWatchedIds
        self.ratings = ratings
        self.comments = comments
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
