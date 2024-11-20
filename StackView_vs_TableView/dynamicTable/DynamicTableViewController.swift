//
//  DynamicTableViewController.swift
//  StackView_vs_TableView
//
//  Created by Sergey Kozlov on 19.11.2024.
//

import UIKit
import SafariServices
import Combine

struct Category {
    let name: String
    let items: [Item]
}

struct Item {
    var name: String
    var secondaryNamePublisher: AnyPublisher<String, Never>?
    var image: UIImage
    var actionType: ActionType
}

enum ActionType {
    case navigation(() -> UIViewController)
    case toggle(CurrentValueSubject<Bool, Never>)
    
    func execute(from vc: UIViewController) {
        switch self {
        case .navigation(let createVCMethod):
            vc.navigationController?.pushViewController(createVCMethod(), animated: true)
        case .toggle(let subject):
            subject.send(!subject.value)
        }
    }
}

var categories: [Category] = [
    Category(name: "", items: [
        Item(name: "Airplane mode", 
             image: UIImage(named: "star")!,
             actionType: .toggle(ModelStub.shared.airplaneMode)),
        
        Item(name: "Wi-Fi", secondaryNamePublisher: ModelStub.shared.wifi.eraseToAnyPublisher(), image: UIImage(named: "star")!, actionType: .navigation(AboutViewController.create)),
        
        Item(name: "Bluetooth",
             secondaryNamePublisher:  ModelStub.shared.bluetooth.map { $0 ? "True" : "False" }.eraseToAnyPublisher(),
             image: UIImage(named: "star")!,
             actionType: .navigation(AboutViewController.create)),
        
        Item(name: "Mobile Data",  
             image: UIImage(named: "star")!,
             actionType: .navigation(AboutViewController.create)),
    
        Item(name: "Personal Hotspot", 
             secondaryNamePublisher:  ModelStub.shared.bluetooth.map { $0 ? "True" : "False" }.eraseToAnyPublisher(),
             image: UIImage(named: "star")!,
             actionType: .navigation(AboutViewController.create)),
        
        Item(name: "VPN", 
             image: UIImage(named: "star")!,
             actionType: .toggle(ModelStub.shared.vpn)),
    ]),
    
    Category(name: "", items: [
        Item(name: "Notifications", image: UIImage(named: "star")!, actionType: .navigation(AboutViewController.create)),
        Item(name: "Sounds & Haptics", image: UIImage(named: "star")!, actionType: .navigation(AboutViewController.create)),
        Item(name: "Do Not Disturb", image: UIImage(named: "star")!, actionType: .navigation(AboutViewController.create)),
        Item(name: "Screen Time", image: UIImage(named: "star")!, actionType: .navigation(AboutViewController.create))
    ])
]


class DynamicTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ToogleCell.self, forCellReuseIdentifier: ToogleCell.reusableID)
        tableView.register(NavigationCell.self, forCellReuseIdentifier: NavigationCell.reusableID)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = categories[indexPath.section].items[indexPath.item]
        
        switch item.actionType {
        case .navigation(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCell.reusableID, for: indexPath) as! NavigationCell

            cell.configure(text: item.name, image: item.image, secondaryNamePublisher: item.secondaryNamePublisher)
            return cell
        case .toggle(let subject):
            let cell = tableView.dequeueReusableCell(withIdentifier: ToogleCell.reusableID, for: indexPath) as! ToogleCell
            cell.configure(with: subject, text: item.name, image: item.image)
            return cell
        }
        
    }
    
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Airplane Mode Enabled")
        } else {
            print("Airplane Mode Disabled")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = categories[indexPath.section].items[indexPath.item]
        item.actionType.execute(from: self)
    }
}




// MARK: - DynamicTableViewController (UI Customization)
extension DynamicTableViewController {
    
    // Настройка высоты хедера секции
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    

    // Настройка внешнего вида хедера секции
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            var cfg = header.defaultContentConfiguration()
            cfg.axesPreservingSuperviewLayoutMargins = []
            cfg.directionalLayoutMargins = .zero
            cfg.text = categories[section].name
            header.contentConfiguration = cfg
        }
    }
    
    // Настройка внешнего вида ячеек перед их отображением
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .green
        if var contentConf = cell.contentConfiguration as? UIListContentConfiguration {
            contentConf.axesPreservingSuperviewLayoutMargins = []
            contentConf.directionalLayoutMargins = .zero
            cell.contentConfiguration = contentConf
        }
    }
}




#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "DynamicTableViewController")

    return vc
}
