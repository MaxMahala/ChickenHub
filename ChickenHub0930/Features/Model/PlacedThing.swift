import Foundation

struct PlacedThing: Identifiable, Codable, Hashable {
    let id: UUID
    let imageName: String
    var posX: CGFloat
    var posY: CGFloat
    var scale: CGFloat
    var kind: PlaceKind

    init(imageName: String, posX: CGFloat, posY: CGFloat, scale: CGFloat, kind: PlaceKind) {
        self.id = UUID()
        self.imageName = imageName
        self.posX = posX
        self.posY = posY
        self.scale = scale
        self.kind = kind
    }
}
