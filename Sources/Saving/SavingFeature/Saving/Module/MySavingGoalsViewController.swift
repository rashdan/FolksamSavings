//
//  MySavingGoalsViewController.swift
//  Saving
//
//  Created by Johan Torell on 2021-06-23.
//

import Combine
import FolksamCommon
import UIKit

class MySavingGoalsViewController: UIViewController, BaseViewController {
    static var storyboardName = "SavingGoals"
    typealias T = MySavingGoalsViewController

    @IBOutlet var nextButton: UIButton!
    @IBOutlet var addButton: FolksamCardView!
    internal var viewModel: SavingViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc2 viewDidLoad")
        bindViewModel()
        viewModel.fetchSavings(value: "vc2")
    }

    private func bindViewModel() {
        viewModel.$userSavings
            .sink { [weak self] in print($0) }
            .store(in: &cancellables)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NewSavingGoalViewController {
            if let card = sender as? FolksamCardView {
                var params: SavingGoalParamters

                switch card.titleText! {
                case "Till barnen":
                    params = SavingGoalParamters(monthly: SliderParamters(min: 200, step: 50, max: 5000, startValue: 1250), years: SliderParamters(min: 5, step: 1, max: 40, startValue: 18), total: SliderParamters(min: 10000, step: 1000, max: 1_000_000, startValue: 50000), productName: card.titleText!)
                case "Till pension":
                    params = SavingGoalParamters(monthly: SliderParamters(min: 200, step: 100, max: 5000, startValue: 2500), years: SliderParamters(min: 5, step: 1, max: 40, startValue: 10), total: SliderParamters(min: 10000, step: 1000, max: 1_000_000, startValue: 50000), productName: card.titleText!)
                case "Till resan":
                    params = SavingGoalParamters(monthly: SliderParamters(min: 200, step: 100, max: 5000, startValue: 2500), years: SliderParamters(min: 5, step: 1, max: 40, startValue: 10), total: SliderParamters(min: 10000, step: 1000, max: 1_000_000, startValue: 50000), productName: card.titleText!)
                default:
                    params = SavingGoalParamters(monthly: SliderParamters(min: 200, step: 100, max: 5000, startValue: 2500), years: SliderParamters(min: 5, step: 1, max: 40, startValue: 10), total: SliderParamters(min: 10000, step: 1000, max: 1_000_000, startValue: 50000), productName: "")
                }

                dest.savingGoalParameters = params
            }
        }
    }
}
