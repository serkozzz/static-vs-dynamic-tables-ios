//
//  StaticTableViewController.swift
//  StackView_vs_TableView
//
//  Created by Sergey Kozlov on 20.11.2024.
//

import UIKit
import Combine

class StaticTableViewController: UITableViewController {

    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet weak var airportModeSwitch: UISwitch!
    @IBOutlet weak var VPNSwitch: UISwitch!
    
    @IBOutlet weak var wifiStatus: UILabel!
    @IBOutlet weak var BluetoothStatus: UILabel!
    @IBOutlet weak var PersonalHotspotStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModelStub.shared.airplaneMode.sink { [weak self] isOn in
            self?.airportModeSwitch.isOn = isOn
        }.store(in: &cancellables)
        
        ModelStub.shared.vpn.sink { [weak self] isOn in
            self?.VPNSwitch.isOn = isOn
        }.store(in: &cancellables)
        
        ModelStub.shared.personalHotspot.sink { [weak self] status in
            self?.PersonalHotspotStatus.text = status ? "On" : "Off"
        }.store(in: &cancellables)
        
        ModelStub.shared.bluetooth.sink { [weak self] status in
            self?.BluetoothStatus.text = status ? "On" : "Off"
        }.store(in: &cancellables)
        
        ModelStub.shared.wifi.sink { [weak self] status in
            self?.wifiStatus.text = status
        }.store(in: &cancellables)
        
    }
    
    @IBAction func toggleAirplane(_ sender: Any) {
        ModelStub.shared.airplaneMode.value = airportModeSwitch.isOn
    }
    
    @IBAction func toggleVPN(_ sender: Any) {
        ModelStub.shared.vpn.value = VPNSwitch.isOn
    }
}
