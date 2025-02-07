<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>

<!DOCTYPE html>
<html>
 <% 
 
//  크로스사이트스크립트 테스트용사이트
   	String userID = null;
   	if(session.getAttribute("userID")!= null){
   		userID = (String) session.getAttribute("userID");
   	}
   	
   	if(userID == null){  //비로그인시 접근 불가 에어리어
   		session.setAttribute("messageType", "오류 메세지");
   		session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
   		response.sendRedirect("index.jsp");
   		return;
   	}
   	
   	UserDTO user = new UserDAO().getUser(userID);
   %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1">
<title>유저 채팅</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">

	function getUnread(){
		
		$.ajax({
			type:"POST",
			url: "./chatUnread",
			data: {
				
				userID : encodeURIComponent('<%=userID%>'),
			},
			success: function(result){
				if(result >= 1){
					showUnread(result);
				}else{
					showUnread('');
				}
			}
			
		});
	}
	function getInfiniteUnread(){
		setInterval(function(){
			getUnread();
		}, 4000);
	}
	function showUnread(result){
		
		$('#unread').html(result);
	}
	
	function passwordCheckFunction(){
		var userPassword1 = $('#userPassword').val();
		var userPassword2 = $('#userPassword2').val();
		if(userPassword1 != userPassword2 ){
			$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
		}else{
			$('#passwordCheckMessage').html('');
			
		}
		
		

		
		
	}
	
</script>

</head>
<body>
	
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
					aria-expanded="false">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index.jsp">레시피</a>
			</div>
			<div class="collapse navbar-collapse"
				id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li class="active"><a href="index.jsp">메인</a></li>
					


					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">가격대 별 메뉴<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="menuView.jsp">전체 메뉴보기</a></li>
							<li><a href="menu2000Won.jsp">2000원 이하 메뉴</a></li>
							<li><a href="menu4000Won.jsp">4000원 이하 메뉴</a></li>
							<li><a href="menu6000Won.jsp">6000원 이하 메뉴</a></li>
							<li><a href="menu8000Won.jsp">8000원 이하 메뉴</a></li>
							<li><a href="menu8001Won.jsp">그외 비싼 메뉴</a></li>
						</ul></li>

					<li><a href="searchMenu.jsp">이 재료로 뭐먹을 수 있을까?</a></li>
					<li><a href="itemWrite.jsp">재료 등록</a></li>
					<li><a href="find.jsp">친구 찾기</a></li>
					<li><a href="box.jsp">메세지함<span id="unread"
							class="label label-info"></span></a></li>
					<li><a href="boardView.jsp">자유 게시판</a></li>

				</ul>

				<%
					if (userID == null) {
						
				%>
				<ul class="nav navbar-nav navbar-right">


					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="login.jsp">로그인</a></li>
							<li><a href="join.jsp">회원가입</a></li>
						</ul></li>

				</ul>


				<%
					} else {
						String Profile = new UserDAO().getProfile(userID);
				%>

				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리 <span class="caret"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="update.jsp">회원 정보 수정</a></li>
							<li><a href="profileUpdate.jsp">프로필 수정</a></li>
							<li><a href="logoutAction.jsp">로그아웃</a></li>
						</ul></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a href="#"><%=userID%> 회원님 환영합니다</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><img class="media-object img-circle"
						style="width: 30px; height: 30px; margin-top: 20px;"
						src="<%=Profile %>" alt=""></li>
				</ul>
				<%
					}
				%>

			</div>
		</div>
	</nav>
	
	<div class="container">
		<form method="get" action="userUpdateAction.jsp">
			<table class="table table-bordered table-hover"
				style="text-align: center; border: 1px solid #dddddd">

				<thead>
					<tr>
						<th colspan="2"><h3>회원정보 수정양식</h3></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><h5><%=user.getUserID() %></h5>
						<input type="hidden" name="userID" value="<%= user.getUserID() %>"></td>
						
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();"
							class="form-control" id="userPassword" type="text"
							name="userPassword" maxlength="20" placeholder="비밀번호를 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호 확인</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();"
							class="form-control" id="userPassword2" type="text"
							name="userPassword2" maxlength="20" placeholder="비밀번호 한번더 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>이름</h5></td>
						<td colspan="2"><input class="form-control" id="userName"
							type="text" name="userName" maxlength="20"
							placeholder="이름을 입력하세요" value="<%=user.getUserName() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>나이</h5></td>
						<td colspan="2"><input class="form-control" id="userAge"
							type="number" name="userAge" maxlength="20"
							placeholder="나이를 입력하세요" value="<%= user.getUserAge() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>성별</h5></td>
						<td colspan="2">
							<div class="form-group"
								style="text-align: center; margin: 0 auto;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary active"> <input
										type="radio" name="userGender" autocomplete="off" value="남자" <%if(user.getUserGender().equals("남자")) out.print("chekced"); %>
										checked>남자
									</label> <label class="btn btn-primary"> <input type="radio"
										name="userGender" autocomplete="off" value="여자" <%if(user.getUserGender().equals("여자")) out.print("chekced"); %>>여자
									</label>
								</div>
							</div>
					</tr>

					<tr>
						<td style="width: 110px;"><h5>이메일</h5></td>
						<td colspan="2"><input class="form-control" id="userEmail"
							type="email" name="userEmail" maxlength="20"
							placeholder="이메일을 입력하세요" value="<%= user.getUserEmail() %>"></td>
					</tr>
					<tr>
						<td style="text-align: left;" colspan="3"> <h5 style="color: red;" id="passwordCheckMessage" ></h5> <input class="btn btn-primary pull-right"	type="submit"  value="수정"></td>
					</tr>

				</tbody>
			</table>
		</form>
	</div>
	
	

	<%
		String messageContent = null;
		if(session.getAttribute("messageContent")!= null){
			messageContent = (String)session.getAttribute("messageContent");
		}
		String messageType = null;
		if(session.getAttribute("messageContent")!= null){
			messageType = (String)session.getAttribute("messageType");
		}
		if(messageContent != null){
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
		    <div class="modal-dialog vertical-align-center">
			   <div class="modal-content <%if(messageType.equals("오류메세지")) out.println("panel-warning"); else out.println	("panel-success"); %>">
		     	    <div class="modal-header panel-heading">
				      <button type="button" class="close" data-dismiss="modal">
				      	 	<span aria-hidden="true">&times</span>
					  		   <span class="sr-only">Close</span>
				 				     </button>
				 		   			    <h4 class="modal-title">
				   					   	<%=messageType %>
			       					 	</h4>
								   </div>
			      			    <div class="modal-body">
									<%=messageContent %>
								</div>
								<div class="modal-footer">
								<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
		     					</div>
						</div>
					</div>	
				</div>
		</div>
	
	

	<script >
		$('#messageModal').modal("show");
	</script>
	
	<% 
			session.removeAttribute("messageContent");
			session.removeAttribute("messageType");
		}
	%>
	
	<%
		if(userID != null){  //사용자가 성공적으로 로그인을 한 상태라면
	%>
		<script type="text/javascript">
			$(document).ready(function(){
			getUnread();
			getInfiniteUnread();	
		
			});
			</script>
	<%
			}
	%>
	
	
	
</body>
</html>
	
	
	