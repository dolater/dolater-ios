//
//  MotionRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import AudioToolbox
import CoreMotion

protocol MotionRepositoryProtocol: Actor {

}

final actor MotionRepositoryImpl: MotionRepositoryProtocol {
    private let motionManager: CMMotionManager = .init()
    private var vibrationTimer: Timer?

    func startMonitoringDeviceMotion() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        motionManager.accelerometerUpdateInterval = 1 / 60
        motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
            if let error {
                Logger.standard.error("\(error)")
                return
            }
            // TODO: -
        }
    }

    func stopMonitoringDeviceMotion() {
        guard motionManager.isDeviceMotionActive else {
            return
        }
        motionManager.stopDeviceMotionUpdates()
    }

    func startVibration() {
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

    func stopVibration() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
}
