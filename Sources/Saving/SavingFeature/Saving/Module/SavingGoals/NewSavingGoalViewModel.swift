//
//  NewSavingGoalViewModel.swift
//  Saving
//
//  Created by Johan Torell on 2021-07-01.
//

import Combine
import FolksamCommon

struct SavingGoal {
    var monthly: Int = 0
    var years: Int = 0
    var total: Int = 0
}

struct SavingGoalParamters {
    var monthly: SliderParamters
    var years: SliderParamters
    var total: SliderParamters
    var productName: String
}

@available(iOS 13.0, *)
final class NewSavingGoalViewModel: BaseViewModel {
    @Published private(set) var goals = SavingGoal()

    override init() {
        super.init()
    }

    func updateGoals(newGoals: SavingGoal) {
        goals = newGoals
    }
}
