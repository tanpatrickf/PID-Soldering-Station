# TEMPERATURE CONTROLLED SOLDERING STATION
---

## OBJECTIVES

- To apply all concepts learned from feedback and control systems
- To build the application for temperature controlled soldering station


## MATERIALS

- Arduino Uno
- 50W Soldering Iron (Must have type-K thermocouple)


## DESCRIPTION

Soldering iron is a tool used for joining metal elements by melting a fusible metal alloy. It is used primarily for soldering electronic components on a printed circuit board (PCB). However, some electronics components, especially integrated circuits and mosfets, have soldering temperature limit that could damage the part when not followed properly. Thus, a temperature controller for such case is ideal to ensure that the soldering iron does not exceed the peak temperature rating indicated in datasheets. An on-off controller in this scenario would be undesirable as temperature could overshoot to the set limit. Thus a closed-loop control system must be incorporated.
This prototype will monitor the current operating temperature of the soldering iron using a positive temperature coefficient (PTC) thermistor. The data will then be processed using a Closed Loop Analog Control using PID system implemented in arduino microcontroller. This system will determine how powerful the heating element of the soldering iron should operate.


## BLOCK DIAGRAM

![alt text][Block Diagram]


## SCHEMATIC DIAGRAM

![alt text][Schematic Diagram]


## APPLICATION

![alt text][GUI]


## PROTOTYPE

![alt text][Prototype]


## INSTRUCTIONS

1. Run the PIDSS_GUI.m in Matlab.
2. In the new window named PIDSS_GUI, enter the desired temperature and click "Set" button.



[Block Diagram]: https://github.com/tanpatrickf/PID-Soldering-Station/blob/main/Images/Block%20Diagram.png "Block Diagram"
[Schematic Diagram]: https://github.com/tanpatrickf/PID-Soldering-Station/blob/main/Images/Schematic%20Diagram.png "Schematic Diagram"
[GUI]: https://github.com/tanpatrickf/PID-Soldering-Station/blob/main/Images/GUI.png "GUI"
[Prototype]: https://github.com/tanpatrickf/PID-Soldering-Station/blob/main/Images/Prototype.jpg "Prototype"
