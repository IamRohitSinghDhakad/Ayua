//
//  AppLoaderView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 29/01/26.
//

import Foundation
import UIKit

final class AppLoaderView: UIView {

    static let shared = AppLoaderView()

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        isUserInteractionEnabled = true   // 🔑 blocks touches below

        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    // MARK: - Animation
    private func startAnimation() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        logoImageView.alpha = 0.7

        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: [.autoreverse, .repeat, .curveEaseInOut],
            animations: {
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.logoImageView.alpha = 1.0
            }
        )
    }

    private func stopAnimation() {
        logoImageView.layer.removeAllAnimations()
    }

    // MARK: - Public
    func show() {
        guard let window = UIApplication.shared.keyWindowInConnectedScenes else { return }

        frame = window.bounds

        if superview == nil {
            window.addSubview(self)
            startAnimation()
        }
    }


    func hide() {
        stopAnimation()
        removeFromSuperview()
    }
}

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
