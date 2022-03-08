//
//  GraphViewController.swift
//  Saving
//
//  Created by Johan Torell on 2021-06-22.
//

import FolksamCommon
import Foundation
import UIKit

public class GraphViewController: UIViewController {
    @IBOutlet var chart: LineChart!

    public static func make() -> GraphViewController {
        let storyboard = UIStoryboard(name: "Graph", bundle: Bundle.module)
        let viewController = UIStoryboard.instantiateViewController(from: storyboard, ofType: self)
        return viewController
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let sim = Simulator(
            goal_years: 40,
            initial_capital: 0,
            monthly_deposit: 6000,
            yearly_growth: 0.04,
            yearly_fee: 0.004
        )
        sim.visualize(chart: chart)
        print(sim.result())
    }
}
