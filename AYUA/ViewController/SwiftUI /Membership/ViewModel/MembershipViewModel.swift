//
//  MembershipViewModel.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import Foundation
import SwiftUI
import Combine

enum PlanType: String, Codable {
    case currency
    case membership
}

struct PlanModel: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let ayua: Int?
    let durationMonths: Int?
    let type: PlanType
    let isRecommended: Bool
}

struct WalletResponse: Codable {
    let balance: Int
    let plans: [PlanModel]
}


final class MembershipViewModel: ObservableObject {

    @Published var walletBalance: Int = 0
    @Published var currencyPlans: [PlanModel] = []
    @Published var membershipPlans: [PlanModel] = []

    @Published var selectedCurrencyPlan: PlanModel?
    @Published var selectedMembershipPlan: PlanModel?

    func fetchData() {
        // 🔹 Replace with real API call
        let mockPlans: [PlanModel] = [
            PlanModel(id: 1, title: "Basic", price: 20, ayua: 20, durationMonths: nil, type: .currency, isRecommended: false),
            PlanModel(id: 2, title: "Essential", price: 50, ayua: 50, durationMonths: nil, type: .currency, isRecommended: true),
            PlanModel(id: 3, title: "Premium", price: 80, ayua: 80, durationMonths: nil, type: .currency, isRecommended: false),

            PlanModel(id: 4, title: "Basic", price: 20, ayua: nil, durationMonths: 3, type: .membership, isRecommended: true),
            PlanModel(id: 5, title: "Essential", price: 50, ayua: nil, durationMonths: 6, type: .membership, isRecommended: false),
            PlanModel(id: 6, title: "Premium", price: 80, ayua: nil, durationMonths: 12, type: .membership, isRecommended: false)
        ]

        walletBalance = 90
        currencyPlans = mockPlans.filter { $0.type == .currency }
        membershipPlans = mockPlans.filter { $0.type == .membership }
    }

    func buyCurrency() {
        guard let plan = selectedCurrencyPlan else { return }
        print("Buying AYUA Plan: \(plan.title)")
    }

    func getMembership() {
        guard let plan = selectedMembershipPlan else { return }
        print("Getting Membership: \(plan.title)")
    }
}
