//
//  TimeAlertVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 13.06.2023.
//

import UIKit

final class TimeAlertVC: UIViewController, DismissViewControllerProtocol {
    let backgroundView = UIView()
    let fromLabel = UILabel()
    let titleLabel = UILabel()
    let toLabel = UILabel()
//    let fromTextField = CustomDateTextField(padding: 12, type: .schedule(dateType: .time))
//    let toTextField = CustomDateTextField(padding: 12, type: .schedule(dateType: .time))
    let fromTextField = CustomDateButtonView(type: .time)
    let toTextField = CustomDateButtonView(type: .time)
    var customView = UIView()
    var height: CGFloat
    lazy var stackView = UIStackView(arrangedSubviews: [fromLabel, fromTextField, toLabel, toTextField])
    let continueButton = CustomButton(title: "Продолжить")
    var didDismiss: (() -> ())?

    init(height: CGFloat) {
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func didTapContinueButton(_ sender: UIButton) {
        self.dismissByFade()
        didDismiss?()
    }
}

extension TimeAlertVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(customView)
        customView.addSubview(titleLabel)
        customView.addSubview(stackView)
        customView.addSubview(continueButton)
        configureViews()
        setupConstraints()
        addActionsForUIElements()
    }
    
    func configureViews() {
        [fromLabel, toLabel].forEach { l in
            l.textColor = .black
            l.font = UIFont.systemFont(ofSize: 12)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = "Выберите время"
        fromLabel.text = "От"
        toLabel.text = "До"
        view.backgroundColor = .clear
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.6
        customView.backgroundColor = .white
        customView.layer.cornerRadius = 14
        stackView.axis = .vertical
        stackView.spacing = 12
    }
    
    func addActionsForUIElements() {
        if backgroundView.isUserInteractionEnabled {
            backgroundView.onTapped { [unowned self] in
                dismissByFade()
            }
        }
        continueButton.addTarget(self, action: #selector(didTapContinueButton(_:)), for: .touchUpInside)
    }
    
    func dismissViewController(completion: @escaping () -> ()) {
        dismissByFade()
        completion()
    }

    
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        customView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        [fromTextField, toTextField].forEach { t in
            t.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
//            make.height.equalTo(80)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

protocol DismissViewControllerProtocol: AnyObject {
    func dismissViewController(completion: @escaping () -> ())
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}


extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
    
    static func -(recent: Date, previous: Date) -> (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let year = Calendar.current.dateComponents([.year], from: previous, to: recent).year
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
    
    func getDate() -> String? {
        var finalDate: String?
        
        let formatFirst = DateFormatter()
        formatFirst.timeZone = TimeZone(secondsFromGMT: 0)
        formatFirst.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        finalDate = formatFirst.string(from: self)
        return finalDate
    }
    
    func getFormattedData(getDateFormat: String) -> String {
        var finalDate = ""
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = getDateFormat
        finalDate = dateFormatterPrint.string(from: self)
        return finalDate
    }
}
