//
//  SongTableViewCell.swift
//  Albums
//
//  Created by Alexander Supe on 11.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    var song: Song?
    var delegate: SongTableViewCellDelegate?
    @IBOutlet weak var songField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        songField.text = ""
        durationField.text = ""
        addSongButton.isHidden = false
    }
    
    func updateViews() {
        if let song = song {
            songField.text = song.name
            durationField.text = song.duration
            addSongButton.isHidden = true
        }
    }

    @IBAction func addSongButtonTapped(_ sender: Any) {
        guard let song = songField.text, let duration = durationField.text else { return }
        delegate?.addSong(with: song, duration: duration)
    }
    
    
    
    
}

protocol SongTableViewCellDelegate {
    func addSong(with title: String, duration: String)
}
