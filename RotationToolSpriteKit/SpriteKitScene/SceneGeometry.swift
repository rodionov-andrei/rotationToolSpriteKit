import SpriteKit

enum SceneGeometry {
    static func simulateXYRotation(rotation: Rotation) -> SKWarpGeometryGrid {
        let sourcePositions = self.initialWarp
        let destinationPositions = self.applyWarpToNormalizedSquare(
            to: self.initialWarp,
            rotation: rotation
        )

        return SKWarpGeometryGrid(
            columns: 1,
            rows: 1,
            sourcePositions: sourcePositions,
            destinationPositions: destinationPositions
        )
    }


    // MARK: Private

    private static let initialWarp = [
        SIMD2<Float>(0.0, 0.0),
        SIMD2<Float>(1.0, 0.0),
        SIMD2<Float>(0.0, 1.0),
        SIMD2<Float>(1.0, 1.0),
    ]

    private static func applyWarpToNormalizedSquare(
        to normalizedSquare: [SIMD2<Float>],
        rotation: Rotation
    ) -> [SIMD2<Float>] {
        var bottomLeft = normalizedSquare[0]
        var bottomRight = normalizedSquare[1]
        var topLeft = normalizedSquare[2]
        var topRight = normalizedSquare[3]
        
        let xw = Float(sin(rotation.y) * 0.4)
        let xh = Float(sin(rotation.y) * 0.5)

        if rotation.y > 0 {
            topRight.x += xw
            bottomRight.x += xw
            topRight.y += xh
            bottomRight.y -= xh
        } else if rotation.y < 0 {
            topLeft.x += xw
            bottomLeft.x += xw
            topLeft.y -= xh
            bottomLeft.y += xh
        }

        let yw = Float(sin(rotation.x) * 0.5)
        let yh = Float(sin(rotation.x) * 0.4)

        if rotation.x > 0 {
            topLeft.x -= yw
            topRight.x += yw
            topLeft.y += yh
            topRight.y += yh
        } else {
            bottomLeft.x += yw
            bottomRight.x -= yw
            bottomLeft.y += yh
            bottomRight.y += yh
        }

        return [bottomLeft, bottomRight, topLeft, topRight]
    }
    
    static func scaleAspectFit(size: CGSize, to targetSize: CGSize) -> CGSize {
        let ratio = size.width / size.height
        var b = targetSize.height
        var a = ratio * b
        if a > targetSize.width {
            a = targetSize.width
            b = a / ratio
        }
        return CGSize(width: a, height: b)
    }
}
