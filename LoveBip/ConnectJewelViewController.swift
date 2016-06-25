//
//  ConnectJewelViewController.swift
//  LoveBip
//
//  Created by Marco Montalto on 16/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreBluetooth

var connectedBLEDevice: MBLMetaWear?

class ConnectJewelViewController: UIViewController, CBPeripheralManagerDelegate, UITableViewDelegate {
    
    @IBOutlet weak var lovebipBLETable: UITableView!
    @IBOutlet weak var loadingBLEDevices: NVActivityIndicatorView!
    var devices: [MBLMetaWear]?
    var myBTManager: CBPeripheralManager?
    
    override func viewDidLoad() {
         myBTManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    //BT Manager
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if let _ = myBTManager {
            if peripheral.state == CBPeripheralManagerState.PoweredOn {
                print("----BLE is powered on")
                
                loadingBLEDevices.startAnimation()
                MBLMetaWearManager.sharedManager().startScanForMetaWearsAllowDuplicates(false, handler: { (array: [AnyObject]?) -> Void in
                    self.devices = array as? [MBLMetaWear]
                    self.lovebipBLETable.reloadData()
                    self.loadingBLEDevices.stopAnimation()
                })
                
            } else if peripheral.state == CBPeripheralManagerState.PoweredOff {
                print("----BLE is off")
                connectedBLEDevice = nil
                loadingBLEDevices.stopAnimation()
            } else if peripheral.state == CBPeripheralManagerState.Unsupported {
                connectedBLEDevice = nil
                print("----BLE is unsupported")
                loadingBLEDevices.stopAnimation()
            } else if peripheral.state == CBPeripheralManagerState.Unauthorized {
                connectedBLEDevice = nil
                print("T----BLE is unauthorized")
                loadingBLEDevices.stopAnimation()
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = devices?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("loveBipCell", forIndexPath: indexPath)
        
        // Configure the cell...
        if let cur = devices?[indexPath.row] {
            let name = cell.viewWithTag(1) as! UILabel
            name.text = cur.name
            
            print(cur.name)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        MBLMetaWearManager.sharedManager().stopScanForMetaWears()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let selected = devices?[indexPath.row] {
            
            loadingBLEDevices.startAnimation()
            connectedBLEDevice = selected
            
            selected.connectWithTimeout(10, handler: { (error: NSError?) -> Void in
                self.loadingBLEDevices.stopAnimation()
                
                if let error = error {
                    print("BLE - Error connecting to ble device. \(error)")
                    
                } else {
                    selected.led?.flashLEDColorAsync(UIColor.greenColor(), withIntensity: 1.0)
                    
                    let alert = UIAlertController(title: "Confirm Device", message: "Do you see a blinking green LED on the jewel?", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                        selected.led?.setLEDOnAsync(false, withOptions: 1)
                        selected.disconnectWithHandler(nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Yes!", style: .Default, handler: { (action: UIAlertAction) -> Void in
                        selected.led?.setLEDOnAsync(false, withOptions: 1)
                        
                        selected.hapticBuzzer?.startHapticWithDutyCycleAsync(248, pulseWidth: 200, completion: {
                            print("Over")
                        })
                        
                        /*-let ancs: MBLEvent = (selected.ancs?.eventWithCategoryIds(MBLANCSCategoryID.Any))!
                        
                        ancs.programCommandsToRunOnEventAsync({
                            selected.led?.flashLEDColorAsync(UIColor.redColor(), withIntensity: 1)
                        })
                        self.setTimeout(25, block: {
                            print("Timeout is off")
                            if (ancs.isNotifying() == false) {
                                selected.led?.setLEDOnAsync(false, withOptions: 1)
                            }
                        })*/
                        
                        self.performSegueWithIdentifier("connectble_to_connectperson", sender: self)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func skipStepButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("connectble_to_connectperson", sender: self)
    }
    
}