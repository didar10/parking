//
//  ParkingHistoryVC.swift
//  Parking
//
//  Created by Erzhan Taipov on 06.06.2023.
//

import UIKit

class ParkingHistoryVC: UIViewController {
    let viewModel: ParkingHistoryViewModel
    
    init(viewModel: ParkingHistoryViewModel = ParkingHistoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callToViewModel()
    }
    
    private func callToViewModel() {
        viewModel.getHistory()
        viewModel.bindHistory = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ParkingHistoryVC: ViewControllerAppearanceProtocol {
    func setupUI() {
        configureViews()
        [titleLabel, tableView].forEach { subview in
            view.addSubview(subview)
        }
        setupConstraints()
        registerTableViewCells()
        setupTableView()
    }
    
    func configureViews() {
        view.backgroundColor = .white
        titleLabel.text = "История парковок"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func registerTableViewCells() {
        tableView.register(HistoryItemCell.self, forCellReuseIdentifier: HistoryItemCell.description())
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ParkingHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ParkingHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryItemCell.description(),
            for: indexPath) as! HistoryItemCell
        cell.generateCell(viewModel.history[indexPath.row])
        return cell
    }
}
