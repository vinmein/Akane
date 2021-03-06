//
// This file is part of Akane
//
// Created by JC on 22/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond
#if AKANE_AS_FRAMEWORK
    import Akane
#endif

open class CommandObservation : Observation {
    public var value: BondCommand? = nil

    public var next: [((BondCommand) -> Void)] = []

    fileprivate var controls: [UIControl] = []

    var canExecuteObservation: AnyObservation<Bool>? = nil
    var isExecutingObservation: AnyObservation<Bool>? = nil

    init(command: BondCommand, observer: ViewObserver?) {
        self.value = command

        self.canExecuteObservation = observer?.observe(command.canExecute)
        self.isExecutingObservation = observer?.observe(command.isExecuting)
    }

    deinit {
        self.unobserve()
    }

    public func unobserve() {
        for control in self.controls {
            control.removeTarget(self, action: nil, for: .allEvents)
        }

        self.canExecuteObservation?.unobserve()
        self.isExecutingObservation?.unobserve()

        self.controls = []
        self.next = []
        self.value = nil
    }
}

extension CommandObservation {
    public func bind(to control: UIControl?, events: UIControlEvents = .touchUpInside) {
        if let control = control {
            self.bind(to: control, events: events)
        }
    }

    /**
     Binds command on `control`. It also attaches:
     - command `canExecute` with control `enabled`
     - command `isExecuting` (if AsyncCommand) with control `userInteractionEnabled`
     */
    public func bind(to control: UIControl, events: UIControlEvents = .touchUpInside) {
        control.addTarget(self, action: #selector(self.onTouch(_:)), for: events)

        self.controls.append(control)
        
        // FIXME remove dep on Bond
        self.canExecuteObservation?.bind(to: control.reactive.isEnabled)
        self.isExecutingObservation?
            .convert { !$0 }
            .bind(to: control.reactive.isUserInteractionEnabled)
    }

    @objc
    func onTouch(_ sender: UIControl) {
        if let commandable = sender as? Commandable {
            self.value?.execute(commandable)
        }
        else {
            self.value?.execute(sender)
        }
    }
}
