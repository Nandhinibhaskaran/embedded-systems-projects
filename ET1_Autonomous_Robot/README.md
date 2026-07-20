# ET1 Autonomous Mobile Robot (Raspberry Pi)

An autonomous mobile robot developed using Raspberry Pi as part of the Master's program in Electrical Engineering and Embedded Systems at Hochschule Ravensburg-Weingarten.

The robot combines encoder-based motion control, ultrasonic obstacle detection, PWM motor driving, and a web-based remote control interface. Motion algorithms were implemented in Python while Node.js and WebSockets were used for browser-based communication.

---

## Features

- Autonomous obstacle avoidance using HC-SR04 ultrasonic sensor
- Closed-loop motion control using rotary encoders
- PWM-based DC motor control
- Automatic 90° left/right turning
- Dynamic speed correction using encoder feedback
- Forward and backward motion control
- Remote robot control through a web interface
- Real-time robot status updates using WebSockets

---

## Hardware

- Raspberry Pi
- ET1 Robot Platform
- HC-SR04 Ultrasonic Sensor
- DC Motors
- Rotary Encoders
- Motor Driver Board
- Battery Pack

---

## Software

- Python
- Raspberry Pi GPIO
- Node.js
- HTML
- JavaScript
- WebSockets

---

## System Architecture

Browser (HTML)

↓

Node.js Web Server

↓

Python Control Scripts

↓

GPIO Interface

↓

Motors • Encoders • Ultrasonic Sensor

---

## Software Architecture

The robot is controlled through three software layers:

• HTML frontend (Robot Controller webpage)

• Node.js server (Socket.IO communication)

• Python programs running on the Raspberry Pi for motor control, encoder feedback, ultrasonic sensing and autonomous navigation.

**Note:** The original university report labels the Node.js server code as *Python*. This is a documentation error—the server is implemented in JavaScript using Node.js.

## Motion Control

The robot continuously measures the distance to nearby obstacles using the HC-SR04 ultrasonic sensor.

When an obstacle is detected:

1. Stop the robot
2. Move backward
3. Randomly turn left or right
4. Continue autonomous navigation

Encoder feedback is used to:

- measure travelled distance
- perform accurate turning
- synchronize wheel speeds
- reduce drift during straight-line movement

---

## Technologies

- Raspberry Pi
- Python
- Node.js
- HTML
- JavaScript
- WebSockets
- PWM
- Rotary Encoders
- HC-SR04 Ultrasonic Sensor
- Embedded Linux

### Autonomous Obstacle Avoidance

The robot continuously measures the distance to nearby objects using an
HC-SR04 ultrasonic sensor. When an obstacle is detected within 20 cm, the
motors stop and the robot selects a random left or right turn. Rotary
encoder feedback is used to perform an approximately 90-degree rotation
before forward movement resumes.

---

## Project Image

![ET1 Robot](robot.jpg)
