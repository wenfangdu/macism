import Foundation

@main
struct MacISM {
    static func main() {
        // Initialize input sources
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
                InputSourceManager.waitTimeMs = Int(filteredArgs[2])!
            }
            dstSource?.select()
        }
    }
}
