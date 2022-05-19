//
//  HomeScreenVideoPlayer.swift
//  FigFolders
//
//  Created by Lourdes Dinesh on 5/19/22.
//

import AVKit

class HomeScreenVideoPlayer: AVPlayerViewController {
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.pause()
        self.player?.seek(to: .zero)
    }
}
