# MapAutomation Version 2
# For Use With Python 2.7
# Intended for automating county level maps in the state of Iowa
# Assumes knowledge of Python and Arcpy
# Created by James Madden

#Phase 1 Updates needed to account for bad input, specific counties and legend items
#In the case of bad input user will just run application again
#program requires user to setup which layers will be included in the map


#Pahse 2 Updates needed for GUI the making app usable to all GIS professionals


# highly reusable in sense that it can take in any layer or layers in the ftp and add them to the map
#maps are produced quickly and manual updates can be made quickly if needed

#limitations
#geoprocessing operations must be coded by programmer each time if they are needed
# map legend may need to be adjusted based on scope of work
# layer symbology files must exist, client is expected to create layer symbology based on scope of project
# legend drawing order may need to be adjusted 




#further work, legend names, spacing



import os, sys, urllib2, urllib, zipfile, arcpy
from arcpy import env
arcpy.env.overwriteOutput = True
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
                if(("SOIL" in path8 or "soil" in path8) and("soils" in numZips2[numZipsIter] or "SPOT" in numZips2[numZipsIter] or "ssurgo" in numZips2[numZipsIter])):
                   response2 = urllib2.urlopen(path8)
                   for all2 in response2:
                       allNew = all2.split(",")
                       allFinal2 = allNew[0].split(" ")
                       allFinal22 = allFinal2[len(allFinal2)-1].strip(" ").strip("\n").strip("\r")
                       path9 = path8 +"/"+ allFinal22

                       if (numZips2[numZipsIter].strip(" ") in allFinal22 or numZips2[numZipsIter].strip(" ").lower() in allFinal22) and (allFinal22[-3:]=="ZIP" or allFinal22[-3:]=="zip"):
                           #do extract of soils
                           urllib.urlretrieve (path9,  allFinal22)
                           zip1 = zipfile.ZipFile(myRetrieveDir +"\\" + allFinal22)
                           zip1.extractall(myRetrieveDir)                    
                if (numZips2[numZipsIter][0:3].strip(" ") == "NWI") and ("remap" not in allFinal1):
                    numZips2New = numZips2[numZipsIter].split("_")
                    if (numZips2New[0].strip(" ") in allFinal1 and numZips2New[1] != "remap" and numZips2New[2].strip(" ") in allFinal1) and (allFinal1[-3:]=="ZIP" or allFinal1[-3:]=="zip"):
                        urllib.urlretrieve (path8,  allFinal1)
                        zip1 = zipfile.ZipFile(myRetrieveDir +"\\" + allFinal1)
                        zip1.extractall(myRetrieveDir)

                elif (numZips2[numZipsIter].strip(" ") in allFinal1 or numZips2[numZipsIter].strip(" ").lower() in allFinal1) and (allFinal1[-3:]=="ZIP" or allFinal1[-3:]=="zip") and \
                     ("PLSS" in numZips2[numZipsIter]and "QQQ" in numZips2[numZipsIter]):
                    urllib.urlretrieve (path8,  allFinal1)
                    zip1 = zipfile.ZipFile(myRetrieveDir +"\\" + allFinal1)
                    zip1.extractall(myRetrieveDir)
                elif (numZips2[numZipsIter].strip(" ") in allFinal1 or numZips2[numZipsIter].strip(" ").lower() in allFinal1) and (allFinal1[-3:]=="ZIP" or allFinal1[-3:]=="zip" and ("QQQ" not in allFinal1)):
                    urllib.urlretrieve (path8,  allFinal1)
                    zip1 = zipfile.ZipFile(myRetrieveDir +"\\" + allFinal1)
                    zip1.extractall(myRetrieveDir)
                numZipsIter+=1



pickData()


os.chdir(path)
env.workspace = path+ "\\symbology\\"
zp1 = os.listdir(path + "\\counties\\")

def myGeoprocessing(countyName):
    #the code in this function is used for geoprocessing operations
    #it returns whatever output is generated from the tools used in the map
    #will do whatever tools are listed for each folder
    #this section will change based on scope of work
    #variable needed with naming scheme that matches names in folders if doing operation on multiple downloaded files (DEM for instance)
    #use similar naming scheme as used for download files, loop for each file in folder
    try:
        if(myIterCounty<=9):
            myAirphoto = path + "\\counties\\" + countyName + "\\1930s_airphotos_0" + myIterCounty+".sid"
        if(myIterCounty>=10):
           myAirphoto = path + "\\counties\\" + countyName + "\\1930s_airphotos_" + myIterCounty+".sid"
        #this is where we do geoprocessing operations on located in the individual county directories
    except:
           pass

    #expression below is for geoprocessing operations involving layers larger than the county study area
    #first expression will likely always be used as it makes a boundary for each county, other examples clip streams to study area and create layer for an inset map
        
    arcpy.Select_analysis(path + "\\symbology\\county.shp", path + "\\counties\\" + countyName + "\\" + countyName + ".shp", '"County" = ' + "'%s'" %countyName)
    arcpy.Clip_analysis(path + "\\symbology\\Stream_order.shp", path + "\\counties\\" + countyName + "\\" + countyName + ".shp", path + "\\counties\\" + countyName + "\\Streams.shp")
 
    myArray = []
    streams = arcpy.mapping.Layer(path + "\\counties\\" + countyName + "\\Streams.shp")
    arcpy.ApplySymbologyFromLayer_management(streams, path+ '\\symbology\\streams.lyr')
    myCounty = arcpy.mapping.Layer(path + "\\counties\\" + countyName + "\\" + countyName + ".shp")
    arcpy.ApplySymbologyFromLayer_management(myCounty, path+ '\\symbology\\singleCounty.lyr')
    myCountyMain = arcpy.mapping.Layer(path + "\\counties\\" + countyName + "\\" + countyName + ".shp")
    arcpy.ApplySymbologyFromLayer_management(myCountyMain, path+ '\\symbology\\singleCountyMain.lyr')
    myArray.append(myCounty)
    myArray.append(myCountyMain)
    myArray.append(streams)
    #returns an array of each layer intended to be included in the map
    myIterCounty+=1
    return myArray








