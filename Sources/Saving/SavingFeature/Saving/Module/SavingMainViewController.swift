//
//  HomeViewController.swift
//  FolksamApp
//
//  Created by Johan Torell on 2021-01-28.
//

import Combine
import FolksamCommon
import UIKit
import Foundation

@available(iOS 13.0, *)
class MainButton: UIButton {
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var viewModel: MainButtonViewModel?

    init(with viewModel: MainButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        addSubviews()
        configure(with: viewModel)
    }

    private func addSubviews() {
        guard !buttonLabel.isDescendant(of: self) else {
            return
        }
        addSubview(buttonLabel)
        addSubview(iconView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        viewModel = nil
        super.init(frame: frame)
    }

    public func configure(with viewModel: MainButtonViewModel) {
        addSubviews()
        backgroundColor = FolksamColor.Gray6
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = FolksamColor.Blue1.cgColor

        buttonLabel.text = viewModel.title
        buttonLabel.textColor = FolksamColor.Blue1

        iconView.image = UIImage(systemName: viewModel.imageName)?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = FolksamColor.Blue1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 15, y: 15, width: frame.width - 30, height: frame.height - 40).integral
        buttonLabel.frame = CGRect(x: 5, y: frame.height - 30, width: frame.width - 10, height: 25).integral
    }
}

struct MainButtonViewModel {
    let title: String
    let imageName: String
    let action: Selector
}

@available(iOS 13.0, *)
public class SavingMainViewController: UIViewController {
    @IBOutlet var buttonMySavings: FolksamCardView!
    @IBOutlet var buttonNewGoal: FolksamCardView!
    @IBOutlet var graphButton: UIButton!
    @IBOutlet var dotButton: UIButton!
    @IBOutlet var nameLabel: UILabel!

    private var viewModel: SavingViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private let buttons: [MainButtonViewModel] = [
        MainButtonViewModel(title: "Administrera sparande", imageName: "gear", action: #selector(segueToTestView)),
        MainButtonViewModel(title: "Sparhistorik", imageName: "dollarsign.circle", action: #selector(segueToChartView)),
        MainButtonViewModel(title: "Mina sparmål", imageName: "heart", action: #selector(segueToGoalFlow)),
        MainButtonViewModel(title: "Värdeutveckling", imageName: "gauge", action: #selector(segueToChartView)),
        MainButtonViewModel(title: "Sparfördelning", imageName: "chart.pie", action: #selector(segueToGoalFlow)),
        MainButtonViewModel(title: "Kvittens", imageName: "ant", action: #selector(segueToGoalFlow)),
        MainButtonViewModel(title: "Ändra förmånstagre", imageName: "person.2", action: #selector(segueToGoalFlow)),
    ]

    override public func viewDidLoad() {
        super.viewDidLoad()
        buttonMySavings.addTarget(self, action: #selector(segueToMySavingView), for: .touchUpInside)
        buttonNewGoal.addTarget(self, action: #selector(segueToGoalFlow), for: .touchUpInside)
        dotButton.addTarget(self, action: #selector(segueToTestView), for: .touchUpInside)
        bindViewModel()
        viewModel.fetchSavings(value: "vc1")
    }

    private func createMainButton(with model: MainButtonViewModel, frame: CGRect) -> MainButton {
        let button = MainButton(frame: frame)
        button.configure(with: model)
        button.addTarget(self, action: model.action, for: .touchUpInside)
        return button
    }

    private func bindViewModel() {
        viewModel.$userSavings
            .sink { [weak self] in print($0) }
            .store(in: &cancellables)
    }

    public static func make(savingsRepo: SavingsRepositoryProtocol) -> UINavigationController {
        let storyboard = UIStoryboard(name: "SavingTab", bundle: Bundle.module)
        let (navigationController, viewController) = UIStoryboard.instantiateNavigationController(
            from: storyboard,
            childOfType: self
        )

        viewController.viewModel = SavingViewModel(savingsRepo: savingsRepo)

        navigationController.tabBarItem = UITabBarItem(title: "Spara", image: UIImage(named: "Piggybank"), selectedImage: UIImage(named: "Piggybank"))

        return navigationController
    }

    @objc func segueToChartView() {
        let vc = GraphViewController.make()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func segueToGoalFlow() {
        let vc = MySavingGoalsViewController.make(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func segueToTestView() {
        let vc = TestStoryboardViewController.make()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func segueToMySavingView() {
        let vc = MySavingViewController.make()
        navigationController?.pushViewController(vc, animated: true)
    }
}
