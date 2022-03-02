# Piano2DHands
Animated hands, visualizing piano fingering. A work in progress, part of a larger framework, dealing with
- harmonics
- metrics and dynamics
- bio-mechanics

HandModel turns note numbers into control points, animating hand motion. At present, each hand is one finger only, receiving only one pitch, moving only along the front edge of the keyboard, and as such a Proof of Concept. The model is a basis, integrating body and keyboard proportions, prepared for further developing the hand and the implementation of timestamped finger/note messages as the final goal of this module. Hands are schematic. However, they are shown in their natural, relaxed state, with zero lateral strain for all joints, and the hand at the optimal angle for the pitch (MIDI Note number).

The project wraps its two essential objects - HandHodel and HandShape - with a simple keyboard and body outline, horizontally scrollable. A DemoControlPanel allows hand sliding, independent motion and displaying the right hand path across the full 88-key range.

In the code, body and keyboard can be hidden, to show hands only.

Code documentation will follow. The 'larger framework' will require Pages for its full and proper presentation.

![image](https://user-images.githubusercontent.com/3308319/156286125-7defd33b-45d5-496e-aa5e-586a56dd7709.png)

![image](https://user-images.githubusercontent.com/3308319/156287321-e309dcf5-61dc-4f17-ad30-46dad6250f69.png)

