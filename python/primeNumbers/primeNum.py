def myFun1():
    print "Enter two numbers separated by a comma"
    myNums = raw_input().replace(" ","")
    myNums2=myNums.split(",")
    myIntNums=[]
    try:
        firstNum=int(myNums2[0])
        secondNum=int(myNums2[1])
        myIntNums.append(firstNum)
        myIntNums.append(secondNum)
        myIntNums.sort()
    except:
        print "You entered bad data, try again"
        myFun1()
        return
    myFun2(myIntNums)
    
def myFun2(myIntNums):
    firstNum = myIntNums[0]
    secondNum=myIntNums[1]
    myNonPrimes=[]
    while(firstNum<=secondNum):
        i=1
        while(i<=firstNum):
            if(firstNum%i==0 and (i!=1)):
                if(i==1):
                    break
                if(i!=1 and i!=firstNum):
                    myNonPrimes.append(firstNum)
                i+=1
            else:
                i+=1
        firstNum+=1


    firstNum1=int(myIntNums[0])
    secondNum2=int(myIntNums[1])

    while(firstNum1<=secondNum2):
        if(firstNum1 not in myNonPrimes and firstNum1>1):
            print str(firstNum1) + " is a prime number"
        firstNum1+=1

    myOption ="yes"
    while(myOption == "yes"):
        print "Would you like to try more numbers, yes or no?"
        myNewInput = raw_input().replace(" ","").lower()
        if (myNewInput == "yes"):
            myFun1()
            return
        else:
            print "Goodbye"
            myFun3()
            return

def myFun3():
    exit()

myFun1()
