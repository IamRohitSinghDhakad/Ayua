//
//  MembershipView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import SwiftUI
import Combine

struct MembershipView: View {

    @StateObject private var vm = MembershipViewModel()

    var body: some View {
        //header
        CustomHeaderView(
            title: "Membership",
            leftIcon: Image(.membership),
            onLeftTap: nil,
            showNotification: true,
            notificationIcon: Image(.notifi),
            onNotificationTap: {
                print("Notification tapped")
            },
            onMenuTap: {
                if let topVC = UIApplication.shared.topViewController() {
                    SideMenuManager.shared.showMenu(from: topVC)
                }
            }
        )
        
        ScrollView {
            VStack(spacing: 24) {

                // Wallet
                walletView

                // Currency Plans
                planSection(
                    plans: vm.currencyPlans,
                    selectedPlan: $vm.selectedCurrencyPlan
                )

                Button("Buy AYUA") {
                    vm.buyCurrency()
                }
                .primaryButton()

                Text("OR")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text("Choose your membership")
                    .font(.headline)

                planSection(
                    plans: vm.membershipPlans,
                    selectedPlan: $vm.selectedMembershipPlan
                )

                Button("Get Plan") {
                    vm.getMembership()
                }
                .primaryButton()
            }
            .padding()
        }
        .onAppear {
            vm.fetchData()
        }
    }

    private var walletView: some View {
        HStack {
            Text("My Virtual Currency Balance")
                .font(.subheadline)

            Spacer()

            Text("\(vm.walletBalance) AYUA")
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    private func planSection(
        plans: [PlanModel],
        selectedPlan: Binding<PlanModel?>
    ) -> some View {
        HStack(spacing: 12) {
            ForEach(plans) { plan in
                PlanCardView(
                    plan: plan,
                    isSelected: selectedPlan.wrappedValue?.id == plan.id
                )
                .onTapGesture {
                    selectedPlan.wrappedValue = plan
                }
            }
        }
    }
}


extension Button {
    func primaryButton() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(14)
            .font(.headline)
    }
}
