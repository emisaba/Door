import UIKit
import SDWebImage
import AVFoundation

class DoorDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    public let placeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    public var viewModel: DoorViewModel?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(placeImageView)
        placeImageView.fillSuperview()
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingRight: 20)
        closeButton.setDimensions(height: 60, width: 60)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupDoorUI()
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper
    
    func setupDoorUI() {
        placeImageView.sd_setImage(with: viewModel?.imageUrl, completed: nil)
        playVideo()
    }
    
    func playVideo() {
        guard let videoUrl = viewModel?.videoUrl else { return }
        let player = AVPlayer(url: videoUrl)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = placeImageView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        placeImageView.layer.addSublayer(playerLayer)
        
        player.play()
    }
}
