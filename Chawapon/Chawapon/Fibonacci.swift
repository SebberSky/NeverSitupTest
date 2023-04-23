//
//  Fibonacci.swift
//  Chawapon
//
//  Created by chawapon.kiatpravee on 23/4/2566 BE.
//

import UIKit
class FibonacciViewController: UIViewController {
    @IBOutlet var resultLabel: UILabel!
    var firstValue = 0
    var secondValue = 1
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
        gesture.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(gesture)
        resultLabel.addGestureRecognizer(gesture)
        self.resultLabel.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(generateNumber), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    @objc func generateNumber() {
        if self.resultLabel.text?.count == 0 {
            self.resultLabel.text = "\(firstValue)"
            return
        }
        if self.resultLabel.text?.count == 1 {
            self.resultLabel.text! += ", \(secondValue)"
            return
        }
        let result = firstValue + secondValue
        self.resultLabel.text! += ", \(result)"
        firstValue = secondValue
        secondValue = result
    }
    
    @objc func tapToDismiss() {
        self.dismiss(animated: true)
    }
}
