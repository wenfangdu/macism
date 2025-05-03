import Cocoa
import Foundation
import Carbon

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
            if InputSourceManager.waitTimeMs == 0 {
                showTemporaryInputWindow(waitTimeMs: 0)
            } else {
                // Launch TemporaryWindow.app asynchronously with environment variable
                launchTemporaryWindowApp(waitTimeMs: InputSourceManager.waitTimeMs)
            }
        }
    }
}

class InputSourceManager {
    static var inputSources: [InputSource] = []
    static var waitTimeMs: Int = 0
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

// Function to launch TemporaryWindow.app asynchronously with the specified waitTimeMs
func launchTemporaryWindowApp(waitTimeMs: Int) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
    process.arguments = ["TemporaryWindow.app"]
    process.environment = ["MACISM_WAIT_TIME_MS": String(waitTimeMs)]
    do {
        try process.run()
    } catch {
        print("Error launching TemporaryWindow.app: \(error)")
    }
}
