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
