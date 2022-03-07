//
//  Simulator.swift
//  Saving
//
//  Created by Richard Ristic on 2021-06-28.
//

import UIKit

struct SimulatorResult {
    var endDate: String
    var capital: Double
    var deposits: Double
    var profit: Double
}

class Simulator {
    let ratio: Double = 0.25

    let initial_capital: Double
    var goal_years: Int
    var monthly_deposit: Double

    let yearly_growth: Double
    let yearly_fee: Double

    var accumulatedCapital = [DataEntry]()
    var accumulatedDeposits = [DataEntry]()
    var accumulatedProfit = [DataEntry]()

    var endDate = ""
    var startDate = ""
    var lowerBoundEndDate = ""
    var upperBoundEndDate = ""

    var endCapital: Double = 0.0
    var endProfit: Double = 0.0
    var endDeposits: Double = 0.0

    init(goal_years: Int = 0, initial_capital: Double, monthly_deposit: Double = 0.0, yearly_growth: Double, yearly_fee: Double) {
        self.goal_years = goal_years
        self.initial_capital = initial_capital
        self.monthly_deposit = monthly_deposit
        self.yearly_growth = yearly_growth
        self.yearly_fee = yearly_fee
        calculate()
    }

    private func calculate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"

        let goal_months = goal_years * 12
        let monthly_growth = pow(1 + yearly_growth, 1 / 12) - 1
        let monthly_fee = 1 - pow(1 - yearly_fee, 1 / 12)

        var date = Date()
        var capital = initial_capital
        var capitalBetter = capital
        var capitalWorse = capital
        var deposits = 0.0
        var profit = 0.0
        var profitBetter = 0.0
        var profitWorse = 0.0

        for m in 0 ... goal_months + 5 * 12 {
            deposits += monthly_deposit

            capital = (capital + monthly_deposit) * (1 + monthly_growth - monthly_fee)
            capitalBetter = (capitalBetter + monthly_deposit) * (1 + monthly_growth * (1 + ratio) - monthly_fee)
            capitalWorse = (capitalWorse + monthly_deposit) * (1 + monthly_growth * (1 - ratio) - monthly_fee)

            profit = capital - initial_capital - deposits
            profitBetter = capitalBetter - initial_capital - deposits
            profitWorse = capitalWorse - initial_capital - deposits

            let dateString = formatter.string(from: date)
            accumulatedCapital.append(DataEntry(value: capital, upperBound: capitalBetter, lowerBound: capitalWorse, date: dateString))
            accumulatedDeposits.append(DataEntry(value: deposits, upperBound: deposits, lowerBound: deposits, date: dateString))
            accumulatedProfit.append(DataEntry(value: profit, upperBound: profitBetter, lowerBound: profitWorse, date: dateString))

            if m == 0 {
                startDate = dateString
            }

            if m == goal_months {
                endDate = dateString
                endCapital = capital
                endProfit = profit
                endDeposits = deposits
            }

//            if endDate == "" && capital >= goal_capital {
//                endDate = dateString
//            }
//            if lowerBoundEndDate == "" && capitalWorse >= goal_capital {
//                lowerBoundEndDate = dateString
//            }
//            if upperBoundEndDate == "" && capitalBetter >= goal_capital {
//                upperBoundEndDate = dateString
//            }

            date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        }
    }

    public func visualize(chart: LineChart) {
        chart.plot(dataEntries: accumulatedCapital, startDate: startDate, endDate: endDate)
        chart.markDate(date: endDate)
    }

    public func result() -> SimulatorResult {
        let result = SimulatorResult(endDate: endDate, capital: endCapital, deposits: endDeposits, profit: endProfit)
        return result
    }

    public func get_endDate() -> String {
        return endDate
    }

//    private func generateNewTestEntries() -> [DataEntry] {
//        var result: [DataEntry] = []
//        var value: Int = 0
//        for i in 0..<200 {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM YYYY"
//            var date = Date()
//            date.addTimeInterval(TimeInterval(24*60*60*30*i))
//
//            result.append(DataEntry(value: value, date: formatter.string(from: date)))
//            value = Int((Double(value+1500)*1.008))
//
//        }
//        return result
//    }
}
