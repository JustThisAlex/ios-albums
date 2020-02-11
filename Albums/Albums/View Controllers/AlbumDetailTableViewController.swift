//
//  AlbumDetailTableViewController.swift
//  Albums
//
//  Created by Alexander Supe on 11.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
    
    var albumController: AlbumController?
    var album: Album? { didSet { updateViews() } }
    var tempSongs: [Song] = []

    @IBOutlet weak var albumTitle: UITextField!
    @IBOutlet weak var artistName: UITextField!
    @IBOutlet weak var genres: UITextField!
    @IBOutlet weak var artURLs: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            if let album = album {
                albumTitle.text = album.name
                artistName.text = album.artist
                genres.text = album.genres.joined(separator: ", ")
                let urlStrings = album.coverArt.map { $0.absoluteString }
                artURLs.text = urlStrings.joined(separator: ", ")
                navigationItem.title = album.name
                tempSongs = album.songs
            } else {
                navigationItem.title = "New Album"
            }
        }
    }
    
    func addSong(with title: String, duration: String) {
        let song = albumController?.createSong(duration: duration, id: UUID().uuidString, name: title)
        if let song = song {
            tempSongs.append(song)
            tableView.reloadData()
            tableView.cellForRow(at: IndexPath(row: tempSongs.count, section: 0))
        }
    }
    
    

    @IBAction func saveAction(_ sender: Any) {
        let urls = artURLs.text?.components(separatedBy: ", ").compactMap { URL(string: $0) }
        let genres = self.genres.text?.components(separatedBy: ", ").compactMap { $0 }
        if let title = albumTitle.text, let artist = artistName.text {
            if album != nil, let urls = urls, let genres = genres {
                albumController?.update(album: album!, artist: artist, coverArt: urls, genres: genres, id: UUID().uuidString, name: title, songs: tempSongs)
            } else {
                albumController?.createAlbum(artist: artist, coverArt: urls!, genres: genres ?? [], id: UUID().uuidString, name: title, songs: tempSongs)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSongs.count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongTableViewCell
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= tempSongs.count {
            return 100
        } else {
        return 140
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
