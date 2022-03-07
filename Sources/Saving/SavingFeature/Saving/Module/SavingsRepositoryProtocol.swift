//
//  SavingsRepositoryProtocol.swift
//  Saving
//
//  Created by Johan Torell on 2021-06-22.
//

import Foundation

public protocol SavingsRepositoryProtocol {
    func getSavings() -> String
    func saveSavingGoal()
}
