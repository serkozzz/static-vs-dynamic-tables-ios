//
//  Cells.swift
//  StackView_vs_TableView
//
//  Created by Sergey Kozlov on 19.11.2024.
//

import UIKit
import Combine

class BaseCell: UITableViewCell
{
    var action: (() -> Void)?
    
    func configure(text: String, image: UIImage) {
        var contentConf = defaultContentConfiguration()
        contentConf.text = text
        contentConf.image = image
        contentConfiguration = contentConf
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        action?()
    }
}


class ToogleCell: BaseCell {

    var toggle: UISwitch = UISwitch()
    static var reusableID = "ToogleCell"
    
    private var cancellables: Set<AnyCancellable> = []
    
    @objc func switchValueChanged(_ sender: UISwitch) {
//        modelSubject?.send(sender.isOn)
//        if sender.isOn {
//            print("switch enabled")
//        } else {
//            print("switch disabled")
//        }
    }
        
    
    func configure(with subject: CurrentValueSubject<Bool, Never>, text: String, image: UIImage) {
        super.configure(text: text, image: image)
        
        toggle = UISwitch()
        toggle.isOn = false
        toggle.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        accessoryView = toggle
        // Подписываемся на изменения модели и обновляем `UISwitch`
        subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOn in
                self?.toggle.isOn = isOn
            }
            .store(in: &cancellables)
    }
}


class NavigationCell: BaseCell {

    static var reusableID = "NavigationCell"
    private var cancellables: Set<AnyCancellable> = []
    private var rightAccessoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(text: String, image: UIImage, secondaryNamePublisher: AnyPublisher<String, Never>?) {
        super.configure(text: text, image: image)
        accessoryType = .disclosureIndicator
        
        secondaryNamePublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if var contentConf = self?.contentConfiguration as? UIListContentConfiguration {
                    contentConf.secondaryText = value
                    self?.contentConfiguration = contentConf
                }
            }
            .store(in: &cancellables)

    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//    }
}
