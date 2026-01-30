//
//  PlanCardView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import SwiftUI

struct PlanCardView: View {

    let plan: PlanModel
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text(plan.title)
                .font(.headline)
                .foregroundColor(.green)

            Text("$\(String(format: "%.2f", plan.price))")
                .font(.title2)
                .bold()

            if let ayua = plan.ayua {
                Text("This plan is for \(ayua) AYUA")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if let months = plan.durationMonths {
                Text("This plan is for \(months) month")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isSelected ? Color.green.opacity(0.15) : Color.white)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
