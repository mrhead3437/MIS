//
//  ViewController.swift
//  CoreMotionTask
//
//  Created by Fatih Bas on 27.10.20.
//

import UIKit
import CoreData
import CoreMotion

class ViewController: UIViewController {
    // MARK: Outputs
    @IBOutlet weak var x_scaleOutput: UITextField!
    @IBOutlet weak var y_scaleOutput: UITextField!
    @IBOutlet weak var z_scaleOutput: UITextField!
    @IBOutlet weak var speedOutput: UITextField!
    
    @IBOutlet weak var xPBarOutput: UIProgressView!
    @IBOutlet weak var yPBarOutput: UIProgressView!
    @IBOutlet weak var zPBarOutput: UIProgressView!
    @IBOutlet weak var speedPBarOutput: UIProgressView!
    // MARK: Buttons
    @IBAction func startButton(_ sender: UIButton) {
        startAccele = true
    }
    @IBAction func stopButton(_ sender: UIButton) {
        startAccele = false
    }
    @IBAction func exportButton(_ sender: UIButton) {
        exportCSV()
    }
    // MARK: variables
    var motion = CMMotionManager()
    let g = 9.81
    var startAccele: Bool = false
    var coreData = CoreData()
    var dataOfAccele : [CoreData] = []
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerometer()
    }
    // MARK: functions
    func startAccelerometer(){
        motion.accelerometerUpdateInterval = 1.0 / 60.0;
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { [self] (data, error) in
            if startAccele, let myData = data {
                view.reloadInputViews()
                let pitch = myData.acceleration.x * g
                let roll = myData.acceleration.y * g
                let yaw = myData.acceleration.z * g
                x_scaleOutput.text = "x: \(Double(pitch).rounded(toPlaces: 2))"
                y_scaleOutput.text = "y: \(Double(roll).rounded(toPlaces: 2))"
                z_scaleOutput.text = "z: \(Double(yaw).rounded(toPlaces: 2))"
                xPBarOutput.setProgress(Float(abs(pitch * 10)), animated: true)
                yPBarOutput.setProgress(Float(abs(roll * 10)), animated: true)
                zPBarOutput.setProgress(Float(abs(yaw * 10)), animated: true)
                speedOutput.text = "\(calculateAccele(pitch, roll, yaw).rounded(toPlaces: 2)) m/s"
                speedPBarOutput.setProgress(Float(calculateAccele(pitch, roll, yaw) * 10), animated: true)
                coreData.pitch = String(pitch)
                coreData.roll = String(roll)
                coreData.yaw = String(yaw)
                coreData.a = String(calculateAccele(pitch, roll, yaw))
                dataOfAccele.append(coreData)
                }
        }
    }
    
    func calculateAccele(_ pitch: Double,_ roll: Double,_ yaw: Double) -> Double {
        let sum = sqrt((pitch * pitch) + (roll * roll) + (yaw * yaw))
        let result = abs(sum)
        return result
    }
    
    func createFileName() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "DataOfAccele\(hour).\(minutes).csv"
    }
    
    func exportCSV() {
        let fileName = createFileName()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let url = URL(fileURLWithPath: path).appendingPathComponent(fileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        //CSV Fields
        csvWriter?.writeField("x")
        csvWriter?.writeField("y")
        csvWriter?.writeField("z")
        csvWriter?.writeField("a")
        csvWriter?.finishLine()
        //array of data
        for (elements) in dataOfAccele.enumerated() {
            csvWriter?.writeField(elements.element.pitch)
            csvWriter?.writeField(elements.element.roll)
            csvWriter?.writeField(elements.element.yaw)
            csvWriter?.writeField(elements.element.a)
            csvWriter?.finishLine()
        }
        
        csvWriter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do {
            try buffer.write(to: url)
            alert(message: "CSV-Datei erstellt!")
        }catch{
            alert(message: "Es gab ein Problem!")
        }
    }
    
    func alert(message: String) {
        let alertMessage = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in}
            
            alertMessage.addAction(action1);
            
            self.present(alertMessage, animated: true, completion: nil)
        }
    
}
    // MARK: extensions
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