def makeMap():
    #original wetlands layers need to be entered as NWI_line or NWI_poly

    #line below takes user input seperated by commas
    print "Enter which files you plan to include in the map"
    myFiles = raw_input()
    myFiles2 = myFiles.split(",")
    
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
        
        for eachNew in zp2:
            for eachFile in myFiles2:
                if (eachNew[0:-7] == eachFile or eachNew[0:-7].lower() == eachFile.lower() or \
                    (eachNew[7:11]=='line' and 'line' in eachFile and 'remap' not in eachFile) or (eachNew[7:11]=='poly' and 'poly' in eachFile and 'remap' not in eachFile)):
                                
                    #if condition checks for shapefiles 
                    if (eachNew[-4:] == ".shp"):
                        print eachNew[-4:]
                        try:
                            layer1 = arcpy.mapping.Layer(path + "\\counties\\" + each + "\\" + eachNew)
                            print layer1
                            if((eachNew[7:11] == "poly" or eachNew[7:11] =="line") and "ssurgo" not in eachNew):
                                print eachNew
                                myLayerSymb = eachNew[0:3]+eachNew[7:-4]
                                arcpy.ApplySymbologyFromLayer_management(layer1, path + '\\symbology\\' +myLayerSymb+'.lyr')
                            else:
                                print eachNew
                                arcpy.ApplySymbologyFromLayer_management(layer1, path + '\\symbology\\' +eachNew[0:-7]+'.lyr')

                            # Assign legend variable for map
                    
                            # add wetland layer to map
                            legend.autoAdd = True
                            arcpy.mapping.AddLayer(df1, layer1,"AUTO_ARRANGE")
                        except:
                            continue
                
 
                
                    #this section handles rasters to be included in the map        
                    else:
                        if (eachNew[-4:]!=".dbf" and eachNew[-4:]!=".lyr"):
                            try:
                                layer1 = arcpy.mapping.Layer(path + "\\counties\\" + each + "\\" + eachNew)
                                legend.autoAdd = False
                                #try below is option for symbology
                                arcpy.mapping.AddLayer(df1, layer1,"AUTO_ARRANGE")
                                try:
                                    updateLayer = arcpy.mapping.ListLayers(theMap, eachNew, df1)[0]
                                    sourceLayer = arcpy.mapping.Layer(path + '\\symbology\\' +eachNew[0:-7]+'.lyr')
                                    arcpy.mapping.UpdateLayer(df1,updateLayer, sourceLayer, True)
                                    print "layer symbology works"
                                except:
                                    print "no layer symbology for the file"
                            except:
                                continue
 
                        
        
        #this is the call to the geoprocessing function            
        varGeoprocessing = myGeoprocessing(each)
        # more geoprocessing options, add the layers to map and assign if they should appear in legend
        #push the legend items into function params
        try:
            legend.autoAdd = True
            arcpy.mapping.AddLayer(df1, varGeoprocessing[2],"AUTO_ARRANGE")
            legend.autoAdd = False
            arcpy.mapping.AddLayer(df1, varGeoprocessing[1],"AUTO_ARRANGE")
            arcpy.mapping.AddLayer(df2, varGeoprocessing[0],"AUTO_ARRANGE")
        except:
            pass
        #try block sets the extent to the county, saves the map and exports map to jpeg
        try:

            df1.extent = varGeoprocessing[1].getExtent(True)
            df1.scale = df1.scale*1.75

            theMap.title = each + " County Wetlands"
            arcpy.mapping.ExportToJPEG(theMap, path + "\\counties\\" + each + "\\wetland.jpg")
            #Save map document to path
            theMap.saveACopy(path + "\\counties\\" + each + "\\wetland.mxd")
            del theMap
            
            print "done with map " + str(counter1)
        except:
            print "issue with map or already exists"
        counter1+=1
myIterCounty = 1
makeMap()
