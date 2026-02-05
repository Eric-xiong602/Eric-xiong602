import Foundation
import SceneKit
import SwiftUI

enum CubeMove: String, CaseIterable, Hashable {
    case R, L, U, D, F, B
}

final class CubeEngine: ObservableObject {
    @Published var isAnimating = false

    let scene = SCNScene()

    // 中文备注：用字典保存每个小方块当前的离散坐标（-1/0/1），用于判定哪些块属于某一层。
    private var cubeletPosition: [SCNNode: SIMD3<Int>] = [:]

    private let cubeletSize: CGFloat = 0.92
    private let gap: CGFloat = 0.08

    init() {
        setupScene()
        buildCube()
    }

    func reset() {
        guard !isAnimating else { return }
        clearCube()
        buildCube()
    }

    func scramble(steps: Int) {
        guard !isAnimating else { return }
        var queue = Array((0..<steps).map { _ in CubeMove.allCases.randomElement()! })
        runSequence(&queue)
    }

    func perform(move: CubeMove) {
        guard !isAnimating else { return }
        rotateLayer(move: move)
    }

    private func setupScene() {
        let camera = SCNCamera()
        camera.zFar = 100
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 11)
        scene.rootNode.addChildNode(cameraNode)

        let light = SCNLight()
        light.type = .omni
        light.intensity = 1200
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(6, 8, 12)
        scene.rootNode.addChildNode(lightNode)

        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 350
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)
    }

    private func clearCube() {
        for node in cubeletPosition.keys {
            node.removeFromParentNode()
        }
        cubeletPosition.removeAll()
    }

    private func buildCube() {
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    let cubelet = SCNNode(geometry: createCubeletGeometry(x: x, y: y, z: z))
                    cubelet.position = toScenePosition(SIMD3<Int>(x, y, z))
                    cubeletPosition[cubelet] = SIMD3<Int>(x, y, z)
                    scene.rootNode.addChildNode(cubelet)
                }
            }
        }
    }

    private func createCubeletGeometry(x: Int, y: Int, z: Int) -> SCNBox {
        let box = SCNBox(width: cubeletSize, height: cubeletSize, length: cubeletSize, chamferRadius: 0.05)

        // 中文备注：SceneKit 6 个材质顺序分别是前后左右上下。
        let front = material(color: z == 1 ? .systemRed : .darkGray)
        let back = material(color: z == -1 ? .systemOrange : .darkGray)
        let left = material(color: x == -1 ? .systemBlue : .darkGray)
        let right = material(color: x == 1 ? .systemGreen : .darkGray)
        let top = material(color: y == 1 ? .systemYellow : .darkGray)
        let bottom = material(color: y == -1 ? .systemWhite : .darkGray)

        box.materials = [front, back, left, right, top, bottom]
        return box
    }

    private func material(color: UIColor) -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = color
        m.locksAmbientWithDiffuse = true
        return m
    }

    private func toScenePosition(_ p: SIMD3<Int>) -> SCNVector3 {
        let stride = Float(cubeletSize + gap)
        return SCNVector3(Float(p.x) * stride, Float(p.y) * stride, Float(p.z) * stride)
    }

    private func rotateLayer(move: CubeMove, completion: (() -> Void)? = nil) {
        isAnimating = true

        let selected: [SCNNode]
        let axis: SIMD3<Int>
        let direction: CGFloat

        switch move {
        case .R:
            selected = cubeletPosition.filter { $0.value.x == 1 }.map(\.key)
            axis = SIMD3<Int>(1, 0, 0)
            direction = -.pi / 2
        case .L:
            selected = cubeletPosition.filter { $0.value.x == -1 }.map(\.key)
            axis = SIMD3<Int>(1, 0, 0)
            direction = .pi / 2
        case .U:
            selected = cubeletPosition.filter { $0.value.y == 1 }.map(\.key)
            axis = SIMD3<Int>(0, 1, 0)
            direction = -.pi / 2
        case .D:
            selected = cubeletPosition.filter { $0.value.y == -1 }.map(\.key)
            axis = SIMD3<Int>(0, 1, 0)
            direction = .pi / 2
        case .F:
            selected = cubeletPosition.filter { $0.value.z == 1 }.map(\.key)
            axis = SIMD3<Int>(0, 0, 1)
            direction = -.pi / 2
        case .B:
            selected = cubeletPosition.filter { $0.value.z == -1 }.map(\.key)
            axis = SIMD3<Int>(0, 0, 1)
            direction = .pi / 2
        }

        let pivot = SCNNode()
        scene.rootNode.addChildNode(pivot)

        for node in selected {
            let worldPosition = node.worldPosition
            node.removeFromParentNode()
            node.position = pivot.convertPosition(worldPosition, from: nil)
            pivot.addChildNode(node)
        }

        let action = SCNAction.rotate(by: direction,
                                      around: SCNVector3(axis.x, axis.y, axis.z),
                                      duration: 0.2)
        action.timingMode = .easeInEaseOut

        pivot.runAction(action) { [weak self] in
            guard let self else { return }

            for node in selected {
                let worldPos = node.worldPosition
                node.removeFromParentNode()
                node.position = self.scene.rootNode.convertPosition(worldPos, from: nil)
                self.scene.rootNode.addChildNode(node)

                if let old = self.cubeletPosition[node] {
                    self.cubeletPosition[node] = self.rotatedCoordinate(old, axis: axis, angle: direction)
                }
                if let p = self.cubeletPosition[node] {
                    node.position = self.toScenePosition(p)
                }
            }

            pivot.removeFromParentNode()

            DispatchQueue.main.async {
                self.isAnimating = false
                completion?()
            }
        }
    }

    private func runSequence(_ queue: inout [CubeMove]) {
        guard let next = queue.first else { return }
        queue.removeFirst()

        rotateLayer(move: next) { [weak self] in
            guard let self else { return }
            if queue.isEmpty { return }
            self.runSequence(&queue)
        }
    }

    private func rotatedCoordinate(_ p: SIMD3<Int>, axis: SIMD3<Int>, angle: CGFloat) -> SIMD3<Int> {
        // 中文备注：这里只处理 90 度旋转，使用整数坐标映射避免浮点误差。
        if axis.x != 0 {
            return angle < 0 ? SIMD3<Int>(p.x, p.z, -p.y) : SIMD3<Int>(p.x, -p.z, p.y)
        }
        if axis.y != 0 {
            return angle < 0 ? SIMD3<Int>(-p.z, p.y, p.x) : SIMD3<Int>(p.z, p.y, -p.x)
        }
        return angle < 0 ? SIMD3<Int>(p.y, -p.x, p.z) : SIMD3<Int>(-p.y, p.x, p.z)
    }
}
