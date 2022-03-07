//
//  ChartViewController.swift
//  Saving
//
//  Created by Johan Torell on 2021-07-01.
//

import Combine
import FolksamCommon
import Foundation
import UIKit

public class ChartViewController: UIViewController {
    @IBOutlet var chart: LineChart!

    @IBOutlet var interestSlider: FolksamSliderV2!

    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var monthly: FolksamSliderV2!
    @IBOutlet var years: FolksamSliderV2!
    @IBOutlet var total: FolksamSliderV2!
    @IBOutlet var finish: FolksamButton!
//    @IBOutlet weak var total: FolksamSliderV2!

    let fmt: NumberFormatter = {
        let n = NumberFormatter()
        n.usesGroupingSeparator = true
        n.numberStyle = .decimal
        n.locale = Locale(identifier: "sv_SE")
        n.maximumFractionDigits = 0
        return n
    }()

    var viewModel: NewSavingGoalViewModel!
    var savingGoalParameters: SavingGoalParamters?

    private var cancellables: Set<AnyCancellable> = []

    override public func viewDidLoad() {
        super.viewDidLoad()

        monthly.delegate = self
        years.delegate = self
        interestSlider.delegate = self
//        total.delegate = self
        monthly.configure(savingGoalParameters!.monthly)
        years.configure(savingGoalParameters!.years)

        bindViewModel()

        finish.addTarget(self, action: #selector(finishFlow), for: .touchUpInside)

        monthly.value = Float(viewModel.goals.monthly)
        years.value = Float(viewModel.goals.years)
//        total.value = Float(viewModel.goals.total)
        updateChart()
    }

    private func bindViewModel() {
        viewModel.$goals
            .sink { [weak self] _ in
                if let self = self {
                    self.updateChart()
                }
            }
            .store(in: &cancellables)
    }

    func updateChart() {
        let sim = Simulator(
            goal_years: viewModel.goals.years,
            initial_capital: 0,
            monthly_deposit: Double(viewModel.goals.monthly),
            yearly_growth: Double(interestSlider.value * 0.01),
            yearly_fee: 0.004
        )
        sim.visualize(chart: chart)
        let simResults = sim.result()
        totalLabel.text = "\(fmt.string(from: NSNumber(value: simResults.capital))!) kr"
    }

    @objc func finishFlow() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ChartViewController: FolksamSliderDelegate {
    public func onChangeValue(sender _: FolksamSliderV2, value _: Float) {
        let newGoals = SavingGoal(monthly: Int(monthly.value), years: Int(years.value), total: 0)
        viewModel.updateGoals(newGoals: newGoals)
    }

    public func dragEnded() {}
}
