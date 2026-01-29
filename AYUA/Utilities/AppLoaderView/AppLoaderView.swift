//
//  AppLoaderView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad on 29/01/26.
//

import UIKit

final class AppLoaderView: UIView {

    // MARK: - Singleton
    static let shared = AppLoaderView()

    // MARK: - Views
    private let blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        blur.alpha = 0.5 
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }()

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let ringLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    // MARK: - Init
    private init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = true

        addSubview(blurView)
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90)
        ])

        // Logo glow
        logoImageView.layer.shadowColor = UIColor.white.cgColor
        logoImageView.layer.shadowRadius = 16
        logoImageView.layer.shadowOpacity = 0.9
        logoImageView.layer.shadowOffset = .zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupAnimatedRing()
    }

    // MARK: - Ring Setup
    private func setupAnimatedRing() {
        gradientLayer.removeFromSuperlayer()
        ringLayer.removeFromSuperlayer()

        let radius: CGFloat = 62
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )

        ringLayer.path = path.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.white.cgColor
        ringLayer.lineWidth = 4
        ringLayer.lineCap = .round
        ringLayer.strokeStart = 0
        ringLayer.strokeEnd = 0.18

        ringLayer.shadowColor = UIColor.white.cgColor
        ringLayer.shadowRadius = 10
        ringLayer.shadowOpacity = 0.8
        ringLayer.shadowOffset = .zero

        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.white.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = ringLayer

        layer.addSublayer(gradientLayer)
    }

    // MARK: - Animations
    private func startAnimation() {
        startLogoPulse()
        startRingRotation()
        startRingSweep()
    }

    private func stopAnimation() {
        logoImageView.layer.removeAllAnimations()
        gradientLayer.removeAllAnimations()
        ringLayer.removeAllAnimations()
    }

    private func startLogoPulse() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)

        UIView.animate(
            withDuration: 0.9,
            delay: 0,
            options: [.autoreverse, .repeat, .curveEaseInOut],
            animations: {
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        )
    }

    private func startRingRotation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * CGFloat.pi
        rotation.duration = 1.2
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)

        gradientLayer.add(rotation, forKey: "rotation")
    }

    private func startRingSweep() {
        let sweep = CABasicAnimation(keyPath: "strokeEnd")
        sweep.fromValue = 0.12
        sweep.toValue = 0.35
        sweep.duration = 0.7
        sweep.autoreverses = true
        sweep.repeatCount = .infinity
        sweep.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        ringLayer.add(sweep, forKey: "sweep")
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

// MARK: - UIWindow Helper
extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
