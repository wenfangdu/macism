
import CoreGraphics
import Foundation

func simulateJapaneseKanaKeyPress(waitTimeMs: Int) {
    // Key code for japanese_kana on JIS keyboard
    let keyCode: CGKeyCode = 104

    // Create a keyboard event source
    guard let eventSource = CGEventSource(stateID: .hidSystemState) else {
        print("Failed to create event source")
        return
    }

    // Simulate key down event
    guard let keyDownEvent = CGEvent(
        keyboardEventSource: eventSource,
        virtualKey: keyCode,
        keyDown: true
    ) else {
        print("Failed to create key down event")
        return
    }

    // Simulate key up event
    guard let keyUpEvent = CGEvent(
        keyboardEventSource: eventSource,
        virtualKey: keyCode,
        keyDown: false
    ) else {
        print("Failed to create key up event")
        return
    }

    // Post the key down event
    keyDownEvent.post(tap: .cghidEventTap)

    // Small delay to ensure the key down is processed before key up
    let waitTime = waitTimeMs < 0 ? 5 : waitTimeMs
    let waitTimeSeconds = Double(waitTime) / 1000.0
    Thread.sleep(forTimeInterval: waitTimeSeconds)

    // Post the key up event
    keyUpEvent.post(tap: .cghidEventTap)
}
