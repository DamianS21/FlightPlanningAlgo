# UAV Flight Planning Algorithm

A MATLAB-based flight path planning system for unmanned aerial vehicles (UAVs) that generates optimal routes while avoiding restricted airspace zones.

## Overview

![56a56d82-c393-4ea3-b827-409ed69161d4](https://github.com/user-attachments/assets/ed3bb117-8502-480d-bf91-d91f393bf013)

This algorithm automatically computes optimal flight paths between user-defined waypoints by detecting restricted areas and generating collision-free trajectories. The system performs two-stage optimization: initial obstacle avoidance followed by path shortening for minimal flight distance.

## Algorithm Architecture

### Core Components

**main.m** - Primary execution script controlling the complete planning pipeline  
**intersection.m** - Obstacle avoidance path generation using polygon edge traversal  
**opti.m** - Route optimization through shortcut detection and validation  
**heading.m** - Bearing calculation between coordinate pairs  
**circle_points.m** - Bounding circle computation for polygonal restricted zones  

### Data Sources

**data_AIRAC.m** - Real-world airspace restrictions from AIRAC navigation database  
**poligeni.m** - Random polygon generator for algorithm testing  
**strefy_testowe.m** - Predefined test scenarios with known restricted areas  

### Utility Functions

**isconvex.m** - Polygon convexity verification and convex hull generation  
**okrag.m** - Circle coordinate generation  
**polygen.m** - Individual polygon creation within specified boundaries  
**polygeom.m** - Geometric property calculation (centroid, area, moments)  
**konwersja.m** - Coordinate conversion from DMS to decimal degrees  

## Processing Pipeline

### Stage 1: Flight Zone Definition
User selects start and destination points through interactive interface. System establishes coordinate bounds and initializes visualization environment.

### Stage 2: Restricted Area Loading
Algorithm loads obstacle data from selected source (AIRAC database, test zones, or random generation). Each polygonal restricted area receives a circumscribing circle for intersection calculations.

### Stage 3: Collision Detection
Direct path between waypoints is analyzed for intersections with restricted zone circles. Only zones intersecting the flight corridor undergo detailed processing.

### Stage 4: Obstacle Avoidance
For each intersecting zone, the system:
- Converts non-convex polygons to convex hulls
- Determines optimal entry/exit points along polygon perimeter
- Generates two alternative paths around the obstacle
- Selects shorter alternative for incorporation into route

### Stage 5: Path Optimization
Route undergoes iterative improvement through shortcut identification. System validates each potential direct connection between non-adjacent waypoints against all restricted zones, implementing successful shortcuts that maintain collision-free status.

### Stage 6: Output Generation
Algorithm provides optimized waypoint sequence with distance metrics and heading calculations for navigation system integration.

## Technical Specifications

**Coordinate System**: Decimal degrees (latitude/longitude) or Cartesian (x/y)  
**Restricted Zone Format**: Polygonal boundaries with vertex coordinates  
**Path Representation**: Sequential waypoint coordinates with inter-point headings  
**Optimization Criterion**: Minimum total flight distance  

## Usage Requirements

MATLAB environment with following dependencies:
- Mapping Toolbox (for polygon operations)
- Image Processing Toolbox (for boundary functions)
- Base MATLAB (for core mathematical operations)

Execute main.m and follow interactive prompts for waypoint selection. Algorithm automatically processes obstacles and generates optimal flight path with performance metrics.

## Output Metrics

- Standard route length (initial obstacle avoidance path)
- Optimized route length (after shortcut implementation)  
- Distance reduction achieved through optimization
- Complete waypoint sequence with navigation headings
- Graphical route visualization with restricted zones

## Author

Damian Szumski (2018)  
Rzeszow University of Technology  
The Faculty of Mechanical Engineering and Aeronautics
