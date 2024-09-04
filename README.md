# Pore_Collapse_PostProcessing
Post Processing codes to generate results for Part 2 JMPS

Extraction codes files

StepA_DataExtraction.py extracts the data from Abaqus ODB files< br / >SG_Deformed_Centroids.py generates data of the deformed centroid of each individual grain < br / >
Processing_Codes

DT_Generator.m is used to generate the Dealunay Triangulation.
Generate_nodal_pressure.m is used to generate nodal pressures from element pressures from ODB output.
alpha_optical2.m is the distension calculator.
bagi_strain_3D_time.m is the volumetric strain calculator.
pressure_3D_time_v2.m is the pressure calculator.
runmatlab.sh is a bash script to run many codes sequentially.
