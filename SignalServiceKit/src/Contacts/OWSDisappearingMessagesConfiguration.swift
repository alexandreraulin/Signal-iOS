//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation

@objc
public class DisappearingMessageToken: MTLModel {
    @objc
    public var isEnabled: Bool = false
    @objc
    public var durationSeconds: UInt32 = 0

    @objc
    public init(isEnabled: Bool, durationSeconds: UInt32) {
        // Consider disabled if duration is zero.
        self.isEnabled = isEnabled && durationSeconds > 0
        // Use zero duration if not enabled.
        self.durationSeconds = isEnabled ? durationSeconds : 0

        if isEnabled != self.isEnabled {
            owsFailDebug("isEnabled: \(isEnabled) != self.isEnabled: \(self.isEnabled)")
        }
        if durationSeconds != self.durationSeconds {
            owsFailDebug("durationSeconds: \(durationSeconds) != self.durationSeconds: \(self.durationSeconds)")
        }

        super.init()
    }

    // MARK: - MTLModel

    @objc
    public override init() {
        super.init()
    }

    @objc
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc
    public required init(dictionary dictionaryValue: [String: Any]!) throws {
        try super.init(dictionary: dictionaryValue)
    }

    // MARK: -

    @objc
    public static var disabledToken: DisappearingMessageToken {
        return DisappearingMessageToken(isEnabled: false, durationSeconds: 0)
    }

    @objc
    public class func token(forProtoExpireTimer expireTimer: UInt32) -> DisappearingMessageToken {
        if expireTimer > 0 {
            return DisappearingMessageToken(isEnabled: true, durationSeconds: expireTimer)
        } else {
            return .disabledToken
        }
    }
}

// MARK: -

public extension OWSDisappearingMessagesConfiguration {
    var asToken: DisappearingMessageToken {
        return DisappearingMessageToken(isEnabled: isEnabled, durationSeconds: durationSeconds)
    }
}
