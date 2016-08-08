import Foundation

/// Argument Parsing

func urlAt(_ position: Int, within collection: [String]) -> URL? {
    guard position < collection.count else {
        print("\(Process.arguments.first) requires 2 arguments: a source URL and a destination path.")
        exit(EXIT_FAILURE)
    }
    
    if let url = URL(string: collection[position]) {
        print(url)
        if url.scheme == nil {
            return URL(fileURLWithPath: url.path)
        }
        return url
    } else {
        print("Expected valid URL for argument \(position)")
    }
    return nil
}

let args = Array(Process.arguments[1..<Process.arguments.count])

if args.count <= 1 {
    exit(EXIT_FAILURE)
}

guard let sourceURL = urlAt(0, within: args), let destinationURL = urlAt(1, within: args) else {
    exit(EXIT_FAILURE)
}

let downloader = Downloader(destination: destinationURL)

downloader.downloadHLSResource(sourceURL)

RunLoop.main.run()
