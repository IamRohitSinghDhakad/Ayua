//
//  ImagePreviewView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

import Foundation
import SwiftUI

struct ImagePreviewView: View {

    let url: URL
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()

            VStack {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }

                Button("Close") {
                    onClose()
                }
                .padding()
                .foregroundColor(.white)
            }
        }
    }
}
