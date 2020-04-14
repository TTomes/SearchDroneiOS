//
//  WaypointMission.swift
//  SearchDrone
//
//  Created by Travis Tomer on 4/9/20.
//  Copyright © 2020 Travis Tomer. All rights reserved.
//

import UIKit
import DJIUXSDK
import DJISDK

class WaypointMission: DUXDefaultLayoutViewController {
    
    private var currentLocation: CLLocation?
    
    // Init Start Button
    @IBOutlet weak var startButtonPressed: UIButton!
    
    @IBOutlet weak var stopButtonPressed: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.contentViewController?.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.contentViewController?.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.contentViewController?.view.setNeedsDisplay()
        
        //Add button styling
        startButtonPressed.layer.cornerRadius = 20
        stopButtonPressed.layer.cornerRadius = 20
        
        //Initially hide stop button
        stopButtonPressed.isHidden = true
        
    }
    
    // Set default Gimbal stats
    func defaultGimbalAttackAttitude() -> DJIGimbalAttitudeAction? {
        let attitude = DJIGimbalAttitude(pitch: 30.0, roll: 0.0, yaw: 0.0)
        return DJIGimbalAttitudeAction(attitude: attitude)
    }
    
    
    
    // potential param: _ numWaypoints: Int
    // Waypoint mission - Gets called when the user wants to create a waypoint mission.
    func createWaypointMission() -> DJIWaypointMission? {
        
        //Fuction is being ran for some reason
//        guard let currentLocation = currentLocation else {
//            NSLog("Returned nil waypoint mission")
//            return DJIWaypointMission()
//
//        }
        
        guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) else {
            return nil
        }
        NSLog("droneLocationKey created")
        guard let droneLocationValue = DJISDKManager.keyManager()?.getValueFor(droneLocationKey) else {
            NSLog("Nil drone location found")
            return nil
        }
        NSLog("droneLocationValue created")

        let droneLocation = droneLocationValue.value as! CLLocation
        NSLog("\(droneLocation)")
        let droneCoordinates = droneLocation.coordinate
        NSLog("\(droneCoordinates)")
        
        // Create waypoint mission instance
        let mission = DJIMutableWaypointMission()
        
        // Set waypoint mission default characteristics
        mission.maxFlightSpeed = 15
        mission.autoFlightSpeed = 8
        mission.finishedAction = .goHome
        mission.headingMode = .auto
        mission.flightPathMode = .normal
        mission.rotateGimbalPitch = true
        mission.exitMissionOnRCSignalLost = true // Males the aircraft return home on lost RC signal
        mission.gotoFirstWaypointMode = .safely
        mission.repeatTimes = 1 // Can change this if the user wants continous flights of same area.
        
        //Create waypoints
        let waypoint = DJIWaypoint(coordinate: droneCoordinates)
        waypoint.altitude = 10
        
        let waypoint2 = DJIWaypoint(coordinate: CLLocationCoordinate2D(latitude: 29.704815, longitude: -95.858103))
        waypoint.altitude = 10
        
        //Add waypoints to the mission
        mission.add(waypoint)
        mission.add(waypoint2)
        NSLog("Waypoints added.")
        
        return mission
        
    }
    
    // Upload the mission to the Drone
    func uploadAndStartMission(mission: DJIWaypointMission) {
           guard let missionControl = DJISDKManager.missionControl() else { return }
    
           missionControl.waypointMissionOperator().load(mission)
           missionControl.waypointMissionOperator().uploadMission { [weak self] (error) in
               missionControl.waypointMissionOperator().addListener(toStarted: self, with: nil, andBlock: {})
           }
    
           missionControl.waypointMissionOperator().addListener(toUploadEvent: self, with: nil) { (event) in
    
               guard let progress = event.progress else {
                   return
               }
    
               print("progress: \(progress)")
    
               if progress.totalWaypointCount - 1 == progress.uploadedWaypointIndex, progress.isWaypointSummaryUploaded {
    
                   DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                       missionControl.waypointMissionOperator().startMission(completion: nil)
                   })
               }
           }
       }
    
    
    // Add button actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        NSLog("startButtonPressed") //Update Log for debugging
        
        // Create the Waypoint mission (return basic Waypoint Mission (empty mission)
        guard let waypointMission = createWaypointMission() else {
            NSLog("Empty Mission created")
            return
            
        }
        
        // Upload the mission to the drone
        self.uploadAndStartMission(mission: waypointMission)
        
        
        // Hide Start button
        startButtonPressed.isHidden = true
        // Dispaly stop button once mission is started (might need to move this to when its done updating
        stopButtonPressed.isHidden = false
        
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        NSLog("stopButtonPressed")
        
        
        //
        
        
        
    }
    
    
    
}













//OLD

//
//        guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) else {
//            return nil
//        }
//
//        guard let droneLocationValue = DJISDKManager.keyManager()?.getValueFor(droneLocationKey) else {
//            return nil
//        }
//
//        let droneLocation = droneLocationValue.value as! CLLocation
//        let droneCoordinates = droneLocation.coordinate
//
//        // If the drones coordinates are not valid return nil
//        if !CLLocationCoordinate2DIsValid(droneCoordinates) {
//            return nil
//        }
//
//        mission.pointOfInterest = droneCoordinates
//        let offset = 0.0000899322
//
//        // TODO: Loop to add waypoints ( or button on UI to add waypoints )
//
//        //Test hover mission at 10m.  Waypoint is at the drones current location.
//        let waypoint = DJIWaypoint(coordinate: droneLocation.coordinate)
//        waypoint.altitude = 10 //Altitude = 10m
//        waypoint.gimbalPitch = -35 //0 : looking directly ahead in front of drone. -90: looking straight down.
//        waypoint.actionRepeatTimes = 1
//
//
//        mission.add(waypoint) //Add the waypoint to the mission
//
//        // Return the created mission
//        return DJIWaypointMission(mission: mission)
