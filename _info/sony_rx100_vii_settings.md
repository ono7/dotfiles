# settings

https://www.youtube.com/watch?v=FrxIhVtWibM

1. Auto preview 2 seconds
2. manual mode
3. setup touch pad to be usable to change focus point when using EVF
   setup 3 -> touchpanel/pad -> touchpanel + pad (set to right half)

1: Shoot RAW + JPG @ 2:45
2: Flexible Spot AF @ 4:45
3: Creative Style = Neutral @ 7:07
4: Shoot video in 4K @ 8:30
5: Remap ISO @ 9:45
6: Turn off the beep @ 11:20
7: Set video manual mode @ 12:25
8: Rule of thirds grid @ 13:15
9: Set auto review on @ 13:50
10: Touch AF + Touch Pad AF @ 14:40 ( or touch tracking ) camara settings 2
11: Set Copyright @ 16:30
12: Set File Name Prefix @ 17:50

## Theory

The Sony RX100 VII is a high-performance "pocket alpha" with a sophisticated AF system. To optimize it, you must move beyond the restrictive "Auto" modes and configure the interface to handle its primary bottleneck: the lack of physical dials compared to larger bodies.

## Evidence

- **Sensor:** 1-inch stacked CMOS. While powerful, it produces more noise than Full Frame above ISO 1600.
- **AF System:** 357 phase-detection points with Real-time Tracking and Eye AF (Human/Animal).
- **Controls:** Limited physical buttons; relies heavily on the **Control Ring** and **Fn Menu**.

## Fix

Configure these specific settings to maximize the camera's speed and image quality:

### 1. Image Quality & Focus

- **File Format:** Set to **RAW** or **RAW+JPEG**. The 1-inch sensor needs RAW flexibility for highlight recovery in Lightroom.
- **Focus Mode:** Use **AF-C** (Continuous). Combined with the VII's Real-time Tracking, this is the camera's strongest feature.
- **Focus Area:** Set to **Tracking: Flexible Spot (M)**. This allows you to "stick" the focus to a subject by half-pressing the shutter.
- **Face/Eye AF:** Enable **Face/Eye Priority in AF** and set **Subject Detection** to Human (or Animal for pets).

### 2. Custom Buttons (Menu -> Setup -> Custom Key)

The default buttons are inefficient. Reassign them as follows:

- **Control Ring (Lens):** Set to **Exposure Compensation** or **ISO**. This gives you tactile exposure control.
- **C Button (Custom):** Set to **Eye AF** or **Focus Magnifier** (for manual focus).
- **Center Button:** Set to **Focus Standard**. This allows you to reset your focus point to the center instantly.
- **Fn Menu:** Remove rarely used items (like Creative Style) and add **Drive Mode**, **Silent Shooting**, and **ISO AUTO Min. SS**.

### 3. Exposure Management

- **ISO AUTO Min. SS:** Set this to **1/125** or **1/250**. This prevents the camera from dropping the shutter speed too low and causing motion blur, which is common in "Program" mode.
- **Exposure Step:** Ensure it is set to **0.3EV** for fine control.

### 4. General Performance

- **Touch Operation:** Turn **ON**. Use "Touch Tracking" to select subjects on the LCD.
- **Silent Shooting:** Enable this if you want to use the electronic shutter (up to 20fps) without the "click."
- **Disp. Quality:** Set to **High** (Note: This consumes more battery but makes the EVF much sharper).

## Tips

- **Battery Life:** The RX100 VII has poor battery life. Enable **Airplane Mode** to disable Wi-Fi/Bluetooth when not in use to save power.
- **Recovery:** If you lose your "perfect" setup, use the **Memory Recall (MR)** slots on the mode dial to save specific configurations for "Street," "Landscape," or "Video."

## power

The Sony RX100 VII uses the **NP-BX1** battery, which has a limited capacity of **1240mAh**. Battery depletion is accelerated by the high-performance BIONZ X processor required for Real-time Tracking AF and high-speed RAW data throughput. Shooting in RAW does not inherently consume significantly more power than JPEG, but the associated preview processing, sensor readout for AF, and EVF/LCD refresh rates are the primary draws.

## Evidence: Verifiable Facts

- **CIPA Rating:** \* **260 shots** using the LCD monitor.
  - **240 shots** using the Electronic Viewfinder (EVF).
  - **310 shots** if "Auto Monitor Off" is set to 2 seconds.
- **Power Draw:** The EVF actually consumes more power than the LCD due to its higher pixel density and refresh rate.
- **RAW Impact:** Writing RAW files takes longer than JPEGs; if using a slow SD card (Class 10/U1), the processor remains active longer to clear the buffer, increasing power consumption per shot.

---

## Fix: Optimal Efficiency Settings

To maximize shots while shooting RAW, apply these specific configuration changes:

### 1. Display & Power Management

- **Auto Monitor OFF:** Set to **2 Sec**. This is the single most effective way to reach ~310+ shots.
- **Power Saving Start Time:** Set to **1 Min**.
- **Monitor Brightness:** Set to **Manual** (avoid "Sunny Weather" mode unless necessary).
- **Finder/Monitor:** Set to **Manual (Monitor)**. The "Auto" sensor often triggers the EVF unnecessarily, wasting power.

### 2. Connectivity & Performance

- **Airplane Mode:** Set to **ON**. Disabling Wi-Fi, Bluetooth, and NFC prevents constant background polling.
- **Pre-AF:** Set to **OFF**. This prevents the lens from hunting for focus before you even half-press the shutter.
- **High ISO NR:** (Irrelevant for RAW files, but keeping it OFF reduces overhead for the embedded JPEG preview).

### 3. Hardware Optimization

- **SD Card:** Use a **UHS-I U3 (V30)** or faster card. Faster write speeds allow the camera to enter a low-power state sooner after a burst.
- **Avoid the EVF:** Use the LCD for framing when possible; the EVF's higher power requirement reduces total shot count by ~10%.

---

## Tips: Prevention & Workflow

- **Carry Spares:** Given the NP-BX1 size, no amount of setting optimization replaces a second battery for a full day of shooting.
- **USB Charging:** The RX100 VII supports charging via Micro-USB. Use a power bank to top off the battery during transit or breaks.
- **External Power:** For stationary shooting (timelapses), use a "Dummy Battery" (AC-LS5 adapter) or keep it plugged into a high-output USB source.
