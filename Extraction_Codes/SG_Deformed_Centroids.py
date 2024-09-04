from odbAccess import *
from odbAccess import *
import os
import numpy as np
import sys

# I am going to use only grains to generate radiograph,.No box or impactor
os.chdir(r"/data1/sghosh29/Pore_collapse/Analysis_Al_6/DC_all_grains/")

data_dir='/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Abaqus_sims/'

job_id=1

num_grains=883

num_frames=41

odb = openOdb(data_dir+'Job-'+str(job_id)+'.odb')
number_frames=len(odb.steps['Step-1'].frames)

numnodes=362728
numelements=1135068

instance_name = 'PART-1-1'

nC=np.ones((num_grains,3))

interval=1

for j in range(0,num_frames,interval):#number_frames):


        for grain_id in range(0,num_grains):
	    
	    grain_name='PT_MERGED_MASK_1_'+str(grain_id+1)
	    instance=odb.rootAssembly.instances[instance_name].elementSets[grain_name]
	    
	
	    nodeCoord = np.zeros((numnodes,3))
	    nodelabels= np.zeros((numnodes,1))
	    
	    coord_output=odb.steps['Step-1'].frames[j].fieldOutputs['COORD']
	    field_values=coord_output.getSubset(position=ELEMENT_NODAL,region=instance).values #addition of position=NODAL was important
	 
	    for value in field_values:
		
		nodelabel=int(value.nodeLabel) 
		nodeCoord[nodelabel-1,0:3]=value.data ## node coordinates are in the order of 1,2,3,....last node
		
	    nodeCoord=nodeCoord[~np.all(nodeCoord==0,axis=1)]
	    length=nodeCoord.shape[0]
	    c_x=np.sum(nodeCoord[:,0])/length
	    c_y=np.sum(nodeCoord[:,1])/length
	    c_z=np.sum(nodeCoord[:,2])/length
	    nC[grain_id,0:3]=np.array([[c_x,c_y,c_z]])
	    
	               
	    #np.savetxt('VolumeCentroid_Job'+str(job_id)+'_Frame'+ str(j)+'.txt',nC,fmt='%15.10f',delimiter=' ')

        np.savetxt('Frame_'+str(j)+'.txt',nC,fmt='%15.10f',delimiter=' ')
	          
odb.close()  



