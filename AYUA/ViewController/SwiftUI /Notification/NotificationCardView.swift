//
//  NotificationCardView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//

import SwiftUI
import Combine


struct NotificationCardView: View {
    
    let item: NotificationModel
    let onReject: () -> Void
    let onReview: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            
            //Top Row
            HStack(alignment: .top, spacing: 12){
                Image(.profile2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4){
                    Text("User Name")
                        .font(.headline)
                    Text("Hey! Are we still on for the meeting tomorrow?")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4){
                    
                    HStack(spacing: 4){
                        Text(String(format: "%.1f", "4.5"))
                            .font(.subheadline)
                            .bold()
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    
                    Text("50348KM")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            //Profession
            Text("item.profession")
                .font(.subheadline)
                .bold()
            
            // Service Details
            Text("Service details: \("item.details")")
                .font(.footnote)
                .foregroundColor(.gray)
            
            // Buttons
            HStack(spacing: 12) {
                Button(action: onReject) {
                    Text("Reject")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Button(action: onReview) {
                    Text("Review")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }
            }
        }
        
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        
    }
}

#Preview {
    NotificationCardView(item: NotificationModel(from: [:]), onReject: { }, onReview: { })
}
