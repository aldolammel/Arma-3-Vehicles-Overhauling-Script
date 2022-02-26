# Arma 3 > Vehicles Overhauling (v0.2)

### EDITOR CAN EASILY CHANGE:

- What types of vehicles have access to stations (land, air, nautical);
- What services are available (repair, refuel, rearm);
- Action radius of each type of station;
- Waiting time between one service and another;
- Defined which types of assets will automatically receive the attributes of a station;

### GLOBAL STATION RULES

- The vehicle must be within the station's range of action;
- At least one player must be close to the vehicle;
- The vehicle must not be completely destroyed;
- For a service to be performed, the station cannot be busy with another one.
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
