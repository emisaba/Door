import UIKit

struct DoorViewModel {
    let door: Door
    let doorsNum: Int
    
    var videoUrl: URL? {
        return URL(string: door.videoUrl)
    }
    
    var imageUrl: URL? {
        return URL(string: door.imageUrl)
    }
    
    init(door: Door, doorsNum: Int) {
        self.door = door
        self.doorsNum = doorsNum
    }
}
