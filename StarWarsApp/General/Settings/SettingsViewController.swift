import UIKit
import AVKit
import WebKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsviewController(_ viewController: SettingsViewController, needsToOpenLink link: Link)
}

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let profileImageView = UIImageView()
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerObserver: NSKeyValueObservation!
    private let videoContainerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var webView: WKWebView!
    weak var delegate: SettingsViewControllerDelegate?
    private let linksStackView = UIStackView()
    
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadSettings()
    }
    
    private func setupViews() {
        title = "Settings"
        
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(profileImageView)
        view.addSubview(videoContainerView)
        view.addSubview(linksStackView)
        
        nameLabel.textAlignment = .left
        ageLabel.textAlignment = .left
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        linksStackView.translatesAutoresizingMaskIntoConstraints = false
        
        videoContainerView.backgroundColor = .black
        linksStackView.axis = .vertical
        linksStackView.spacing = 10
        linksStackView.alignment = .fill
        linksStackView.distribution = .fill
    }
    
    private func setupConstraints() {
        nameLabel.pinBottom(to: profileImageView, constant: 50)
        nameLabel.pinLeading(to: view, constant: 10)
        
        ageLabel.pinTop(to: nameLabel, constant: 30)
        ageLabel.pinLeading(to: view, constant: 10)
        
        profileImageView.pinTopSafeArea(to: view, constant: 10)
        profileImageView.centerHorizontally(to: view)
        profileImageView.widthEqual(to: view, multiplier: 0.25)
        profileImageView.heightEqual(to: view, multiplier: 0.10)
        
        videoContainerView.pinTopSafeArea(to: ageLabel, constant: 35)
        videoContainerView.pinLeading(to: view, constant: 10)
        videoContainerView.pinTrailing(to: view, constant: 10)
        videoContainerView.heightEqualsToWidth(multiplier: 9.0/16.0)
        
        linksStackView.pinTopToBottom(to: videoContainerView, constant: 10)
        linksStackView.pinLeading(to: view, constant: 10)
        linksStackView.pinTrailing(to: view, constant: 10)
        
    }
    
    func loadSettings() {
        activityIndicator.startAnimating()
        self.viewModel.fetchSettings {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        activityIndicator.stopAnimating()
    }
    
    private func updateUI() {
        guard let user = viewModel.user else { return }
        
        nameLabel.text = "Name: \(user.name)"
        
        guard let age = viewModel.calculateAge(from: user.birthdate) else { return }
        ageLabel.text = "Age: \(age)"
        
        if let imageUrl = URL(string: user.imageURL) {
            profileImageView.load(url: imageUrl)
        }
        
        if let videoUrl = URL(string: user.videoURL) {
            let asset = AVAsset(url: videoUrl)
            playerItem = AVPlayerItem(asset: asset)
            observePlayer(playerItem)
            player = AVPlayer(playerItem: playerItem)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoContainerView.bounds
            playerLayer.videoGravity = .resizeAspect
            videoContainerView.layer.addSublayer(playerLayer)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        setupLinkButtons(links: user.links)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    private func observePlayer(_ playerItem: AVPlayerItem) {
        playerObserver = playerItem.observe(\AVPlayerItem.status) { [weak self] (playerItem, _) in
            if playerItem.status == .readyToPlay {
                self?.player.play()
                self?.player.isMuted = true
            }
        }
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        player.seek(to: .zero)
        player.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupLinkButtons(links: [Link]) {
        linksStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, link) in links.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(link.title, for: .normal)
            button.setTitleColor(.white, for:.normal)
            button.backgroundColor = .gray
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.tag = index
            button.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
            linksStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func linkButtonTapped(_ sender: UIButton) {
        guard let user = viewModel.user else { return }
        let link = user.links[sender.tag]
        delegate?.settingsviewController(self, needsToOpenLink: link)
    }
    
    
}

