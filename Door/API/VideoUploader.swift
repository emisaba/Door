import UIKit
import FirebaseStorage

struct VideoUrls {
    let video: String
    let image: String
}

struct VideoUploader {
    
    static func uploadVideo(videoInfo: VideoInfo, completion: @escaping (VideoUrls) -> Void) {
        let fileName = UUID().uuidString + ".mov"
        let ref = Storage.storage().reference(withPath: "video/\(fileName)")

        do {
            let data = try Data(contentsOf: videoInfo.video)
            
            ref.putData(data, metadata: nil) { _, error in
                if let error = error {
                    print("failed to upload video: \(error.localizedDescription)")
                    return
                }
                
                ref.downloadURL { url, error in
                    guard let videoUrl = url?.absoluteString else { return }
                    
                    uploadVideoImage(image: videoInfo.image) { imageUrl in
                        completion(VideoUrls(video: videoUrl, image: imageUrl))
                    }
                }
            }
        } catch  {
            print("failed to convert")
        }
    }
    
    static func uploadVideoImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "image/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("failed to upload image: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, _ in
                guard let urlString = url?.absoluteString else { return }
                completion(urlString)
            }
        }
    }
}
