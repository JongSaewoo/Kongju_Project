<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>

<!DOCTYPE html>
<html>
<head>
<% 
   	String userID = null;
   	if(session.getAttribute("userID")!= null){
   		userID = (String) session.getAttribute("userID");
   		
   	}
   	
   	String toID = null;
   	if( request.getParameter("toID")!=null ){
   		toID =(String)request.getParameter("toID");
   	}
 	if (userID == null){
   		session.setAttribute("messageType", "오류 메세지");
   		session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
   		response.sendRedirect("index.jsp");
   		return;
   	}
	if (toID == null){
   		session.setAttribute("messageType", "오류 메세지");
   		session.setAttribute("messageContent", "대화상대가 지정되어있지 않습니다.");
   		response.sendRedirect("index.jsp");
   		return;
   	}
	if(userID.equals(URLDecoder.decode(toID,"UTF-8"))){
		session.setAttribute("messageType", "오류 메세지");
   		session.setAttribute("messageContent", "자신에게는 메세지를 보낼 수 없습니다.");
   		response.sendRedirect("index.jsp");
   		return;
	}
   	
   	String fromProfile = new UserDAO().getProfile(userID);
   	String toProfile = new UserDAO().getProfile(toID);
   	//상대방의 프로파일
   %>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1">
<title>유저 채팅</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
	function autoClosingAlert(selector, delay){
		
		var alert = $(selector).alert();
		alert.show();
		window.setTimeout(function() { alert.hide()}, delay);
	}
	
	function submitFunction(){
		var fromID ='<%=userID%>';
		var toID ='<%=toID%>';
     	var chatContent =$('#chatContent').val(); 
//		var ChatContent =document.getElementById("chatContent");
		$.ajax({
			type: "POST",
			url: "./chatSubmitServlet",
			data: {
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				chatContent: encodeURIComponent(chatContent),
			},
			success: function(result){
				
				if(result == 1){
					autoClosingAlert('#successMessage',2000);
				}else if(result ==0){
					
					autoClosingAlert('#dangerMessage',2000);
				}else{
					autoClosingAlert('#warningMessage',2000);
				}
					
			}
			
		});
		$('#chatContent').val('');  //보냇으면 그다음 챗 내용을 비워준다
	}
	var lastID =0;  //chat의 마지막 아이디
	function chatListFunction(type){
		var fromID = '<%= userID %>';
		var toID = '<%= toID %>';
		$.ajax({
			type: "POST",
			url: "./chatListServlet",
			data: {
				
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				listType: type
			},
			success: function(data){
				if(data =="")return;
				var parsed = JSON.parse(data);
				var result = parsed.result;
				for(var i = 0; i<result.length; i ++){
					if(result[i][0].value ==fromID){
						result[i][0].value ='나';
					}
					addChat(result[i][0].value, result[i][2].value, result[i][3].value);
				}
				lastID = Number(parsed.last);
			}
		});
		
	}
	function addChat(chatName, chatContent, chatTime){
		if(chatName=='나'){
					$('#chatList').append('<div class="row">'+
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">'+
					'<img class="media-object img-circle" style="width: 30px; height:30px;" src="<%=fromProfile %>" alt="">'+
					'</a>' +
					'<div class="media-body">'+
					'<h4 class="medea-heading">'+
					chatName + 
					'<span class="small pull-right">'+
					chatTime +
					'</span>'+
					'</h4>'+
					'<p>'+
					chatContent +
					'</p>' +
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'<hr>');
		}else{
			$('#chatList').append('<div class="row">'+
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">'+
					'<img class="media-object img-circle" style="width: 30px; height:30px;" src="<%=toProfile %>" alt="">'+
					'</a>' +
					'<div class="media-body">'+
					'<h4 class="medea-heading">'+
					chatName + 
					'<span class="small pull-right">'+
					chatTime +
					'</span>'+
					'</h4>'+
					'<p>'+
					chatContent +
					'</p>' +
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'<hr>');
			
		}
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);	
	}
	function getInfiniteChat(){
		//몇초간격으로 새로운 메세지가 왔는지 확인
		setInterval(function(){
			chatListFunction(lastID);			
		},3000);
	}
	
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
	
</script>


</head>
<body>

<!-- CREATE TABLE CHAT( -->

<!-- chatID int PRIMARY KEY AUTO_INCREMENT, -->
<!-- fromID VARCHAR(20), -->
<!-- toID VARCHAR(20), -->
<!-- chatContent VARCHAR(100), -->
<!-- chatTime DATETIME -->
<!-- ); -->
<!-- 프라이머리키 특정값이 없을때 그냥 값이 증가해서 중복 피함 -->


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

	
	
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창</h4>
						</div>	
						<div class="clearfix"> </div>
				</div>			
				<div id="chat" class="panel-collapse collapse in">
					<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; height:600px;">
					</div>
				
					<div class="portlet-footer">
				<div class="row" style="height: 90px;">
					<div class="form-gruop col-xs-10">
						<textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="메세지를 입력하세요." maxlength="300"></textarea>
					</div>
					<div class="form-group col-xs-2">
						<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>
						<div class="clearfix"> </div>
					</div>				
				</div>
				</div>
			</div>
		</div>
	</div>
		</div>
	</div>
	
	<div class="alert alert-success" id="successMessage" style="display: none;">
		<strong> 메세지 전송에 성공했습니다.</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display: none;">
		<strong>이름과 내용을 모두 입력해 주세요</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage" style="display: none;">
		<strong>데이터 베이스 오류가 발생했습니다.</strong>
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
	<script type="text/javascript">
	$(document).ready(function() {
		//웹페이지가 다 불려졌을때
		getUnread();
		chatListFunction('0');
		getInfiniteChat();
		getInfiniteUnread();
	});	
	
	</script>
	
	
	
</body>
</html>