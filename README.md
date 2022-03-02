# Arma 3 > Vehicles Overhauling (v1.0)
>*Dependencies: none.*

Vehicles Overhauling (VO) is a system of repair, resupply, and rearmament stations for multiplayer missions that simultaneously require resources for ground, air, and nautical vehicles, with each doctrine or resource being easily turned off or on according to the editor's needs. No triggering or code via Eden is needed, or even opening multiple files for script settings. VO prioritizes simplicity of implementation and quick changes management that the mission editor might want. Developed mainly for dedicated servers. 

**What to expect from this script**

- Define which vehicle type have automatically access to ground, air or nautic stations;
- Define which service each station type (asset) will provide: repair, refuel or rearm or all of them;
- No code or triggers is needed on Eden Editor;
- Just one file to set easely your mission needs;
- Once defined which assets/objets are stations and its type, on Eden you just drag and drop the asset you defined as station.

...............

### EDITOR CAN EASILY CHANGE:

- 
- What services are available (repair, refuel, rearm);
- Action radius of each type of station;
- Waiting time between one service and another;
- Defined which types of assets will automatically receive the attributes of a station;

### GLOBAL STATION RULES

- The vehicle must be within the station's range of action;
- At least one player must be close to the vehicle;
- The vehicle must not be completely destroyed;
- For a service to be performed, the station cannot be busy with another player.

**To repair:**
- Must have some damage;
- The engine must be off;

**To refuel:**
- Must have had some fuel consumption;
- The engine must be off;

**To rearm:**
- Must have spent some ammunition in the vehicle;

### GROUND STATION RULES

- Must be a land vehicle;
- The vehicle must have its speed at zero or very close to it;

### AIR STATION RULES

- Must be an air vehicle;
- The vehicle must be touching the ground;
- The vehicle must be completely stopped;

### NAUTIC STATION RULES

- Must be a nautical vehicle;
- The vehicle cannot be submerged;
- The vehicle must have its speed at zero or very close to it;

...............

## Ideas or fixes?
<link soon>

## Changelog

**v1.0 - Mar, 2nd 2022**
- Hello world.
