//
//  ViewController.swift
//  DemoStereoMicInput
//
//  Created by Takayuki Sei on 2019/08/31.
//  Copyright © 2019 net.tionlow. All rights reserved.
//

import UIKit
import AVFoundation
import os

let logger = OSLog(subsystem: "net.tionlow.DemoStereoMicInput", category: "mycategory")
func logging(type: OSLogType, message: String) {
    os_log("%@", log: logger, type: type, message)
}

class ViewController: UIViewController {
    let engine = AVAudioEngine()
    let mixer = AVAudioMixerNode()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(nodes: nodes())
        
        engine.attach(mixer)
        engine.connect(engine.inputNode, to: mixer, format: engine.inputNode.outputFormat(forBus: 0))
        engine.connect(mixer, to: engine.mainMixerNode, format: mixer.outputFormat(forBus: 0))
        
        engine.prepare()
        do {
            try engine.start()
        } catch let error {
            logging(type: .error, message: error.localizedDescription)
        }
        
        print(nodes: nodes())
    }

    private func nodes() -> [AVAudioNode] {
        return [
            engine.inputNode,
            mixer,
            engine.mainMixerNode,
            engine.outputNode
        ]
    }

    private func print(nodes: [AVAudioNode]) {
        for node in nodes {
            logging(type: .debug, message: "node: \(node)")
            if node.numberOfInputs > 0 {
                logging(type: .debug, message: "input: \(node.inputFormat(forBus: 0))")
            }
            
            if node.numberOfOutputs > 0 {
                logging(type: .debug, message: "output: \(node.outputFormat(forBus: 0))")
            }
        }
    }
}

