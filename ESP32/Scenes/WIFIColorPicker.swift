//
//  WIFIColorPicker.swift
//  ESP32
//
//  Created by Max on 04.02.2025.
//

import UIKit
import Alamofire

class WIFIColorPicker: UIViewController, UIColorPickerViewControllerDelegate {
    
    let esp32URL = "http://192.168.4.1/color"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем кнопку для открытия Color Picker
        let button = UIButton(type: .system)
        button.setTitle("Выбрать цвет", for: .normal)
        button.addTarget(self, action: #selector(openColorPicker), for: .touchUpInside)
        
        // Настраиваем положение кнопки
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func openColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.backgroundColor ?? .white
        present(colorPicker, animated: true, completion: nil)
    }
    
    // Делегат метода выбора цвета
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        
        // Разбираем UIColor на компоненты (RGBA)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        selectedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Преобразуем в диапазон 0-255
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        // Можно добавить расчет яркости (например, среднее значение)
        let brightness = (r + g + b) / 3

        let params: [String: Any] = [
            "r": g,
            "g": r,
            "b": b,
            "brightness": brightness
        ]
        
        AF.request(esp32URL, method: .get, parameters: params)
            .response { response in
                if let data = response.data, let status = String(data: data, encoding: .utf8) {
                    print("ESP32 ответил: \(status)")
                } else {
                    print("Ошибка соединения")
                }
            }
        
        // Применяем цвет к фону
        view.backgroundColor = selectedColor
    }

    
    // Закрытие Color Picker
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
