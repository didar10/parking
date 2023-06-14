//
//  PaymentLoadingView.swift
//  Parking
//
//  Created by Erzhan Taipov on 14.06.2023.
//

import UIKit

final class PaymentLoadingView: BaseUIView {
    let centerContainerView = UIView()
    let spinningCircularView = CustomSpinningCircularView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), type: .big)
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    lazy var labelStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
    
    override func configureViews() {
        super.configureViews()
        
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "Ожидаем оплату"
        titleLabel.textColor = .black
        
        subTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subTitleLabel.text = "Это может занять несколько секунд"
        subTitleLabel.textColor = .gray

        [titleLabel, subTitleLabel].forEach { label in
            label.numberOfLines = 0
            label.textAlignment = .center
        }
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
    }
    
    override func setupViews() {
        super.setupViews()
        [centerContainerView, labelStackView].forEach {
            addSubview($0)
        }
        centerContainerView.addSubview(spinningCircularView)
        spinningCircularView.animate()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        centerContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview()
        }

        
        spinningCircularView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        labelStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(centerContainerView.safeAreaLayoutGuide.snp.bottom).inset(-40)
        }
    }
}

enum SpinnerType {
    case big
    case medium
}

class CustomSpinningCircularView: UIView {
    let type: SpinnerType
    let spinnningCircle = CAShapeLayer()

    init(frame: CGRect, type: SpinnerType) {
        self.type = type
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        let smallBorderShape = CAShapeLayer()
        let bigBorderShape = CAShapeLayer()
        
        var smallBorderPathRadius: CGFloat = 0.0
        var bigBorderPathRadius: CGFloat = 0.0
        
        switch type {
        case .big:
            smallBorderPathRadius = 92
            bigBorderPathRadius = 107
        case .medium:
            smallBorderPathRadius = 48
            bigBorderPathRadius = 56
        }
        
        let smallBorderPath = UIBezierPath(
            arcCenter: center,
            radius: smallBorderPathRadius,
            startAngle: -(.pi/2),
            endAngle: .pi*2,
            clockwise: true)
        let bigBorderPath = UIBezierPath(
            arcCenter: center,
            radius: bigBorderPathRadius,
            startAngle: -(.pi/2),
            endAngle: .pi*2,
            clockwise: true)
        
        smallBorderShape.path = smallBorderPath.cgPath
        smallBorderShape.fillColor = UIColor.white.cgColor
        smallBorderShape.strokeColor = UIColor.systemBlue.cgColor
        smallBorderShape.lineWidth = 2
        layer.addSublayer(smallBorderShape)

        bigBorderShape.path = bigBorderPath.cgPath
        bigBorderShape.fillColor = UIColor.clear.cgColor
        bigBorderShape.strokeColor = UIColor.systemBlue.cgColor
        bigBorderShape.lineWidth = 2
        layer.addSublayer(bigBorderShape)
        
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinnningCircle.path = circularPath.cgPath
        spinnningCircle.fillColor = UIColor.clear.cgColor
        spinnningCircle.strokeColor = UIColor.systemBlue.cgColor
      
        spinnningCircle.strokeEnd = 0.5
        spinnningCircle.lineCap = .round
        
        switch type {
        case .big:
            spinnningCircle.lineWidth = 15
        case .medium:
            spinnningCircle.lineWidth = 9
        }
        
        self.layer.addSublayer(spinnningCircle)
    }
    
    func animate() {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear) {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { completed in
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear) {
                self.transform = CGAffineTransform(rotationAngle: 0)
            } completion: { completed in
                self.animate()
            }
        }
    }
}
