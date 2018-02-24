# -*- coding: utf-8 -*-
"""
Created on Sun Oct 08 14:22:52 2017

@author: pb438
"""

import os, datetime,numpy
imdir = r'Z:\NASA_Himalaya_Project\Satellite_imagery\ImageStacks\p146r039_all'
dirs = os.listdir(imdir)
dirs =[os.path.join(imdir,x) for x in dirs]

a = ['date','sensor','filename']  #Create a list to store each tile's date sensor and filename
b = [a]
for i in range(0,len(dirs)):
    filename = os.listdir(dirs[i])[1]  #LE07_L1TP_146039_19990920_20170217_01_T1_MTL.txt
    date = filename.split('_')[3]
    year= date[0:4]
    month= date[4:6]
    day = date[6:8]
    
    fmt='%Y.%m.%d'  #Set the format of date
    s = year+'.'+month + '.' + day
    dt = datetime.datetime.strptime(s, fmt)  #class datetime.datetime: A combination of a date and a time. Attributes: year, month, day, hour, minute, second, microsecond, and tzinfo. classmethod datetime.strptime(date_string, format) Return a datetime corresponding to date_string, parsed according to format.
    tt = dt.timetuple()  #datetime.timetuple(). e.g., time.struct_time(tm_year=1999, tm_mon=9, tm_mday=20, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=0, tm_yday=263, tm_isdst=-1)
    if (len(str(tt.tm_yday)) == 2):  #if the DOY is 2-digit, prefix it with '0'
        julianday = '0' + str(tt.tm_yday)
    else:
        julianday = str(tt.tm_yday)
    date = str(year) + julianday  #e.g., 1999263
    out = [date,''.join([str(os.listdir(dirs[i])[0]).split('.')[0][:2],str(os.listdir(dirs[i])[0]).split('.')[0][3]]),os.path.join(dirs[i],str(os.listdir(dirs[i])[0]))]  #e.g., ['1999263','LE7','F:\\Himalaya\\Landsat\\ImageStack\\LE071460391999092001T1-SC20171003013820\\LE071460391999092001T1.tif']    
    b.append(out)

import csv
# Note: change this output name for each path & row tile
with open("Z:\NASA_Himalaya_Project\Satellite_imagery\ImageStacks\csvLists\p146r039_ETM_output2.csv",'wb') as resultFile:  #'wb': write and binary; The with statement clarifies code that previously would use try...finally blocks to ensure that clean-up code is executed.
    wr = csv.writer(resultFile, dialect='excel')
    for val in b:
        wr.writerows([val])

print(b)