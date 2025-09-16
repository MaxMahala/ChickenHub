import Foundation

struct FarmChickenSave: Codable {
    let id: UUID
    let imageName: String
    var posX: Double
    var posY: Double
    var scale: Double
}

struct FarmSave: Codable {
    var eggs: Double
    var level: Int
    var progress: Double
    var chickens: [FarmChickenSave]
    var placed: [PlacedThing]
}
