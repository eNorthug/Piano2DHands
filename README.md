# Piano2DHands
Animated hands, visualizing piano fingering. A work in progress, as part of a larger framework, integrating
- harmonics
- metrics and dynamics
- bio-mechanics

## Purpose
HandShape will typically be an overlay for the piano keyboard, their data and behaviour integrated.

HandModel turns note numbers into hand control points. HandShape draws a 'skeletal axis' path, elbow to finger tip. Hand motion is animatable. At present, each hand is one finger and one pitch only, with motion restricted to the keyboard front edge. The model is a first step, a body/keyboard integration, prepared for further developing the hand and the implementation of timestamped finger messages. Hands are schematic. However, they are shown in their natural, relaxed state, with zero lateral strain for all joints, and the hand at the optimal angle for the pitch (MIDI Note number).


https://user-images.githubusercontent.com/3308319/156288466-5775cb22-4793-44b3-bf7c-cbe4e66c68a5.mp4

The project wraps its two essential objects - HandHodel and HandShape - with a simple keyboard and body outline, all horizontally scrollable. A DemoControlPanel allows for hand sliding, independent hand motion or the right hand positioned across the full 88-key range. The core view - HandPath - is wrapped with demo views, supported by KeyboardData and HandModel.

[Piano2DHandsViews.pdf](https://github.com/eNorthug/Piano2DHands/files/8166499/Piano2DHandsViews.pdf)
