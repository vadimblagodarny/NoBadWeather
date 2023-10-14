//
//  MainViewCustomCell.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 07.10.2023.
//

import UIKit
import SnapKit

final class MainViewCustomCell: UITableViewCell {

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        label.numberOfLines = Constants.Other.numberOfLines
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
        return label
    }()

    private lazy var conditionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = Constants.Other.numberOfLines
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.Other.coderError)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        timeLabel.text = nil
        temperatureLabel.text = nil
        conditionsLabel.text = nil
    }
    
    private func setupCell() {
        addSubview(timeLabel)
        addSubview(temperatureLabel)
        addSubview(conditionsLabel)
    }
    
    private func setupConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.UISize.standardOffset)
            make.trailing.equalTo(temperatureLabel.snp.leading).inset(Constants.UISize.standardOffset)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        conditionsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(temperatureLabel.snp.trailing).offset(Constants.UISize.standardOffset)
            make.trailing.equalToSuperview().inset(Constants.UISize.standardOffset)
        }
    }

    func configure(model: List?) {
        if let unixTime = model?.dt,
           let temp = model?.main?.temp,
           let conditions = model?.weather?.first?.weatherDescription
        {
            let unixTimeConverted = Date(timeIntervalSince1970: TimeInterval(unixTime))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.Strings.customCellDateFormat
            let time = dateFormatter.string(from: unixTimeConverted)
            
            timeLabel.text = time
            temperatureLabel.text = Int(temp).description + Constants.Strings.tempSuffix
            conditionsLabel.text = conditions
        }
    }
}
