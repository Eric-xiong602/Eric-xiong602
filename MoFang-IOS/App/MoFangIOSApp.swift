import SwiftUI

@main
struct MoFangIOSApp: App {
    // 中文备注：通过 StateObject 持有引擎，避免视图刷新导致 3D 场景被重建。
    @StateObject private var engine = CubeEngine()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(engine)
        }
    }
}
