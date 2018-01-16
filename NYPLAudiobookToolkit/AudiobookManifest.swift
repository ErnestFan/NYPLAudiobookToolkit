//
//  AudiobookManifest.swift
//  NYPLAudibookKit
//
//  Created by Dean Silfen on 1/12/18.
//  Copyright © 2018 Dean Silfen. All rights reserved.
//

import UIKit
import AudioEngine

private func findawayKey(_ key: String) -> String {
    return "findaway:\(key)"
}

public class AudiobookManifest: NSObject {
    private let spine: [SpineLink]
    
    public init?(JSON: Any?) {
        guard let payload = JSON as? [String: Any] else { return nil }
        guard let metadata = payload["metadata"] as? [String: Any] else { return nil }
        guard let spine = payload["spine"] as? [Any] else { return nil }
        if let sessionKey = metadata[findawayKey("sessionKey")] as? String,
            let audiobookID = metadata[findawayKey("fulfillmentId")] as? String {
            self.spine = spine.flatMap { (possibleLink) -> FindawayLink? in
                FindawayLink(
                    JSON: possibleLink,
                    sessionKey: sessionKey,
                    audiobookID: audiobookID
                )
            }
        } else {
            self.spine = spine.flatMap { (possibleLink) -> AudiobookLink? in
                AudiobookLink(JSON: possibleLink)
            }
        }
    }
}

protocol SpineLink { }

class AudiobookLink: SpineLink {
    let url: URL
    let mediaType: String
    let duration: Int
    let bitrate: Int

    public init?(JSON: Any?) {
        guard let payload = JSON as? [String: Any] else { return nil }
        guard let address = payload["href"] as? String else { return nil }
        guard let url = URL(string: address) else { return nil }
        guard let mediaType = payload["type"] as? String else { return nil }
        guard let duration = payload["duration"] as? Int else { return nil }
        guard let bitrate = payload["bitrate"] as? Int else { return nil }
        self.url = url
        self.mediaType = mediaType
        self.duration = duration
        self.bitrate = bitrate
    }
}

class FindawayLink: SpineLink {
    let chapterNumber: UInt
    let partNumber: UInt
    let sessionKey: String
    let audiobookID: String

    public init?(JSON: Any?, sessionKey: String, audiobookID: String) {
        guard let payload = JSON as? [String: Any] else { return nil }
        guard let sequence = payload[findawayKey("sequence")] as? UInt else { return nil }
        guard let partNumber = payload[findawayKey("part")] as? UInt else { return nil }
        self.chapterNumber = sequence
        self.partNumber = partNumber
        self.sessionKey = sessionKey
        self.audiobookID = audiobookID
    }
}