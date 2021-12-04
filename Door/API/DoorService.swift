import UIKit
import FirebaseFirestore

struct VideoInfo {
    let video: URL
    let image: UIImage
}

struct DoorServie {
    
    static func uploadVideo(videoInfo: VideoInfo, completion: @escaping (Error?) -> Void) {
        
        VideoUploader.uploadVideo(videoInfo: videoInfo) { videoUrls in
            let data = ["videoUrl": videoUrls.video, "imageUrl": videoUrls.image,]
            
            COLLECTION_DOOR.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchVideos(completion: @escaping([Door]) -> Void) {
        COLLECTION_DOOR.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let doors = documents.map { Door(data: $0.data()) }
            completion(doors)
        }
    }
}
