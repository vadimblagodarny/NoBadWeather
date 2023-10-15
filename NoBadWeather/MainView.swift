//
//  MainView.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 29.09.2023.
//

import UIKit
import SnapKit
import CoreLocation

final class MainView: UIViewController {
    var viewModel: IMainViewModel!
    var weatherCurrent: WeatherCurrent?
    var weatherForecast: WeatherForecast?
    var locationName: String?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(MainViewCustomCell.self, forCellReuseIdentifier: Constants.Id.cellId)
        tv.allowsSelection = false
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private lazy var spinnerCurrent: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .large
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private lazy var spinnerForecast: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .medium
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        lbl.text = Constants.Strings.defaultLocation
        return lbl
    }()

    private lazy var temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * Constants.UISize.temperatureLabelFontScale)
        lbl.backgroundColor = Constants.Colors.temperatureLabelBGColor
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = Constants.UISize.globalCornerRadius
        lbl.text = "-" + Constants.Strings.tempSuffix
        return lbl
    }()

    private lazy var conditionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        lbl.text = Constants.Strings.defaultConditions
        return lbl
    }()

    private lazy var tempRangeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        lbl.text = Constants.Strings.defaultTempRange
        return lbl
    }()
    
    private lazy var locationCurrentButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Images.locationCurrentButtonImage, for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(locationCurrentTap), for: .touchUpInside)
        return button
    }()

    private lazy var locationSearchButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Images.locationSearchButtonImage, for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(locationSearchTap), for: .touchUpInside)
        return button
    }()

    init(viewModel: IMainViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.Other.coderError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        viewModel.weatherCurrentSignal.bind { [weak self] value in
            DispatchQueue.main.async {
                guard let self else { return }
                
                if let name = value?.name,
                   let temp = value?.main?.temp,
                   let conditions = value?.weather?.first?.weatherDescription,
                   let tempMin = value?.main?.tempMin,
                   let tempMax = value?.main?.tempMax
                {
                    self.locationLabel.text = self.locationName ?? name
                    self.temperatureLabel.text = Int(temp).description + Constants.Strings.tempSuffix
                    self.conditionsLabel.text = conditions
                    self.tempRangeLabel.text = Constants.Strings.tempPrefix + Int(tempMin).description + Constants.Strings.tempMiddle + Int(tempMax).description + Constants.Strings.tempSuffix
                }
                
                self.spinnerCurrent.stopAnimating()
            }
        }

        viewModel.weatherForecastSignal.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.spinnerForecast.stopAnimating()
                self?.weatherForecast = value
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(locationLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(locationCurrentButton)
        view.addSubview(locationSearchButton)
        view.addSubview(conditionsLabel)
        view.addSubview(tempRangeLabel)
        view.addSubview(tableView)
        view.addSubview(spinnerCurrent)
        view.addSubview(spinnerForecast)
    }
    
    private func setupConstraints() {
        spinnerCurrent.snp.makeConstraints { make in
            make.center.equalTo(temperatureLabel.snp.center)
        }
        
        spinnerForecast.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(Constants.UISize.standardOffset)
            make.trailing.equalToSuperview().inset(Constants.UISize.standardOffset)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(Constants.UISize.standardOffset)
            make.leading.equalToSuperview().offset(Constants.UISize.standardOffset)
            make.trailing.equalToSuperview().inset(Constants.UISize.standardOffset)
        }
        
        locationCurrentButton.snp.makeConstraints { make in
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.leading.equalTo(temperatureLabel.snp.leading).offset(Constants.UISize.standardOffset)
        }
        
        locationSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.trailing.equalTo(temperatureLabel.snp.trailing).inset(Constants.UISize.standardOffset)
        }
        
        conditionsLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(Constants.UISize.standardOffset)
            make.leading.equalToSuperview().offset(Constants.UISize.standardOffset)
            make.trailing.equalToSuperview().inset(Constants.UISize.standardOffset)
        }
        
        tempRangeLabel.snp.makeConstraints { make in
            make.top.equalTo(conditionsLabel.snp.bottom).offset(Constants.UISize.standardOffset)
            make.leading.equalToSuperview().offset(Constants.UISize.standardOffset)
            make.trailing.equalToSuperview().inset(Constants.UISize.standardOffset)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(tempRangeLabel.snp.bottom).offset(Constants.UISize.standardOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func weatherRequest(name: String?) {
        spinnerCurrent.startAnimating()
        spinnerForecast.startAnimating()
        viewModel.getWeather(name: name) { [weak self] clError in
            if let clError {
                self?.showErrorAlert(clError)
                self?.locationName = nil
                self?.spinnerCurrent.stopAnimating()
                self?.spinnerForecast.stopAnimating()
            }
        }
    }
    
    private func showErrorAlert(_ clError: CLError) {
        var message = String()
        
        switch clError.errorCode {
        case 2:
            message = Constants.Other.errorCLnetwork
        case 8:
            message = Constants.Other.errorCLnotfound
        default:
            message = Constants.Strings.errorAlertTitle
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Constants.Strings.errorAlertOk, style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func locationCurrentTap() {
        locationName = nil
        weatherRequest(name: locationName)
    }
        
    @objc private func locationSearchTap() {
        let alert = UIAlertController(title: Constants.Strings.locationSearchTitle, message: nil, preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields?.first
        textField?.autocapitalizationType = .words
        let next = UIAlertAction(title: Constants.Strings.locationSearchNext, style: .default) { [weak alert] (_) in
            self.locationName = alert?.textFields?.first?.text ?? String()
            self.weatherRequest(name: self.locationName)
        }
        let cancel = UIAlertAction(title: Constants.Strings.locationSearchCancel, style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(next)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherForecast?.list?.count ?? Int.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.cellId, for: indexPath) as? MainViewCustomCell
        cell?.configure(model: weatherForecast?.list?[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
