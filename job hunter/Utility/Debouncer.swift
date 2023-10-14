//
//  Debouncer.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/13/23.
//
import Foundation

class Debouncer {
    private var workItem: DispatchWorkItem?
    private var delay: TimeInterval
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
