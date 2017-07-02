import MySQLdb

s = """ %s """

def index(req):
   message = "<html><head><title>Sample Python Script</title></head>\n"
   # connect
   dbcnx = MySQLdb.connect(host="dbdev.cs.uiowa.edu",port=3306,user="dbdevtest",passwd="XiuyD=jP",db="WorksOn")
   
   sqlquery="""SELECT ename, salary, dno FROM Emp;"""
   
   # create a database cursor
   cursor = dbcnx.cursor()
   
   # execute SQL select 
   cursor.execute(sqlquery)
   
   message += "<h2> %s </h2>"
   message %= sqlquery
   message += "<table><tr><th>Name</th><th>Salary</th><th>dno</th></tr>\n"
   
   # get the number of rows in the resultset
   numrows = int(cursor.rowcount)
   
   # get and display one row at a time
   for x in range(0,numrows):
       row = cursor.fetchone()
       message += "<tr><td> %s </td>\n"
       message %= row[0]
       message += "    <td> %s </td>\n"
       message %= row[1]
       message += "    <td> %s </td></tr>\n"
       message %= row[2]
   
   message += "</table>\n"
   message += "</body></html>\n"
   cursor.close ()
   dbcnx.close ()
   return s % (message)

   
       
