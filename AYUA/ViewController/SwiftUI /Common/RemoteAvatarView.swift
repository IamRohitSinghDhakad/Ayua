//
//  RemoteAvatarView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import SwiftUI


struct AvatarImage: View {
    let urlString: String?
    let size: CGFloat

    var body: some View {
        let url = URL(string: urlString ?? "")
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                // Loading indicator
                //ProgressView()
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
            case .failure(_):
                Image("logo") // Default placeholder
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
            @unknown default:
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
            }
        }
        .clipShape(Circle())
        .background(Circle().fill(Color.gray.opacity(0.2)))
    }
}
