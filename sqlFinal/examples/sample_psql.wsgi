import psycopg2
def application(environ, start_response):
    status = '200 OK'
    output = '<html><head><title>Sample Python Script</title></head>\n'

    # connect
    dbcnx = psycopg2.connect(host="dbdev.cs.uiowa.edu",port=5432,dbname="dbdevtest",user="dbdevtest",password="XiuyD=jP")
   
    sqlquery="""SELECT ename, salary, dno FROM Emp;"""
   
    # create a database cursor
    cursor = dbcnx.cursor()
   
    # execute SQL select 
    cursor.execute(sqlquery)
    rows = cursor.fetchall()
    
    output += "<h2> %s </h2>"
    output %= sqlquery
    output += "<table><tr><th>Name</th><th>Salary</th><th>dno</th></tr>\n"
   

    # get and display one row at a time
    for row in rows:
       output += "<tr><td> %s </td>\n"
       output %= row[0]
       output += "    <td> %s </td>\n"
       output %= row[1]
       output += "    <td> %s </td></tr>\n"
       output %= row[2]
   
    output += "</table>\n"
    output += "</body></html>\n"

    response_headers = [('Content-type', 'text/html'),
                        ('Content-Length', str(len(output)))]

    start_response(status, response_headers)

    return [output]

