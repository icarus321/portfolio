import os, sys, urllib2, urllib, socket

path = os.getcwd()



def getData(pathURL,eachFile):
    myA=[]
    myA2=[]
    mURL2 = urllib.urlopen(pathURL)
    myA.append(mURL2)
    myA2.append(pathURL)
    intI=0

    for eA in myA2:
        print eA
        try:
            mURL2 = urllib.urlopen(eA)
        except:
            pass
        for e in mURL2:
            e2 = e.split(" ")
            #print e2[len(e2)-1]
            eFinal = e2[len(e2)-1][0:-2]
            eFinal2 = eA+"//"+e2[len(e2)-1][0:-2]
            for each in eachFile:
                if ((eFinal[len(eFinal)-4:len(eFinal)]==".zip" or eFinal[len(eFinal)-4:len(eFinal)]==".ZIP") and each in eFinal2):
                    print eA
                    urllib.urlretrieve (eA+"//"+eFinal, eFinal)
            if eFinal[len(eFinal)-4:len(eFinal)]==".zip" or eFinal[len(eFinal)-4:len(eFinal)]==".ZIP":
                continue
            pathURL2=eA+"//"+e2[len(e2)-1][0:-2]
            mIS="yes"
            for allA in myA2:
                if allA == pathURL2:
                    mIS = "no"
            if mIS == "yes":
                myA2.append(pathURL2)
        try:
            realsock = mURL.fp._sock.fp._sock
            realsock.close()
            mURL2.close()
        except:
            pass



#myFiles = raw_input("Enter the files you wish to download")
#eachFile = myFiles.split(",")
theFiles=["Name of file 1", "Name of file 2"]
#the URL of the FTP site you wish to download files from
theURL = "url you wish to acquire from"


getData(theURL,theFiles)




        
 

