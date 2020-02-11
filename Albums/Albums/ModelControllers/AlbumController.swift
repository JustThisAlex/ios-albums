//
//  AlbumController.swift
//  Albums
//
//  Created by Alexander Supe on 11.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

class AlbumController {
    
    
    var albums = [Album]()
    let baseURL = URL(string: "")!
    
    func getAlbums(completion: @escaping (Error?) -> () = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error { NSLog("\(error)"); completion(error); return }
            guard let data = data else { NSLog("DataTask error nodata"); completion(NSError()); return }
            
            do {
                self.albums = Array(try JSONDecoder().decode([String: Album].self, from: data).values)
                completion(nil)
            }
            catch {
                completion(error)
                NSLog("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func put(album: Album) {
        var data: Data?
        do {
            data = try JSONEncoder().encode(album)
        }
        catch {
            NSLog("Encoding error: \(error)")
        }
        guard let saveData = data else { NSLog("Encoding error: Nodata"); return }
        var request = URLRequest(url: baseURL.appendingPathComponent(album.id).appendingPathExtension("json"))
        request.httpMethod = "PUT"
        request.httpBody = saveData
        URLSession.shared.dataTask(with: request) {_,_,error in
            if let error = error { NSLog("\(error)") }
        }.resume()
    }
    
    func createAlbum(artist: String, coverArt: [URL], genres: [String], id: String, name: String, songs: [Song]) {
        let album = Album(artist: artist, coverArt: coverArt, genres: genres, id: id, name: name, songs: songs)
        albums.append(album)
        put(album: album)
    }
    
    func createSong(duration: String, id: String, name: String) -> Song {
        return Song(duration: duration, id: id, name: name)
    }
    
    func update(album: Album, artist: String?, coverArt: [URL]?, genres: [String]?, id: String?, name: String?, songs: [Song]?) {
        var updatedAlbum = album
        updatedAlbum.artist = artist ?? album.artist
        updatedAlbum.coverArt = coverArt ?? album.coverArt
        updatedAlbum.genres = genres ?? album.genres
        updatedAlbum.id = id ?? album.id
        updatedAlbum.name = name ?? album.name
        updatedAlbum.songs = songs ?? album.songs
        put(album: updatedAlbum)
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Testing
    func testCreation() {
        let album = testDecodiongExampleAlbum()
        guard album != nil else { return }
        createAlbum(artist: album!.artist, coverArt: album!.coverArt, genres: album!.genres, id: album!.id, name: album!.name, songs: album!.songs)
        print("Test complete")
    }
    
    
    
    func testDecodiongExampleAlbum() -> Album? {
        var result: Album?
        do {
            result = try JSONDecoder().decode(Album.self, from: Data(contentsOf: Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")!))
        }
        catch {
            NSLog(String(describing: error))
        }
        print(result ?? "")
        return result
    }
    
    func testEncodingExampleAlbum() {
        var result: Album?
        do {
            result = try JSONDecoder().decode(Album.self, from: Data(contentsOf: Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")!))
        }
        catch {
            NSLog(String(describing: error))
        }
        
        do {
            let json = try JSONEncoder().encode(result)
            print(json)
        }
        catch {
            NSLog("\(error)")
        }
    }
    
}
