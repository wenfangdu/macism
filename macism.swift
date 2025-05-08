import Foundation

@main
struct MacISM {
    static func main() {
        // Initialize input sources
        InputSourceManager.initialize()

        if CommandLine.arguments.contains(where: { arg in
            arg.caseInsensitiveCompare("--version") == .orderedSame
        }) {
            print("v3.0.9")
            return
        }

        if CommandLine.arguments.count == 1 {
            let currentSource = InputSourceManager.getCurrentSource()
            print(currentSource.id)
        } else {
            // Process command line arguments for flags
            let arguments = CommandLine.arguments

            // Filter out flag arguments to get the input source name
            let filteredArgs = arguments.filter { arg in
                !arg.hasPrefix("--")
            }

            if filteredArgs.count < 2 {
                print("No input source name provided!")
                return
            }

            guard let dstSource = InputSourceManager.getInputSource(
                name: filteredArgs[1]
            ) else {
                print("Input source \(filteredArgs[1]) does not exist!")
                return
            }

            dstSource.select()
        }
    }
}
