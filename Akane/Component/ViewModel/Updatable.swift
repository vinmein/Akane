//
// This file is part of Akane
//
// Created by JC on 17/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol Updatable {
    func setNeedsUpdate()
}

extension Updatable {
    var onRender: (Void -> Void)? {
        get { return nil }
        set { }
    }

    func setNeedsUpdate() {
        self.onRender?()
    }
}