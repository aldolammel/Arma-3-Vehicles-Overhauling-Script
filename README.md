# Arma 3 > Vehicles Overhauling (v1.0)
>*Dependencies: none.*
>*Compatible with ACE.*

Vehicles Overhauling (VO) is a system of repair, resupply, and rearmament stations for multiplayer missions that simultaneously require resources for ground, air, and nautical vehicles, with each doctrine or resource being easily turned off or on according to the editor's needs. No triggering or code via Eden is needed, or even opening multiple files for script settings. VO prioritizes simplicity of implementation and quick changes management that the mission editor might want.  

**What to expect from this script**

- Define which vehicle type have automatically access to ground, air or nautic stations;
- Define which service each station type (asset) will provide: repair, refuel or rearm or all of them;
- Every object/asset on Eden Editor can be a station automatically, it's up to the mission-editor;
- No code or triggers is needed on Eden Editor;
- Just one file to set easely your mission needs: _fn_VO_parameters.sqf_;
- Once defined which assets/objets are stations and its type, on Eden you just drag and drop the asset you defined as station;
- Script working fine on hosted and dedicated servers.

...............

### GLOBAL STATION RULES

- Every object/asset on Eden can be a station;
- The vehicle that need a service (named "target-vehicle") must be within the station's range of action;
- At least one player must be close (or inside) to the target-vehicle;
- The target-vehicle must not be completely destroyed;
- To provide the service, the station must not be destroyed or under water or flying (supply containers) or even moving (supply vehicles); 
- Each station can provide only the services that it allowed to; 
CHECKING !!! - For a service to be performed, the station cannot be busy with another player.

**To repair:**
- The target-vehicle must have some damage;
- The target-vehicle engine must be off;

**To refuel:**
- The target-vehicle must have had some fuel consumption;
- The target-vehicle engine must be off;

**To rearm:**
- The target-vehicle must have spent some ammunition;

### GROUND STATION RULES

- To receive a service, the target-vehicle must be a land vehicle;
- The target-vehicle must have its speed at zero or very close to it;

### AIR STATION RULES

- To receive a service, the target-vehicle must be an air vehicle;
- The target-vehicle must be touching the ground;
- The target-vehicle must be completely stopped;

### NAUTIC STATION RULES

- To receive a service, the target-vehicle must be a nautical vehicle;
- The target-vehicle cannot be submerged;
- The target-vehicle must have its speed at zero or very close to it;

...............

## Ideas or fixes?
link soon

## Changelog

**v1.0 - Mar, 2nd 2022**
- Hello world.
