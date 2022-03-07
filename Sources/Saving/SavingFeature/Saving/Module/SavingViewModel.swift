//
//  SavingViewModel.swift
//  Saving
//
//  Created by Johan Torell on 2021-06-22.
//

import Combine
import FolksamCommon

@available(iOS 13.0, *)
final class SavingViewModel: BaseViewModel {
    @Published private(set) var userSavings: [String] = ["TEST VIEWMODEL"]
    private var savingsRepo: SavingsRepositoryProtocol

    init(savingsRepo: SavingsRepositoryProtocol) {
        self.savingsRepo = savingsRepo
        super.init()
    }

    func fetchSavings(value: String) {
        userSavings = [value, value]
    }
}
