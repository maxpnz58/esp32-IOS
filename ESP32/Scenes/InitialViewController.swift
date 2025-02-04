//
//  InitialViewController.swift
//  ESP32
//
//  Created by Max on 04.02.2025.
//

import UIKit

class InitialViewController: UIViewController {
    
    
    let BLbutton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.setTitle("BLUETOOTH", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let WIFIbutton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .darkGray
        button.setTitle("WI - FI", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.text = "Как работать будем?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupTarget()
    }
}

extension InitialViewController {
    func setupUI() {
        view.addSubview(destinationLabel)
        view.addSubview(BLbutton)
        view.addSubview(WIFIbutton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            destinationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            destinationLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -25),
            
            BLbutton.widthAnchor.constraint(equalToConstant: 200),
            BLbutton.heightAnchor.constraint(equalToConstant: 80),
            BLbutton.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 40),
            BLbutton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            
            WIFIbutton.widthAnchor.constraint(equalToConstant: 200),
            WIFIbutton.heightAnchor.constraint(equalToConstant: 80),
            WIFIbutton.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 40),
            WIFIbutton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
        ])
    }
    
    func setupTarget() {
        BLbutton.addTarget(self, action: #selector(BLbuttonDidPressed), for: .touchUpInside)
        WIFIbutton.addTarget(self, action: #selector(WIFIbuttonDidPressed), for: .touchUpInside)
    }
    
    @objc func BLbuttonDidPressed() {
        let colorPickerVC = BLColorPicker()
        navigationController?.pushViewController(colorPickerVC, animated: true)
    }
    
    @objc func WIFIbuttonDidPressed() {
        let colorPickerVC = WIFIColorPicker()
        navigationController?.pushViewController(colorPickerVC, animated: true)
    }
}




