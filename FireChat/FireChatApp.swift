import SwiftUI
import FirebaseCore

@main
struct FireChatApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            TranslateMeView()
        }
    }
}
