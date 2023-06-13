//
//  CustomDateTextField.swift
//  Parking
//
//  Created by Erzhan Taipov on 13.06.2023.
//


import UIKit

enum DateFormatType {
    case time
    case date
}

enum CustomDateTextFieldType {
    case profile
    case schedule(dateType: DateFormatType)
}

class CustomDateButtonView: UIView {
   
    lazy var timeTextField = CustomDateTextField(padding: 0, type: .schedule(dateType: type))
    
    let type: DateFormatType
    
    init(type: DateFormatType) {
        self.type = type
        super.init(frame: .zero)
        setUpViews()
        configureViews()
        setupDelegates()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [timeTextField].forEach { v in
            addSubview(v)
        }
    }
    
    func configureViews() {
//        switch type {
//        case .time:
//            leftImageView.image = ImageConstants.blueClock
//        case .date:
//            leftImageView.image = ImageConstants.blueSchedule
//        }
//        leftImageView.contentMode = .scaleAspectFit
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 14
    }

    func setupDelegates() {
        timeTextField.delegate = self
    }
    
    func setUpConstraints() {
        
        timeTextField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
        }
    }
}

extension CustomDateButtonView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.systemBlue.cgColor
    }
}


final class CustomDateTextField: UITextField {
    var date: Date {
        get { return (inputView as! UIDatePicker).date }
        set { (inputView as! UIDatePicker).date = newValue }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    private lazy var iso8601withFractionalSeconds: DateFormatter = {
         let formatter = DateFormatter()
         formatter.calendar = Calendar(identifier: .iso8601)
         formatter.timeZone = TimeZone(secondsFromGMT: 0)
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
         return formatter
     }()
    
    let padding : CGFloat
    
    let type: CustomDateTextFieldType
    
    var didChangeDate: ((String) -> Void)?
    var changeDateCallBack: ((Date) -> ())?
    
    init(padding : CGFloat, type: CustomDateTextFieldType = .profile) {
        self.padding = padding
        self.type = type
        super.init(frame : .zero)
        let datePicker = UIDatePicker()
        self.textColor = .black
        switch type {
        case .profile:
            self.attributedPlaceholder = NSAttributedString(
                string: "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: Date())
            datePicker.maximumDate = Date()
        case .schedule(dateType: let dateType):
            switch dateType {
            case .date:
                self.attributedPlaceholder = NSAttributedString(
                    string: "Выберите дату",
                    attributes: [
                        .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 14)
                ])
                datePicker.datePickerMode = .date
                datePicker.minimumDate = Date()
                datePicker.maximumDate = .none
            case .time:
                self.attributedPlaceholder = NSAttributedString(
                    string: "Выберите время",
                    attributes: [
                        .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 14)
                ])
                datePicker.datePickerMode = .time
            }
        }
      
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            
        }
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        inputView = datePicker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 48)
    }
 
    @objc func changeDate() {
        switch type {
        case .profile:
            let formattedDate = iso8601withFractionalSeconds.string(from: date)
            text = dateFormatter.string(from: date)
            didChangeDate?(formattedDate)
        case .schedule(let dateType):
            switch dateType {
            case .date:
                let formattedDate = iso8601withFractionalSeconds.string(from: date)
                text = dateFormatter.string(from: date)
                changeDateCallBack?(date)
                didChangeDate?(formattedDate)
            case .time:
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let formattedTime = timeFormatter.string(from: date)
                text = formattedTime
                changeDateCallBack?(date)
                didChangeDate?("\(formattedTime)")
            }
        }
    }
}
