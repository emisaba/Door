import UIKit
import AVFoundation
import MobileCoreServices
import Hero

class DoorListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(DoorListCell.self, forCellWithReuseIdentifier: identifier)
        cv.backgroundColor = .white
        return cv
    }()
    
    private lazy var pickerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapPickerButton), for: .touchUpInside)
        return button
    }()
    
    private var doors: [Door] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        view.addSubview(pickerButton)
        pickerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingBottom:10,
                            paddingRight: 20)
        pickerButton.setDimensions(height: 60, width: 60)
    }
    
    // MARK: - API
    
    func uploadVideo(videoUrl: URL, picker: UIImagePickerController) {
        
        guard let image = thumnailImageforFileUrl(fileUrl: videoUrl) else { return }
        let videoInfo = VideoInfo(video: videoUrl, image: image)
        
        DoorServie.uploadVideo(videoInfo: videoInfo) { error in
            if let error = error {
                print("failed to uplad video: \(error.localizedDescription)")
                return
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func fetchVideos() {
        DoorServie.fetchVideos { doors in
            self.doors = doors
        }
    }
    
    // MARK: - Action
    
    @objc func didTapPickerButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helper
    
    func thumnailImageforFileUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumnailCGImage)
            
        } catch let error {
            print("failed to generate image: \(error.localizedDescription)")
        }
        
        return nil
    }
}

// MARK: - UICollectionViewDataSource

extension DoorListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DoorListCell
        cell.viewModel = DoorViewModel(door: doors[indexPath.row], doorsNum: indexPath.row)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DoorListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 20) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UIImagePickerControllerDelegate

extension DoorListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        uploadVideo(videoUrl: videoUrl, picker: picker)
    }
}

// MARK: - DoorListCellDelegate

extension DoorListViewController: DoorListCellDelegate {
    
    func didTapDoor(cell: DoorListCell, doorsNum: Int) {
        
        cell.placeImageView.hero.id = "heroImage"
        
        let vc = DoorDetailViewController()
        vc.placeImageView.hero.id = "heroImage"
        vc.isHeroEnabled = true
        vc.modalPresentationStyle = .fullScreen
        vc.viewModel = DoorViewModel(door: self.doors[doorsNum], doorsNum: 0)
        self.present(vc, animated: true, completion: nil)
    }
}
