# ET1 Autonomous Robot (Raspberry Pi)

## Overview

This project implements an autonomous mobile robot using a Raspberry Pi. The robot combines ultrasonic obstacle detection, encoder-based motion control, PWM motor control, and a web-based interface for autonomous navigation.

The project was developed as part of the Master's program in Electrical Engineering and Embedded Systems at Hochschule Ravensburg-Weingarten.

---

## Features

- Autonomous obstacle avoidance
- Encoder-based closed-loop motion control
- PWM motor control
- Ultrasonic distance measurement
- Web-based robot control
- Live robot status monitoring

---

## Hardware

- Raspberry Pi
- HC-SR04 Ultrasonic Sensor
- Rotary Encoders
- DC Motors
- Motor Driver
- ET1 Robot Platform
- Battery Pack

---

## Software

- Python
- Node.js
- HTML
- JavaScript
- Raspberry Pi GPIO

---

## Project Modules

### Obstacle Detection

The HC-SR04 ultrasonic sensor continuously measures the distance to nearby obstacles. When an obstacle is detected, the robot automatically changes its direction.

### Encoder Motion Control

Rotary encoders provide wheel feedback for accurate movement, speed estimation, and precise robot positioning.

### Autonomous Navigation

The robot performs the following sequence:

1. Move forward
2. Detect obstacle
3. Stop
4. Move backward
5. Turn left or right
6. Continue moving

### Web Interface

The robot can also be controlled remotely using a browser through a simple Node.js web interface.

---

## Skills Demonstrated

- Embedded Systems
- Raspberry Pi
- Python
- Embedded Linux
- Robotics
- GPIO Programming
- PWM Motor Control
- Ultrasonic Sensors
- Rotary Encoders
- Closed-Loop Control
- Node.js

---

## Outcome

This project demonstrates embedded software development, robotics, sensor integration, autonomous navigation, and hardware-software interaction.
