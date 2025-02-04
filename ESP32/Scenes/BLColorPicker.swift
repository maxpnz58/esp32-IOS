//
//  BLColorPicker.swift
//  ESP32
//
//  Created by Max on 04.02.2025.
//

import UIKit
import CoreBluetooth

class BLColorPicker: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager!
    var esp32Peripheral: CBPeripheral?
    let serviceUUID = CBUUID(string: "12345678-1234-5678-1234-56789abcdef0")
    let characteristicUUID = CBUUID(string: "abcd1234-5678-1234-5678-abcdef123456")
    var writeCharacteristic: CBCharacteristic?

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        setupUI()
    }

    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth включен, сканируем...")
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            print("Bluetooth отключен")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Найдено устройство: \(peripheral.name ?? "ESP32")")
        esp32Peripheral = peripheral
        esp32Peripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Подключено к \(peripheral.name ?? "ESP32")")
        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == serviceUUID {
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == characteristicUUID {
            writeCharacteristic = characteristic
            print("Готово к отправке данных!")
        }
    }

    // MARK: - Отправка цвета на ESP32
    func sendColor(red: UInt8, green: UInt8, blue: UInt8) {
        guard let characteristic = writeCharacteristic else { return }
        let data = Data([red, green, blue])
        esp32Peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }

    // MARK: - UI (Color Picker)
    func setupUI() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        let button = UIButton(type: .system)
        button.setTitle("Выбрать цвет", for: .normal)
        button.addTarget(self, action: #selector(openColorPicker), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        view.addSubview(button)
    }

    @objc func openColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension BLColorPicker: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        let components = color.cgColor.components ?? [0, 0, 0, 1]
        let red = UInt8(components[0] * 255)
        let green = UInt8(components[1] * 255)
        let blue = UInt8(components[2] * 255)
        sendColor(red: red, green: green, blue: blue)
    }
}
