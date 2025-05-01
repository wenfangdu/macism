import Carbon
import Cocoa
import Foundation

// Function to show a temporary window with text input focus
func showTemporaryInputWindow() {
    // Get the main screen dimensions to position the window in bottom-right
    guard let screen = NSScreen.main else { return }
    let screenRect = screen.visibleFrame

    // Calculate bottom-right position
    let windowWidth: CGFloat = 150
    let windowHeight: CGFloat = 30
    let xPos = screenRect.maxX - windowWidth - 10 // 10px margin from right
    let yPos = screenRect.minY + 10 // 10px margin from bottom

    let window = NSWindow(
        contentRect: NSRect(
            x: xPos, y: yPos, width: windowWidth, height: windowHeight),
        styleMask: [.borderless],
        backing: .buffered,
        defer: false
    )

    // Set window properties for transparency and focus
    window.isOpaque = false
    window.backgroundColor = NSColor.clear
    window.level = .screenSaver
    window.ignoresMouseEvents = false
    window.collectionBehavior = [.canJoinAllSpaces, .stationary]

    // Create a smaller text field
    let textField = NSTextField(frame: NSRect(
        x: 5, y: 5, width: windowWidth - 10, height: windowHeight - 10))
    textField.isBordered = false
    textField.backgroundColor = NSColor.clear
    textField.textColor = NSColor.clear // Make text invisible
    textField.drawsBackground = false

    window.contentView?.addSubview(textField)

    // Make window visible and ensure it can receive focus
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    textField.becomeFirstResponder()

    // Asynchronously close the window after uSeconds
    DispatchQueue.main.asyncAfter(
        deadline: .now() + .microseconds(InputSourceManager.uSeconds)
    ) {
        window.close()
    }

    // Run the main RunLoop until the window is closed
    if InputSourceManager.uSeconds > 0 {
        let waitTime = TimeInterval(InputSourceManager.uSeconds) / 1_000_000.0
        RunLoop.main.run(until: Date(timeIntervalSinceNow: waitTime))
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
