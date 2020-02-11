//
//  Album.swift
//  Albums
//
//  Created by Alexander Supe on 11.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct Album: Codable {
    var artist: String
    var coverArt: [URL]
    var genres: [String]
    var id: String
    var name: String
    var songs: [Song]
    enum Keys: String, CodingKey {
        case artist
        case coverArt
        enum CoverArt: String, CodingKey {
            case url
        }
        case genres
        case id
        case name
        case songs
        
    }
    
    init(artist: String, coverArt: [URL], genres: [String], id: String, name: String, songs: [Song]) {
        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        artist = try container.decode(String.self, forKey: .artist)
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        var covers = [URL]()
        while !coverArtContainer.isAtEnd {
            let coverArtItemContainer = try coverArtContainer.nestedContainer(keyedBy: Keys.CoverArt.self)
            let cover = try coverArtItemContainer.decode(URL.self, forKey: .url)
            covers.append(cover)
        }
        coverArt = covers
        genres = try container.decode([String].self, forKey: .genres)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        songs = try container.decode([Song].self, forKey: .songs)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(artist, forKey: .artist)
        var coverArtContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        for cover in coverArt {
            var coverContainer = coverArtContainer.nestedContainer(keyedBy: Keys.CoverArt.self)
            try coverContainer.encode(cover, forKey: .url)
        }
        try container.encode(genres, forKey: .genres)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(songs, forKey: .songs)
    }
    
}

struct Song: Codable {
    var duration: String
    var id: String
    var name: String
    
    enum Keys: String, CodingKey {
        case duration
        enum Duration: String, CodingKey {
            case duration
        }
        case id
        case name
        enum Name: String, CodingKey {
            case title
        }
    }
    
    init(duration: String, id: String, name: String) {
        self.duration = duration
        self.id = id
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let durationContainer = try container.nestedContainer(keyedBy: Keys.Duration.self, forKey: .duration)
        duration = try durationContainer.decode(String.self, forKey: .duration)
        id = try container.decode(String.self, forKey: .id)
        let nameContainer = try container.nestedContainer(keyedBy: Keys.Name.self, forKey: .name)
        name = try nameContainer.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        var durationContainer = container.nestedContainer(keyedBy: Keys.Duration.self, forKey: .duration)
        try durationContainer.encode(duration, forKey: .duration)
        try container.encode(id, forKey: .id)
        
        var nameContainer = container.nestedContainer(keyedBy: Keys.Name.self, forKey: .name)
        try nameContainer.encode(name, forKey: .title)
    }
}
