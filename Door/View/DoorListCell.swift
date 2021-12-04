import UIKit
import SDWebImage
import AVFoundation
import Lottie

protocol DoorListCellDelegate {
    func didTapDoor(cell: DoorListCell, doorsNum: Int)
}

class DoorListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: DoorListCellDelegate?
    
    public var viewModel: DoorViewModel? {
        didSet { configureViewModel() }
    }
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Place"
        label.textAlignment = .center
        label.backgroundColor = .systemPink
        return label
    }()
    
    public let placeImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemYellow
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var doorView: UIView = {
        let view = UIView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDoorView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private let lottieAnimation = AnimationView()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(placeLabel)
        placeLabel.anchor(top: topAnchor)
        placeLabel.setDimensions(height: 20, width: frame.width / 2)
        placeLabel.centerX(inView: self)
        
        addSubview(placeImageView)
        placeImageView.anchor(top: placeLabel.bottomAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupAnimationView()
    }
    
    // MARK: - Actions
    
    @objc func didTapDoorView() {
        lottieAnimation.play { _ in
            guard let doorsNum = self.viewModel?.doorsNum else { return }
            self.delegate?.didTapDoor(cell: self, doorsNum: doorsNum)
            self.detectPlayerComplete()
        }
    }
    
    @objc func fileComplete() {
        
    }
    
    // MARK: - Helper
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        placeImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
    
    func setupAnimationView() {
        lottieAnimation.isUserInteractionEnabled = true
        lottieAnimation.animation = Animation.named("door")
        lottieAnimation.frame = placeImageView.bounds
        lottieAnimation.contentMode = .scaleAspectFill
        lottieAnimation.loopMode = .playOnce
        placeImageView.addSubview(lottieAnimation)
        
        placeImageView.addSubview(doorView)
        doorView.fillSuperview()
    }
    
    func detectPlayerComplete() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fileComplete),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
}
