package user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



@WebServlet("/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		String userPassword1 = request.getParameter("userPassword1");
		String userPassword2 = request.getParameter("userPassword2");
		String userName = request.getParameter("userName");
		String userAge = request.getParameter("userAge");
		String userGender = request.getParameter("userGender");
		String userEmail = request.getParameter("userEmail");
		
		if(userID == null || userID.equals("") || userPassword1 == null || userPassword1.equals("")
				||userPassword2 == null || userPassword2.equals("") || userName == null || userName.equals("")
				||userAge == null || userAge.equals("") || userGender == null || userGender.equals("")
				||userEmail == null || userEmail.equals("") )
		{
			request.getSession().setAttribute("messageType", "오류메세지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요");
			
			response.sendRedirect("update.jsp");
			return;
		}
		//세션값 본인 검증
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))){
			session.setAttribute("messageType", "오류 메세지");
	   		session.setAttribute("messageContent", "접근 할 수 없습니다.");
	   		response.sendRedirect("index.jsp");
	   		
		}
		
				
		if(!userPassword1.equals(userPassword2)) {
			request.getSession().setAttribute("messageType", "오류메세지");
			request.getSession().setAttribute("messageContent", "비밀번호가 서로 다릅니다");
			response.sendRedirect("update.jsp");
			return;
		}
		int result =new UserDAO().update(userID, userPassword1, userName, userAge, userGender, userEmail);
		if(result==1) {
			request.getSession().setAttribute("userID", userID); //회원가입 성공시 자동 으로 세션유지 , 로그인
			request.getSession().setAttribute("messageType", "성공메세지");
			request.getSession().setAttribute("messageContent", "회원정보 수정에 성공했습니다");
			response.sendRedirect("index.jsp");
			return;
		}
		else {
			request.getSession().setAttribute("messageType", "오류메세지");
			request.getSession().setAttribute("messageContent", "이미 존재하는 회원 또는 데이터베이스 오류가 발생했습니다.");
			response.sendRedirect("update.jsp");
			return;
			
		}
		
	}

}
