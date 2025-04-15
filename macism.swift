import Carbon
import Cocoa
import Foundation

// Function to show a temporary window with text input focus
func showTemporaryInputWindow() {
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 200, height: 40),
        styleMask: [.borderless],
        backing: .buffered,
        defer: false
    )
    window.level = .screenSaver

    let textField = NSTextField(frame: NSRect(x: 10, y: 8, width: 180, height: 24))
    window.contentView?.addSubview(textField)

    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    textField.becomeFirstResponder()

    DispatchQueue.main.asyncAfter(deadline: .now()) {
        window.close()
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
            return lang == "ko" || lang == "ja" || lang == "vi" || lang.hasPrefix("zh")
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
    static var keyboardOnly: Bool = true

    static func initialize() {
        let inputSourceList = TISCreateInputSourceList(nil, false)
            .takeRetainedValue() as! [TISInputSource]

        inputSources = inputSourceList
            .filter { $0.category == TISInputSource.Category.keyboardInputSource && $0.isSelectable }
            .map { InputSource(tisInputSource: $0) }
    }

    static func getCurrentSource() -> InputSource {
        return InputSource(tisInputSource: TISCopyCurrentKeyboardInputSource().takeRetainedValue())
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
            return Unmanaged<AnyObject>.fromOpaque(cfType).takeUnretainedValue()
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
    let filteredArgs = CommandLine.arguments.filter { $0.lowercased() != "--noKeyboardOnly" }
    InputSourceManager.keyboardOnly = CommandLine.arguments.count == filteredArgs.count
    if let dstSource = InputSourceManager.getInputSource(name: filteredArgs[1]) {
        dstSource.select()
    } else {
        print("Input source \(filteredArgs[1]) does not exist!")
    }
}
