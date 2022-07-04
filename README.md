# Arma 3 > Vehicles Overhauling (v1.5)
>*Dependencies: none.*
>*Compatible with ACE, RHS, CUP.*

Vehicles Overhauling (VO) is a free Arma 3 script that provides a system of repairing, refueling, and rearming vehicles by proximity and with any asset of your choice. Also, the services are divided by doctrine: Ground, Air, and Nautical. Each doctrine and even service is easily turned Off or On, according to the editor's needs. If needed, the editor can allow repairing just for ground vehicles while unavailable for air ones, for example. Triggering or code via Eden Editor is needless. VO is configured through only one file, prioritizing implementation simplicity and quick change management that the mission editor might want.  

**What to expect from VO script**

- Define what vehicle type have automatically access to ground, air or nautical services (rearm, repair, refuel);
- Define what service each station (asset) will provide: repair, refuel or rearm or all of them (full service);
- Every object/asset on Eden Editor can be traceable as station automatically, it's up to the mission-editor;
- Once defined which assets are stations, on Eden you just drag and drop the asset and the script will track them;
- All repair, refuel, and rearm Arma 3 and its DLCs assets are already tracked;
- All repair, refuel, and rearm RHS and CUP assets are already tracked;
- 100% compatible with CBA+ACE.
- No code or triggers is needed on Eden Editor;
- Just one file to set easely your mission needs: _fn_VO_parameters.sqf_;
- Script working as gold on hosted and dedicated servers;

**How to install / Documentation**

https://docs.google.com/document/d/1l0MGrLNk6DXZdtq41brhtQLgSxpgPQ4hOj_5fm_KaI8/edit?usp=sharing

_

### SCRIPT GLOBAL RULES

- Every object/asset on Eden can be a station;
- The vehicle that need a service ("target-vehicle" for better understanding here) must be within the station's range of action;
- At least one player must be close (or inside) to the target-vehicle, except drones if the mission-editor authorized through _fn_VO_parameters.sqf_;
- The target-vehicle must not be completely destroyed;
- To provide the service, the station must not be destroyed or under water or flying (supply containers) or even moving (supply vehicles); 
- Each station can provide only the services that it allowed to.

**To repair:**
- The target-vehicle must have some damage;
- The target-vehicle engine must be off.

**To refuel:**
- The target-vehicle must have had some fuel consumption;
- The target-vehicle engine must be off.

**To rearm:**
- The target-vehicle must have onboarded weaponry;
- The target-vehicle must have spent some ammunition.

### SCRIPT GROUND RULES

- To get a service, the target-vehicle must be a land vehicle, including drones;
- The target-vehicle must have its speed at zero or very close to it.

### SCRIPT AIR RULES

- To get a service, the target-vehicle must be an air vehicle, including drones;
- The target-vehicle must be touching the ground;
- The target-vehicle must be completely stopped;
- If the target-vehicle is a plane, a parking helper will run automatically.

### SCRIPT NAUTICAL RULES

- To get a service, the target-vehicle must be a nautical vehicle, including drones;
- The target-vehicle cannot be submerged, even submarines;
- The target-vehicle must have its speed at zero or very close to it.

_

## Ideas or fixes?
https://forums.bohemia.net/search/?q=Vehicles%20Overhauling%20Script

_

## Changelog

**v1.5 - Jul, 4th 2022**
- ACE auto-detect;
- RHS and CUP assets tracked by default;
- Some bug fixes and performance improvements; 
- Documentation included.

**v1.0 - Mar, 4th 2022**
- Hello world.
