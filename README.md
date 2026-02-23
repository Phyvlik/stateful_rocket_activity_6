# 🚀 Mission Control — Stateful Rocket Launch

An interactive launch controller designed to demonstrate dynamic UI behavior through state updates.  
This project simulates a rocket preparation panel where users control fuel levels, monitor launch readiness, and trigger a liftoff sequence.

---

## 🎯 Mission Objectives

- Manage changing values using a Stateful widget
- Update visual feedback in real time
- Enforce safety constraints on user actions
- Implement launch conditions with edge-case handling
- Enhance engagement with an animated success dialog

---

## 🧩 Features Implemented

### 🚦 Fuel Control System
- Slider adjusts launch fuel from **0 → 100**
- Ignite button increases fuel
- Decrement button lowers fuel safely
- Reset button aborts mission and returns to 0

### 🎨 Dynamic Status Feedback
Visual color changes based on fuel level:

| Fuel Value | Status Color |
|---|---|
| 0 | 🔴 Red |
| 1–50 | 🟠 Orange |
| 51–99 | 🟢 Green |
| 100 | 🚀 LIFTOFF |

---

### 🔒 Safety Logic & Edge Cases
- Fuel never drops below 0
- Fuel never exceeds 100
- Launch message replaces counter at max value
- Reset restores initial state
- Controls remain stable under rapid input

---

### 🏆 Bonus Mission — Launch Success Popup
When fuel first reaches **100**, a launch dialog appears automatically:

- Animated rocket liftoff visual
- “Launch Successful / LIFTOFF” confirmation
- Dismissible without interrupting the app
- Popup triggers only once per launch cycle

---

## 🧠 Key Concepts Demonstrated

- Managing mutable UI state
- Conditional rendering based on values
- UI feedback through dynamic styling
- Handling edge cases safely
- Dialog presentation with custom animation

---

## ▶️ How to Run

1. Clone the repository
2. Open the project in your IDE
3. Run on emulator or device
4. Interact with Mission Control to reach LIFTOFF 🚀

---

## 📸 Demonstration Checklist

Before submission, verify these states:

- Counter at **0** shows red
- Values **1–50** show orange
- Values **51–99** show green
- Value **100** shows “LIFTOFF!”
- Success popup appears at launch

---

## 👨‍🚀 Author

Vivek Patel  
GitHub: https://github.com/Phyvlik