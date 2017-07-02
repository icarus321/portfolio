import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HelloServlet
    extends HttpServlet {

 int num = 0;

    public void doGet(HttpServletRequest request, 
                       HttpServletResponse response)
                throws IOException, ServletException {
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<html>");
		out.println("<head><title>Hello World Servlet</title></head>");
		out.println("<body>");		
		out.println("<H2>Hello World Change!!</H2>");
		num++;
		out.println("<H3>This servlet has been called: "+num+" times.</H3>");
		out.println("</body></html>");

	}

}


