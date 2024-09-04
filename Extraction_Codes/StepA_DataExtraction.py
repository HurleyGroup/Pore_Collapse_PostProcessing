from odbAccess import *
from odbAccess import *
import os
import numpy as np

# I am going to use only grains to generate radiograph,.No box or impactor
os.chdir(r"/data1/sghosh29/Pore_collapse/Analysis_Al_6/Data_output/")

Jobs=[1]
data_dir='/data1/sghosh29/Pore_collapse/Validation_May2024/Al/Al6/Abaqus_sims/'
for job_id in Jobs:

#job_id=2;

	
	# Set path to odb file
	odb = openOdb(data_dir+'Job-'+str(job_id)+'.odb')
	number_frames=len(odb.steps['Step-1'].frames)
	#frame = odb.steps['Step-1'].frames[0]
	instance_name = 'PART-1-1'
	instance=odb.rootAssembly.instances[instance_name]
	numnodes=len(instance.nodes);
	numelements=len(instance.elements)
	
	conn = np.zeros((numelements,5))  #first column is element label
	#node_set=instance.nodes
	#kk=0;
	for element in instance.elements: 
	    elabel= int(element.label)  
	    #conn[kk,0]=element.label
	    #conn[kk,1:5]=element.connectivity
	    conn[elabel-1,0]=element.label
	    conn[elabel-1,1:5]=element.connectivity
	    #kk=kk+1
	#np.savetxt('connectivity_Job1.txt',conn,fmt='%i',delimiter=' ')
	np.savetxt('connectivity_Job'+str(job_id)+'.txt',conn,fmt='%i',delimiter=' ')
	#FRAMES=[0,2,5,9,15,20]
       # FRAMES=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
        FRAMES=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
	for j in range(0,34):#number_frames):
	#for j in FRAMES:   #  range(0,16):#number_frames):
	    nodeCoord = np.zeros((numnodes,3))
	    nodelabels= np.zeros((numnodes,1))
	    nodedensity=np.zeros((numnodes,2))# second column is a counter that lets you average density
	    elemlabels= np.zeros((numelements,1))
	    elemdensity= np.zeros((numelements,1))
	    P= np.zeros((numelements,1))
	    coord_output=odb.steps['Step-1'].frames[j].fieldOutputs['COORD']
	    field_values=coord_output.getSubset(position=NODAL,region=instance).values
	    #jj=0
	    for value in field_values:
		#nodelabels[jj,0]=value.nodeLabel
		#nodeCoord[jj,0:3]=value.dataDouble
		nodelabel=int(value.nodeLabel) 
		nodeCoord[nodelabel-1,0:3]=value.dataDouble ## node coordinates are in the order of 1,2,3,....last node##changed frm data double to datas
		#jj=jj+1;
	    #np.savetxt('nodelabel'+str(j)+'.txt',nodelabels,fmt='%i',delimiter=' ')
	    np.savetxt('nodeCoordinates_Job'+str(job_id)+'_Frame'+ str(j)+'.txt',nodeCoord,fmt='%15.10f',delimiter=' ')
	    
	    Dens=odb.steps['Step-1'].frames[j].fieldOutputs['DENSITY']
	    field_values_den=Dens.getSubset(position=NODAL,region=instance).values
	   
	    for value in field_values_den:
	
		elemlabel=int(value.elementLabel)
		elemdensity[elemlabel-1,0]=value.data ## element density values are in the order of 1,2,3,....last element
		
		e_den=elemdensity[elemlabel-1,0];
		
	    np.savetxt('elemdensity_Job'+str(job_id)+'_Frame'+ str(j)+'.txt',elemdensity,fmt='%15.10f',delimiter=' ') 
	    
	    Dens=odb.steps['Step-1'].frames[j].fieldOutputs['TEMP']
	    field_values_den=Dens.getSubset(position=ELEMENT_NODAL,region=instance).values
	   
	    for value in field_values_den:
	
		elemlabel=int(value.elementLabel)
		elemdensity[elemlabel-1,0]=value.data ## element density values are in the order of 1,2,3,....last element
		
		e_den=elemdensity[elemlabel-1,0];
		
	    np.savetxt('elemtemp_Job'+str(job_id)+'_Frame'+ str(j)+'.txt',elemdensity,fmt='%15.10f',delimiter=' ') 
	    
	    
	    Dens=odb.steps['Step-1'].frames[j].fieldOutputs['S']
	    field_values_den=Dens.getScalarField(invariant=PRESS).getSubset(position=ELEMENT_NODAL,region=instance).values
	    #jj=0
	    for value in field_values_den:
		#elemlabels[jj,0]=value.elementLabel]
		#elemdensity[jj,0]=value.data 
		elemlabel=int(value.elementLabel)
		elemdensity[elemlabel-1,0]=value.data ## element density values are in the order of 1,2,3,....last element
		
		P=elemdensity[elemlabel-1,0];
		


		#jj=jj+1;
	    #np.savetxt('elemlabel'+str(j)+'.txt',elemlabels,fmt='%i',delimiter=' ')
	    np.savetxt('elempressure_Job'+str(job_id)+'_Frame'+ str(j)+'.txt',elemdensity,fmt='%15.10f',delimiter=' ') 
	    
	    Dens=odb.steps['Step-1'].frames[j].fieldOutputs['DENSITY']
	    field_values_den=Dens.getSubset(position=ELEMENT_NODAL,region=instance).values
	    #jj=0
	    for value in field_values_den:
		#elemlabels[jj,0]=value.elementLabel]
		#elemdensity[jj,0]=value.data 
		elemlabel=int(value.elementLabel)
		elemdensity[elemlabel-1,0]=value.data ## element density values are in the order of 1,2,3,....last element
		
		e_den=elemdensity[elemlabel-1,0];
		

		#jj=jj+1;
	    #np.savetxt('elemlabel'+str(j)+'.txt',elemlabels,fmt='%i',delimiter=' ')
	    np.savetxt('elemdensity_Job'+str(job_id)+'_Frame'+ str(j)+'.txt',elemdensity,fmt='%15.10f',delimiter=' ') 
	    
	    
	   

	odb.close()  

	'''    
	import subprocess
	def open_matlab():
	    # Path to the MATLAB executable
	    matlab_path = '/usr/local/MATLAB/R2023a/bin/'
	    # MATLAB command to execute
	    matlab_command = "matlab -nodesktop"
	    try:
		# Open MATLAB using subprocess
		subprocess.Popen(matlab_command, shell=True, executable=matlab_path)
	    except Exception as e:
		print("Error occurred while opening MATLAB:", str(e))
	# Call the function to open MATLAB
	open_matlab()
	   '''
