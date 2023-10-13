clear;clc;
jm = findResource('scheduler', 'type', 'jobmanager', 'name', 'myJM','LookupURL', '192.168.1.106');   
job=createJob(jm);     
set(job,'FilehDependencies',{'Fun_AG.m'});
job;
createTask(job,@Fun_AG,5,{{},{},{}});
submit(job)
waitForState(job,'finished')
results = getAllOutputArguments(job);  
save('result.mat','results');    
destroy(job);  