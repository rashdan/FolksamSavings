//
//  SavingGoals2.swift
//  Saving
//
//  Created by Johan Torell on 2021-07-01.
//

import Combine
import FolksamCommon
import Foundation
import UIKit

class NewSavingGoalViewController: UIViewController {
    @IBOutlet var monthly: FolksamSliderV2!
//    @IBOutlet weak var total: FolksamSliderV2!
    @IBOutlet var years: FolksamSliderV2!

    var viewModel = NewSavingGoalViewModel()
    private var cancellables: Set<AnyCancellable> = []

    public var savingGoalParameters: SavingGoalParamters?

    override func viewDidLoad() {
        super.viewDidLoad()
        monthly.delegate = self
//        total.delegate = self
        years.delegate = self
        bindViewModel()

        monthly.configure(savingGoalParameters!.monthly)
        years.configure(savingGoalParameters!.years)

        viewModel.updateGoals(newGoals: SavingGoal(monthly: Int(savingGoalParameters!.monthly.startValue), years: Int(savingGoalParameters!.years.startValue), total: 0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monthly.value = Float(viewModel.goals.monthly)
        years.value = Float(viewModel.goals.years)
//        total.value = Float(viewModel.goals.total)
    }

    private func bindViewModel() {
        viewModel.$goals
            .sink { [weak self] in print($0) }
            .store(in: &cancellables)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let dest = segue.destination as? ChartViewController {
            dest.viewModel = viewModel
            dest.savingGoalParameters = savingGoalParameters
        }
    }
}

extension NewSavingGoalViewController: FolksamSliderDelegate {
    func onChangeValue(sender _: FolksamSliderV2, value _: Float) {
        let newGoals = SavingGoal(monthly: Int(monthly.value), years: Int(years.value), total: 0)
        viewModel.updateGoals(newGoals: newGoals)
    }

    func dragEnded() {}
}
