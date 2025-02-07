package board;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


public class BoardReplyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi =  null;
		int fileMaxSize = 10* 1024 * 1024;		
		String savePath	=request.getRealPath("/upload").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath,fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		}catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "파일은 10mb를 넘을 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String userID = multi.getParameter("userID");
		//세션 검증, 타인에 대한 접근 방지
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))){
			session.setAttribute("messageType", "오류 메세지");
	   		session.setAttribute("messageContent", "접근 할 수 없습니다.");
	   		response.sendRedirect("index.jsp");
	   		return;
		}
		String boardID = multi.getParameter("boardID");
		if(boardID == null ||boardID.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
	   		session.setAttribute("messageContent", "접근 할 수 없습니다.");
	   		response.sendRedirect("index.jsp");
	   		return;
		}
		
		String boardTitle = multi.getParameter("boardTitle");
		String boardContent = multi.getParameter("boardContent");
		
		if(boardTitle == null || boardTitle.equals("") || boardContent == null || boardContent.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
	   		session.setAttribute("messageContent", "글 제목과 글 내용을 모두 채워주세요");
	   		response.sendRedirect("boardView.jsp");
	   		return;
		}
		
		String boardFile="";
		String boardRealFile="";
		
		
		File file = multi.getFile("boardFile");
		if(file != null) {
			boardFile = multi.getOriginalFileName("boardFile");
			boardRealFile = file.getName();
			
			
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO parent = boardDAO.getBoard(boardID);
		boardDAO.replyUpdate(parent);
		boardDAO.reply(userID, boardTitle, boardContent, boardFile, boardRealFile, parent);
		
		
		session.setAttribute("messageType", "성공 메세지");
   		session.setAttribute("messageContent", "성공적으로 답변을 하였습니다.");
   		response.sendRedirect("boardView.jsp");
   		return;		
				
	}

}
