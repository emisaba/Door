import UIKit


struct Door {
    let videoUrl: String
    let imageUrl: String
    
    init(data: [String: Any]) {
        self.videoUrl = data["videoUrl"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
    }
}
