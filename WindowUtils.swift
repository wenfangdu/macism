import Cocoa
import Foundation

// Function to show a temporary window with text input focus
func showTemporaryInputWindow(waitTimeMs: Int = 0) {
    // Ensure NSApplication is initialized for CLI apps
    let app = NSApplication.shared
    app.setActivationPolicy(.accessory) // Allows the app to appear in the Dock and take focus
    // Get the main screen dimensions to position the window in bottom-right
    guard let screen = NSScreen.main else { return }
    let screenRect = screen.visibleFrame

    // Calculate bottom-right position with a larger window size to accommodate text
    let windowWidth: CGFloat = 3 // Increased width for visibility
    let windowHeight: CGFloat = 3 // Increased height for visibility
    let xPos = screenRect.maxX - windowWidth - 8 // Margin from right
    let yPos = screenRect.minY + 8 // Margin from bottom

    // Create the window with titled style
    let window = NSWindow(
        contentRect: NSRect(
            x: xPos, y: yPos, width: windowWidth, height: windowHeight),
        styleMask: [.titled], // or isKeyWindow can't be true
        backing: .buffered,
        defer: false
    )

    // Set window properties for visibility and focus
    window.isOpaque = true
    window.backgroundColor = NSColor.purple // Set background color to purple
    window.titlebarAppearsTransparent = true // Make title bar transparent to show purple background
    window.level = .screenSaver // High window level to ensure visibility
    window.collectionBehavior = [.canJoinAllSpaces, .stationary]

    // Make window visible, bring it to front, and ensure it becomes the key window
    window.makeKeyAndOrderFront(nil)
    // Force the app to activate and take focus, even if other apps are in front
    app.activate(ignoringOtherApps: true)

    // Handle wait time and app termination
    let waitTimeSeconds = TimeInterval(waitTimeMs) / 1000.0
    DispatchQueue.main.asyncAfter(deadline: .now() + waitTimeSeconds) {
        // Terminate the application
        app.terminate(nil)
    }

    // Run the application event loop to handle events
    app.run()
}
