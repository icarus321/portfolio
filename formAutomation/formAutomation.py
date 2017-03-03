#this program is for automating logins to useraccounts

import urllib, webbrowser
import urllib2
from urllib import urlencode
new = 2

myName =  "username"
myPassword = "password"
data1 = {
        "formId1" : myName,
        "formId2" : myPassword,
       
        "FormSubmitId" : " Log In " 
          
            
        }
encoded_data1 = urllib.urlencode(data1)
url1 = "the url to connect to" + urlencode(data1)

webbrowser.open(url1, new=2, autoraise=True)
#alternative approach is to just include the username and password in the string with & and = characters
url2 = "the url&formId1=username&formId2=password&FormSubmitId= Log In"

#code below makes the connection and opens the page
webbrowser.open(url2, new=2, autoraise=True)

#if multiple accounts are to be include you may find it necessary to put some iterator or time function
#program execution is fast enough to force the browser to open new windows rather than new tabs
#a simple loop will serve this added requirement




