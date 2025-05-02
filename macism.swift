import Carbon
import Cocoa
import Foundation

// Function to show a temporary window with text input focus
func showTemporaryInputWindow() {
    // Get the main screen dimensions to position the window in bottom-right
    guard let screen = NSScreen.main else { return }
    let screenRect = screen.visibleFrame

    // Calculate bottom-right position
    let windowWidth: CGFloat = 3 // Minimal width without title bar
    let windowHeight: CGFloat = 3 // Minimal height without title bar
    let xPos = screenRect.maxX - windowWidth - 8 // margin from right
    let yPos = screenRect.minY + 8 // margin from bottom

    let window = NSWindow(
        contentRect: NSRect(
            x: xPos, y: yPos, width: windowWidth, height: windowHeight),
        styleMask: [.borderless], // Removed title bar and buttons
        backing: .buffered,
        defer: false
    )

    // Set window properties for visibility and focus
    window.isOpaque = true
    window.backgroundColor = NSColor.purple
    window.level = .screenSaver
    window.collectionBehavior = [.canJoinAllSpaces, .stationary]

    // Make window visible and ensure it can receive focus
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)

    // Run the main RunLoop until the window is closed
    if InputSourceManager.uSeconds > 0 {
        let waitTime = TimeInterval(InputSourceManager.uSeconds) / 1_000_000.0
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            CFRunLoopStop(CFRunLoopGetMain())
        }
        CFRunLoopRun()
    }
}

class InputSource: Equatable {
    static func == (lhs: InputSource, rhs: InputSource) -> Bool {
        return lhs.id == rhs.id
    }

    let tisInputSource: TISInputSource

    var id: String {
        return tisInputSource.id
    }

    var isCJKV: Bool {
        if let lang = tisInputSource.sourceLanguages.first {
            return lang == "ko" || lang == "ja" || lang == "vi" ||
                   lang.hasPrefix("zh")
        }
        return false
    }

    init(tisInputSource: TISInputSource) {
        self.tisInputSource = tisInputSource
    }

    func select() {
        let currentSource = InputSourceManager.getCurrentSource()
        if currentSource.id == self.id {
            return
        }
        TISSelectInputSource(tisInputSource)
        if self.isCJKV {
            showTemporaryInputWindow()
        }
    }
}

class InputSourceManager {
    static var inputSources: [InputSource] = []
    static var uSeconds: Int = 0
    static var keyboardOnly: Bool = true

    static func initialize() {
        let inputSourceList = TISCreateInputSourceList(nil, false)
            .takeRetainedValue() as! [TISInputSource]

        inputSources = inputSourceList
            .filter { $0.category == TISInputSource.Category.keyboardInputSource &&
                      $0.isSelectable }
            .map { InputSource(tisInputSource: $0) }
    }

    static func getCurrentSource() -> InputSource {
        return InputSource(tisInputSource:
            TISCopyCurrentKeyboardInputSource().takeRetainedValue())
    }

    static func getInputSource(name: String) -> InputSource? {
        return inputSources.first { $0.id == name }
    }
}

extension TISInputSource {
    enum Category {
        static var keyboardInputSource: String {
            return kTISCategoryKeyboardInputSource as String
        }
    }

    private func getProperty(_ key: CFString) -> AnyObject? {
        if let cfType = TISGetInputSourceProperty(self, key) {
            return Unmanaged<AnyObject>.fromOpaque(cfType)
                .takeUnretainedValue()
        }
        return nil
    }

    var id: String {
        return getProperty(kTISPropertyInputSourceID) as! String
    }

    var category: String {
        return getProperty(kTISPropertyInputSourceCategory) as! String
    }

    var isSelectable: Bool {
        return getProperty(kTISPropertyInputSourceIsSelectCapable) as! Bool
    }

    var sourceLanguages: [String] {
        return getProperty(kTISPropertyInputSourceLanguages) as! [String]
    }
}

InputSourceManager.initialize()
if CommandLine.arguments.count == 1 {
    let currentSource = InputSourceManager.getCurrentSource()
    print(currentSource.id)
} else {
    let filteredArgs = CommandLine.arguments.filter(
        { $0.lowercased() != "--noKeyboardOnly".lowercased() })

    InputSourceManager.keyboardOnly =
        CommandLine.arguments.count == filteredArgs.count

    let dstSource = InputSourceManager.getInputSource(
        name: filteredArgs[1]
    )

    if dstSource == nil {
        print("Input source \(filteredArgs[1]) does not exist!")
    }
    if filteredArgs.count == 3 {
        InputSourceManager.uSeconds = Int(filteredArgs[2])!
    }
    dstSource?.select()
}
