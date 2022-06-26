# Arma 3 > Vehicles Overhauling (v1.5)
>*Dependencies: none.*
>*Compatible with ACE.*

Vehicles Overhauling (VO) is a system of repair, refuel and rearm stations for multiplayer missions that simultaneously require resources by doctrine: ground, air and nautical vehicles. Each doctrine or services are easily turned Off or On, according to the editor's needs. Triggering or code via Eden is needless, even opening multiple files for script settings. VO prioritizes implementation simplicity and quick changes management that the mission editor might want.  

**What to expect from this script**

- Define which vehicle type have automatically access to ground, air or nautic services;
- Define which service each station type (asset) will provide: repair, refuel or rearm or all of them (full service);
- Every object/asset on Eden Editor can be a station automatically, it's up to the mission-editor;
- No code or triggers is needed on Eden Editor;
- Just one file to set easely your mission needs: _fn_VO_parameters.sqf_;
- Once defined which assets/objets are stations and its type, on Eden you just drag and drop the asset you defined as station;
- Script working as gold on hosted and dedicated servers.

...............

### GLOBAL STATION RULES

- Every object/asset on Eden can be a station;
- The vehicle that need a service (named "target-vehicle") must be within the station's range of action;
- At least one player must be close (or inside) to the target-vehicle, except drones if the mission-editor authorized through _fn_VO_parameters.sqf_;
- The target-vehicle must not be completely destroyed;
- To provide the service, the station must not be destroyed or under water or flying (supply containers) or even moving (supply vehicles); 
- Each station can provide only the services that it allowed to; 

**To repair:**
- The target-vehicle must have some damage;
- The target-vehicle engine must be off;

**To refuel:**
- The target-vehicle must have had some fuel consumption;
- The target-vehicle engine must be off;

**To rearm:**
- The target-vehicle must have onboarded weaponry;
- The target-vehicle must have spent some ammunition;

### GROUND STATION RULES

- To get a service, the target-vehicle must be a land vehicle, including drones;
- The target-vehicle must have its speed at zero or very close to it;

### AIR STATION RULES

- To get a service, the target-vehicle must be an air vehicle, including drones;
- The target-vehicle must be touching the ground;
- The target-vehicle must be completely stopped;

### NAUTIC STATION RULES

- To get a service, the target-vehicle must be a nautical vehicle, including drones;
- The target-vehicle cannot be submerged, even submarines;
- The target-vehicle must have its speed at zero or very close to it;

...............

## Ideas or fixes?
link soon

## Changelog

**v1.5 - Jun, 26th 2022**
- Bug fixes and lot of function improvements. 

**v1.0 - Mar, 4th 2022**
- Hello world.
