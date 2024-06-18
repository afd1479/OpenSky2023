# OpenSky2023
Code for accepted paper Securing the Sky: Detecting Aircraft Location Drifting through Cross-Checking Receiver-Based Estimated and Received ADS-B Trajectories
### A: System Approach and Procedure

- **File 1:** Parse ADS-B messages to obtain sensor data. This example covers one day, but a loop can be used for additional days.
- **File 2:** Determine sensor boundaries using two functions.
- **File 3:** Retrieve the coverage location for all sensors. This is done once for all sensors.
- **File 4:** Parse ADS-B messages from the file, which can be the initial step.
- **File 5:** Identify flight trajectories for all aircraft.
- **File 6:** Apply location prediction methods.
- **File 7:** Compute sensor  locations based on coverage area.
- **Outliers File:** Remove outliers from sensor boundaries.
- **Sensors_seq File:** Determine the sequence of sensors.

### B: Evaluation and Statistics

- **FrechetDist:** Calculate the Fréchet distance.
- **Test_Frechet_Dist:** Test the Fréchet distance.
- **Statistic_1:** Plot error distribution by first calculating the standard deviation for each trajectory, then combining them.
- **Statistic_2:** Plot the error distribution using a point-based method for all points together.

### C: Plotting Area

- **General Plots:** Plot error distributions showing the deviation of actual sensor locations from computed ones.
- **Error_Plot_Heatmap:** Plot a heatmap of errors.
- **Error Comparison:** Compare errors between computed and derived sensor locations.

### Run Procedure

1. **A1-A4:** Parse ADS-B data to obtain ADS-B messages, sensors, and their boundaries.
2. **A5:** Organize ADS-B data into trajectories using files A1-A5.
3. **A6-A7:** Use these files to predict aircraft locations and determine sensor locations.
4. **AA Files:** Filter the data.
5. **B Files:** Obtain statistical data for evaluation.
6. **C Plot Scripts:** Generate plots.
