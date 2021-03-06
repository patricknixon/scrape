//
//  HLS.swift
//  Strip
//
//  Created by Fabian Canas on 8/1/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import FFCLog
import Foundation
import Parsing

/// HLS Namespace
public enum HLS {

    // swiftlint:disable force_try
    // Lines that are neither comments nor tags are URLs to resources - and don't begin with #
    private static let resourceExpression = try! NSRegularExpression(pattern: "^(?!#).+", options: [.anchorsMatchLines])
    // swiftlint:enable force_try

    /// Given an HLS manifest string, and the manifest's URL, generates an array of
    /// resource URLs specified in the manifest.
    internal static func resourceURLs(_ manifestString: NSString, manifestURL: URL) -> [URL] {
        let s = manifestString as String

        var urls: Set<URL> = Set()
        if let master = parseMasterPlaylist(string: s, atURL: manifestURL) {
            _ = master.renditions.compactMap({ rendition in
                rendition.uri.map({urls.insert($0)})
            })
            _ = master.streams.map({ stream in
                urls.insert(stream.uri)
            })
        }

        if let media = parseMediaPlaylist(string: s, atURL: manifestURL) {
            _ = media.segments.map { segment in
                urls.insert(segment.resource.uri)
            }
        }

        // De-duplicate URLs
        return Array(urls)
    }

    public static func ingestResource(_ originalResourceURL: URL,
                                      temporaryFileURL: URL,
                                      logger: FFCLog) -> [URL] {

        guard originalResourceURL.type == .Playlist else {
            return []
        }

        guard let hlsString = try? NSString(contentsOf: temporaryFileURL,
                                            encoding: String.Encoding.utf8.rawValue) else {
                                                logger.log("Playlist at \(originalResourceURL) not decodable as a utf8",
                                                    level: .error)
                                                return []
                                            }
        return resourceURLs(hlsString, manifestURL: originalResourceURL)
    }
}
