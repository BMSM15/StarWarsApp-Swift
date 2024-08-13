//
//  VideoCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit
import AVKit

class VideoCell: UICollectionViewCell {
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let videoContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(videoContainerView)
        videoContainerView.pinTop(to: contentView)
        videoContainerView.pinLeading(to: contentView)
        videoContainerView.pinTrailing(to: contentView)
        videoContainerView.pinBottom(to: contentView)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        playerLayer = AVPlayerLayer()
        videoContainerView.layer.addSublayer(playerLayer)
    }
    
    func configure(with videoUrl: URL) {
        let asset = AVAsset(url: videoUrl)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoContainerView.bounds
        playerLayer.videoGravity = .resizeAspect
        videoContainerView.layer.addSublayer(playerLayer)
        player.isMuted = true
        player.play()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        player.seek(to: .zero)
        player.play()
    }
    
}

