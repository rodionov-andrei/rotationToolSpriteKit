import Foundation

struct Rotation {

    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }

    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    
    // in radians
    var rad: Rotation {
        Rotation(
            x: self.x * (.pi / 180),
            y: self.y * (.pi / 180),
            z: self.z * (.pi / 180)
        )
    }
}

enum RotationAxis {
    case x
    case y
    case z
}
