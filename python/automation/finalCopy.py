# MapAutomation Version 1
# For Use With Python 2.7
# Intended for automating county level maps in the state of Iowa
# Assumes knowledge of Python and Arcpy
# Created by James Madden

#Phase 1 Updates needed to account for bad input and specific counties
#Pahse 2 Updates needed for GUI, make usable to all GIS professionals


# highly reusable in sense that it can take in any layer or layers in the ftp and add them to the map

#limitations
#geoprocessing operations must be coded by programmer each time if they are needed
# map legend may need to be adjusted based on scope of work
# layer symbology files must exist
# legend drawing order may need to be adjusted 








import os, sys, urllib2, urllib, zipfile, arcpy
from arcpy import env

path = os.getcwd()

def pickData():
    myCount = 1
    path1 = 'ftp://ftp.igsb.uiowa.edu/gis_library/Counties/'
    response = urllib2.urlopen(path1)
    print "Enter the name of the files you need"
    numZips = raw_input()
    numZips2 = numZips.split(",")
    myResponse(myCount, path1, response, numZips2)

def myResponse(myCount, path1, response, numZips2):
    myPath = os.getcwd()
    for each in response:
        eachNew = each.split("  ")
        eachCounty = eachNew[9].strip("\n").strip("\r")
        try:
            myCountyDir = os.mkdir(os.path.expanduser(myPath+ "\\counties" + "\\" + eachCounty))
        except:
            pass
        myRetrieveDir = myPath+"\\counties" + "\\" + eachCounty
        os.chdir(myRetrieveDir)
        myCount+=1
        response1 = urllib2.urlopen(path1 + eachNew[9])
        for all1 in response1:
            allNew = all1.split(",")
            allFinal = allNew[0].split(" ")
            allFinal1 = allFinal[len(allFinal)-1].strip(" ").strip("\n").strip("\r")
            numZipsIter = 0
            path8 = path1 + eachNew[9][0:len(eachNew[9])-2] +"/"+ allFinal1
            downZip = eachNew[9][0:len(eachNew[9])-2]+".zip"
            while(numZipsIter <len(numZips2)):
                if (numZips2[numZipsIter][0:3].strip(" ") == "NWI") and ("remap" not in allFinal1):
                    numZips2New = numZips2[numZipsIter].split("_")
                    if (numZips2New[0].strip(" ") in allFinal1 and numZips2New[1] != "remap" and numZips2New[2].strip(" ") in allFinal1) and (allFinal1[-3:]=="ZIP" or allFinal1[-3:]=="zip"):
                        urllib.urlretrieve (path8,  allFinal1)
                        zip1 = zipfile.ZipFile(myRetrieveDir +"\\" + allFinal1)
                        zip1.extractall(myRetrieveDir)
                #maybe just have numzips2 (raw input) as the values before the county number
                #numZips2[numZipsIter][0:-7].strip(" ") in allFinal1 or numZips2[numZipsIter][0:-7].strip(" ").lower() in allFinal1) and (allFinal1[-3:]=="ZIP" or allFinal1[-3:]=="zip"
                elif (numZips2[numZipsIter].strip(" ") in allFinal1 or numZips2[numZipsIter].strip(" ").lower() in allFinal1) and (allFinal1[-3:]=="ZIP" or allFinal1[-3:]=="zip"):
                    urllib.urlretrieve (path8,  allFinal1)
                    zip1 = zipfile.ZipFile(myRetrieveDir +"\\" + allFinal1)
                    zip1.extractall(myRetrieveDir)
                numZipsIter+=1



pickData()

#client picks shapefiles to add to map
#section for geoprocessing operations




# get the data frames


# Create new layer for all files to be added to map document
# need to handle non remap wetlands
#need to check that rawinput is equal, same line as ,shp if
#add new data frame, title
#check spaces in ftp crawler



os.chdir(path)
env.workspace = path+ "\\symbology\\"
zp1 = os.listdir(path + "\\counties\\")

def myGeoprocessing(layer2):
    #layer 2 is the name of the county
    #the code in this function is used for geoprocessing operations
    #it returns whatever output is generated from the tools used in the map
 
    arcpy.Select_analysis(path + "\\symbology\\county.shp", path + "\\counties\\" + layer2 + "\\" + layer2 + ".shp", '"County" = ' + "'%s'" %layer2)
    arcpy.Clip_analysis(path + "\\symbology\\Stream_order.shp", path + "\\counties\\" + layer2 + "\\" + layer2 + ".shp", path + "\\counties\\" + layer2 + "\\Streams.shp")
 
    myArray = []
    streams = arcpy.mapping.Layer(path + "\\counties\\" + layer2 + "\\Streams.shp")
    arcpy.ApplySymbologyFromLayer_management(streams, path+ '\\symbology\\streams.lyr')
    myCounty = arcpy.mapping.Layer(path + "\\counties\\" + layer2 + "\\" + layer2 + ".shp")
    arcpy.ApplySymbologyFromLayer_management(myCounty, path+ '\\symbology\\singleCounty.lyr')
    myCountyMain = arcpy.mapping.Layer(path + "\\counties\\" + layer2 + "\\" + layer2 + ".shp")
    arcpy.ApplySymbologyFromLayer_management(myCountyMain, path+ '\\symbology\\singleCountyMain.lyr')
    myArray.append(myCounty)
    myArray.append(myCountyMain)
    myArray.append(streams)
    return myArray





