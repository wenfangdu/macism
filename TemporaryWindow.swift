import Foundation

@main
struct TemporaryWindowApp {
    static func main() {
        // Parse waitTimeMs from environment variable MACISM_WAIT_TIME_MS if available
        var waitTimeMs: Int = -1
        if let waitTimeStr = ProcessInfo.processInfo.environment["MACISM_WAIT_TIME_MS"],
           let waitTime = Int(waitTimeStr) {
            waitTimeMs = waitTime
        }        
        // Call the function to show the temporary window (defined in WindowUtils.swift)
        showTemporaryInputWindow_l2(waitTimeMs: waitTimeMs)
    }
}
