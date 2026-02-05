import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var engine: CubeEngine

    private let buttonGrid: [[CubeMove]] = [
        [.R, .L, .U],
        [.D, .F, .B]
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("MoFang-IOS")
                .font(.largeTitle.bold())
            Text("3D 魔方练习")
                .foregroundStyle(.secondary)

            CubeSceneView(scene: engine.scene)
                .frame(height: 420)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                )

            VStack(spacing: 10) {
                ForEach(0..<buttonGrid.count, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(buttonGrid[rowIndex], id: \.self) { move in
                            Button(move.rawValue) {
                                engine.perform(move: move)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(engine.isAnimating)
                        }
                    }
                }
            }

            // 中文备注：底部保留两个高频动作，避免新手在界面中迷失。
            HStack(spacing: 10) {
                Button("随机打乱") {
                    engine.scramble(steps: 18)
                }
                .buttonStyle(.bordered)
                .disabled(engine.isAnimating)

                Button("复位") {
                    engine.reset()
                }
                .buttonStyle(.bordered)
                .disabled(engine.isAnimating)
            }
        }
        .padding()
        .accessibilityLabel("3D 魔方主界面")
    }
}