#legend, hash out names
#need to provide descriptive names for variables,
#reusability in sense it can take in multiple layers and add them to map
#limitations geoprocessing operations must be coded by programmer each time if needed
# map legend may need to be adjusted based on scope of work
# layer symbology files must exist
# legend drawing order may be buggy 
#change variable names
#hash out county symbology


def makeMap():
    #original wetlands layers need to be entered as NWI_line or NWI_poly
    print "Enter the title and layer or layers you wish to include in the map"
    #line below takes user input seperated by commas
    myIn = raw_input();
    #splits the input into list of strings
    myInput = myIn.split(",")
    counter1 = 1
    #create the mapping documents
    theMap = arcpy.mapping.MapDocument(path +'\\wetland.mxd')
    df1 = arcpy.mapping.ListDataFrames(theMap,"*")[0]
    df2 = arcpy.mapping.ListDataFrames(theMap,"*")[1]
    legend = arcpy.mapping.ListLayoutElements(theMap, "LEGEND_ELEMENT", "Legend")[0]
    #for loop iterates through the county directory, each is the name of the county
    for each in zp1:
        theMap = arcpy.mapping.MapDocument(path +'\\wetland.mxd')
        df1 = arcpy.mapping.ListDataFrames(theMap,"*")[0]
        df2 = arcpy.mapping.ListDataFrames(theMap,"*")[1]
        legend = arcpy.mapping.ListLayoutElements(theMap, "LEGEND_ELEMENT", "Legend")[0]
        print each
        #zp2 is the list of everything in each individual county layer
        zp2 = os.listdir(path + "\\counties\\" + each)
        # for loop iterates through each element in the individual county layer
        #eachNew is the name of each file
        i = 1
        while(i<len(myInput)):
        
            #print eachNew
            #need while loop for length of input then move function call outside
            # for eachNew is going to look at each file in the county directory
            #while loop will compare each raw input to that file
            
            #while i is less than or equal to the length of the user input
            #bug is i is one but eachNew is not changing
            
            print len(myInput)
            for eachNew in zp2:
                print eachNew
                if (eachNew[-4:] == ".shp") and ((myInput[i] in eachNew[0:-7] or myInput[i].lower() in eachNew[0:-7])or((eachNew[8:12] == "poly" or eachNew[8:12]=='line') and eachNew[8:12] in myInput[i])):
                    print eachNew[0:-7]

                    #this is where we add our layers
                    layer1 = arcpy.mapping.Layer(path + "\\counties\\" + each + "\\" + eachNew)
                    if(eachNew[7:11] == "poly" or eachNew[7:11] =="line"):
                        arcpy.ApplySymbologyFromLayer_management(layer1, path + '\\symbology\\' +myInput+'.lyr')
                    else:
                        arcpy.ApplySymbologyFromLayer_management(layer1, path + '\\symbology\\' +eachNew[0:-7]+'.lyr')

                    # Assign legend variable for map
                    
                    # add wetland layer to map
                    legend.autoAdd = True
                    arcpy.mapping.AddLayer(df1, layer1,"AUTO_ARRANGE")
                    #geoprocessing steps
                    print 'hello'
            i+=1
                    
        streams = myGeoprocessing(each)
        # more geoprocessing options, add the layers to map and assign if they should appear in legend
        legend.autoAdd = True
        print 'hello'
        #push the legend items into function params
        arcpy.mapping.AddLayer(df1, streams[2],"AUTO_ARRANGE")
        legend.autoAdd = False
        arcpy.mapping.AddLayer(df1, streams[1],"AUTO_ARRANGE")
        arcpy.mapping.AddLayer(df2, streams[0],"AUTO_ARRANGE")
        df1.extent = streams[1].getExtent(True)
        df1.scale = df1.scale*1.75

        theMap.title = each + " " + myInput[0]
        arcpy.mapping.ExportToJPEG(theMap, path + "\\counties\\" + each + "\\wetland.jpg")
        #Save map document to path
        theMap.saveACopy(path + "\\counties\\" + each + "\\wetland.mxd")
        del theMap
            
        print "done with map " + str(counter1)
                
        print "issue with map or already exists"
        counter1+=1

makeMap()
