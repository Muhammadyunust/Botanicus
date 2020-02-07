//
//  MainVC.swift
//  WhatFlower
//
//  Created by Mukhammadyunus on 2/7/20.
//  Copyright © 2020 Shakhzodbek Azizov. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func botanicusPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "BotanicusVC") as! BotanicusVC
            navigationController?.pushViewController(vc, animated: true)
        }
    
    
    @IBAction func plantIdentifyPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func userManualPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ManualVC") as! ManualVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func playgamePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PlayGameVC") as! PlayGameVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
