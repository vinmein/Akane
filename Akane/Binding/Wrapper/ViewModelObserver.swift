//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class ViewModelObserver<ViewModelType: ComponentViewModel> : Observer {
    var value: ViewModelType? = nil {
        didSet { self.runNext() }
    }

    var next: [(ViewModelType -> Void)] = [] {
        didSet { self.runNext() }
    }

    unowned let lifecycle: Lifecycle

    init(lifecycle: Lifecycle) {
        self.lifecycle = lifecycle
    }
}

extension ViewModelObserver {

    public func bindTo<ViewType: UIView where ViewType: ComponentView>(view: ViewType?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<ViewType: UIView where ViewType: ComponentView>(view: ViewType) {
        let controller: ComponentViewController? = self.lifecycle.presenterForSubview(view, createIfNeeded: true)

        guard (controller != nil) else {
            return
        }

        self.next { value in
            controller!.viewModel = value
        }
    }

    func bindTo(cell: UIView, template: Template) {
        template.bind(cell, wrapper: self)
    }
}