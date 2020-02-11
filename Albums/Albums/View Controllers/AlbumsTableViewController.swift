//
//  AlbumsTableViewController.swift
//  Albums
//
//  Created by Alexander Supe on 11.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    var albumController = AlbumController()

    override func viewDidLoad() {
        super.viewDidLoad()
        if albumController != nil {
            albumController.getAlbums { (error) in
                if error == nil { DispatchQueue.main.async { self.tableView.reloadData() }
                }
            } }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumController.albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = albumController.albums[indexPath.row].name
        cell.detailTextLabel?.text = albumController.albums[indexPath.row].artist
        return cell
    }

   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlbumDetailTableViewController
        if let index = tableView.indexPathForSelectedRow, segue.identifier == "ShowSegue" {
            destination.album = albumController.albums[index.row]
            destination.albumController = albumController
        } else if segue.identifier == "AddSegue" {
            destination.albumController = albumController
        }
    }

}
