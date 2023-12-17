//
//  Utilities.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/8/23.
//

import Foundation


func formatDateWithoutTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}


func formatNumber(_ number: Double) -> String {
    if number < 1000 {
        // If the number is less than 1000, return it as is
        return "\(number)"
    } else if number < 1_000_000 {
        // If the number is in thousands
        return String(format: "%.2fK", number / 1000)
    } else {
        // If the number is in millions
        return String(format: "%.2fM", number / 1_000_000)
    }
}
