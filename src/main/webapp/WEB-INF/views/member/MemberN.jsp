<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.Calendar"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>
</title>

<%@ include file="../common/commAdminInclude.jsp" %>


</head>

<script type="text/javascript">
var preUrl = "/member/"; 

<%
Calendar c = Calendar.getInstance();
String year = Integer.toString(c.get(Calendar.YEAR));
%>

$(document).ready(function() {
	$("#birthDay").datepicker({ 
		changeMonth: true,
		changeYear: true,
		yearRange:'<%="1950"%>:',
		showMonthAfterYear: true,
		autoSize: false,
		buttonImage: '<c:url value="/resources/datepicker/images/calendar.gif"/>',
		buttonImageOnly: true,
		showOn: "button",
		beforeShow: function(input) {
		   	var i_offset= $(input).offset();
		   	setTimeout(function(){
		      	$('#ui-datepicker-div').css({'top':i_offset.top + 20 + document.body.scrollTop, 'bottom':'', 'left':i_offset.left});      //datepicker의 div의 포지션을 강제로 input 위치에 그리고 좌측은 모바일이여서 작기때문에 무조건 10px에 놓았다.
		   	})
		} 
	});
});

function lfn_btn(pKind, pParam) {
	if ( pKind =="save" ) {
		if ( lfn_validate() == false )
			return false;
		
		if ( confirm("생성하시겠습니까?") == true ) {
			btnUnbind("saveBtn");
			$.ajax({
				type :"POST",
				url : context + preUrl + "memberInsert.do",
				dataType :"json",
				data : $("#frm").serialize(),
				success : function(json){
					if ( json.rtnMode == "INSERT_OK") {
						alert("정상적으로 등록 되었습니다.");
						
						lfn_goBack();
					}
				},
				error : function(e) {
					alert("<spring:message code="lms.msg.systemError" text="-" />");
				}
			})
		}
	} else if ( pKind =="isExistUserId" ) {
		if ( $("#userId").val() == "" ) {
			alert("회원 아이디를 입력하셔야 합니다.");
			$("#userId").focus();
			return false;
		}

		btnUnbind("checkBtn");
		$.ajax({
			type :"POST",
			url : context + preUrl + "isExistUserId.do",
			dataType :"json",
			data : $("#frm").serialize(),
			success : function(json){
				if ( json.rtnMode == "EXIST") {
					alert("등록된 회원 아이디 입니다.");
					$("#userId").focus();
				} else {
					alert("등록 가능한 회원 아이디 입니다.");
					$("#userIdCheck").val("Y");
				}
				
				btnBind("checkBtn");
			},
			error : function(e) {
				alert("<spring:message code="lms.msg.systemError" text="-" />");
			}
		})
	} else if ( pKind =="list" ) {
		lfn_goBack();
	}
}

function lfn_goBack() {
	if ( "<c:out value="${set.condiVO.screen}"/>" == "compUser" )
		gfn_goPage("/compUser/compUserList",top.gCondition.compUser.param);
	else if ( "<c:out value="${set.condiVO.screen}"/>" == "admin" )
		gfn_goPage("/member/memberList",top.gCondition.member.param);
}

function lfn_validate() {
	if ( formValid.check("userId",{isNecess:true,maxLeng:15}) == false ) return false;
	if ( formValid.check("userName",{isNecess:true,maxLeng:20}) == false ) return false;
	if ( formValid.check("userPassword",{isNecess:true,maxLeng:15}) == false ) return false;
	if ( formValid.check("userPassword2",{isNecess:true,maxLeng:15}) == false ) return false;
	if ( formValid.check("sex",{isNecess:true}) == false ) return false;
	if ( formValid.check("birthDay",{isNecess:true}) == false ) return false;
	if ( $("#userPassword").val() != $("#userPassword2").val() ) {
		alert("비밀번호는 일치해야 합니다.");
		$("#userPassword2").focus();
		return false;
	}
	if ( formValid.check("mobile1",{isNecess:true,maxLeng:3}) == false ) return false;
	if ( formValid.check("mobile2",{isNecess:true,maxLeng:4}) == false ) return false;
	if ( formValid.check("mobile3",{isNecess:true,maxLeng:4}) == false ) return false;
	if ( formValid.check("email",{isNecess:true,maxLeng:50,isEmail:true}) == false ) return false;
	if ( formValid.check("homeAddr2",{isNecess:false,maxLeng:40}) == false ) return false;
	if ( $("#userIdCheck").val() != "Y" ) {
		alert("회원 아이디 검색을 하셔야 합니다.");
		$("#userId").focus();
		return false;
	}

	if ( $("#homeZipcodeSeq").val() == "" ) 
		$("#homeZipcodeSeq").val("0");
	
	return true;
}

</script>

<body>


<form id="frm" name="frm" method="post">
	<input type="hidden" id="compCd" name="compCd" value="<c:out value="${set.condiVO.compCd}"/>">

<div id="wrap">
	<div id="container">
    	<div id="contents">
      		<div id="content_head">
<c:choose>
	<c:when test="${set.condiVO.screen eq 'compUser'}">
        		<h1 class="title">직원 관리</h1>
        		<ul class="gnb">
	          		<li>HOME</li>
	          		<li>직원 관리</li>
	          		<li class="last">직원 관리</li>
        		</ul>	          		
	</c:when>
	<c:otherwise>
        		<h1 class="title">사용자 관리</h1>
        		<ul class="gnb">
	          		<li>HOME</li>
	          		<li>사용자</li>
	          		<li class="last">사용자 관리</li>
        		</ul>
	</c:otherwise>
</c:choose>        		
			</div>

			<div id="article">
				<%-- 조건 --%>
		    	<h3 class="title">사용자 생성</h3>
		      	
				<table class="input">
					<caption></caption>
					<thead>
					  	<tr class="guide">
	  						<th width="130"></th>
	  						<th></th>
	  					</tr>
					</thead>
					<tbody>
						<tr class="bn">
							<th>회원 아이디 *</th>
							<td class="no_line">
								<input type="text" id="userId" name="userId" value="">
								<input type="hidden" id="userIdCheck" name="userIdCheck" value="">
								<a href="#" id="checkBtn" onClick="javascript:lfn_btn('isExistUserId'); return false;" class="blueBtn">중복체크</a>
							</td>
						</tr>
						<tr>
							<th>이름 (국문) *</th>
							<td class="no_line"><input type="text" id="userName" name="userName" value=""></td>
						</tr>
						<tr>
							<th>비밀번호 *</th>
							<td class="no_line"><input type="password" id="userPassword" name="userPassword" value=""></td>
						</tr>
						<tr>
							<th>비밀번호 확인 *</th>
							<td class="no_line"><input type="password" id="userPassword2" name="userPassword2" value=""></td>
						</tr>
						<tr>
							<th>성별 *</th>
							<td class="no_line">
								<select id="sex" name="sex">
									<option value=""></option>
									<option value="M">남</option>
									<option value="F">여</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>생년월일 *</th>
							<td class="no_line"><input id="birthDay" name="birthDay" maxlength="10" size="10" style="width:70px" class="datePicker" style="ime-mode:disabled;" value=""/></td>
						</tr>
						<tr>
							<th >전화번호</th>
							<td class="no_line">
								<select id="homeTel1" name="homeTel1">
					              	<option value="">전체</option>
									<c:forEach var="row" items="${set.ddTel}">
						              	<option value="${row.ddKey}">${row.ddValue}</option>
									</c:forEach>
								</select>
								-
								<input type="text" id="homeTel2" name="homeTel2" style="width:60px" maxlength="4" title="전화번호 중간 번호">
								-
								<input type="text" id="homeTel3" name="homeTel3" style="width:60px" maxlength="4" title="전화번호 마지막 번호">
							</td>
						</tr>
						<tr>
							<th>휴대전화번호 *</th>
							<td class="no_line">
								<select id="mobile1" name="mobile1">
					              	<option value="">전체</option>
									<c:forEach var="row" items="${set.ddMobile}">
						              	<option value="${row.ddKey}">${row.ddValue}</option>
									</c:forEach>
								</select>
								-
								<input type="text" id="mobile2" name="mobile2" style="width:60px" maxlength="4" title="휴대전화 중간 번호">
								-
								<input type="text" id="mobile3" name="mobile3" style="width:60px" maxlength="4" title="휴대전화 마지막 번호">
							</td>
						</tr>
						<tr>
							<th>이메일주소 *</th>
							<td class="no_line"><input type="text" id="email" name="email" style="width:450px" title="이메일입력"></td>
						</tr>
						<tr>
							<th >주소</th>
							<td class="no_line">
								<input type="hidden" id="homeZipcodeSeq" name="homeZipcodeSeq">
								<input type="text" id="homeZip1" name="homeZip1" style="width:60px" maxlength="3" title="우편번호앞자리" readonly>
								-
								<input type="text" id="homeZip2" name="homeZip2" style="width:60px" maxlength="3" title="우편번호뒷자리" readonly>
								<a href="#ziplcode" onClick="javascript:f_popup('/ns/getZipcode',{displayName:'zipcode',option:'width=400,height=600'})"><img src="<c:url value="/resources/images/btn/btn_zipcode.gif"/>" alt="우편번호 찾기"></a><br>
								<input type="text" id="homeAddr1" name="homeAddr1" style="width:255px;margin-top:2px" title="주소" readonly>
								<input type="text" id="homeAddr2" name="homeAddr2" style="width:255px;margin-top:2px" title="상세주소">
													
							</td>
						</tr>
						<tr>
							<th >직급</th>
							<td class="no_line">
								<select id="job" name="job">
					              	<option value="">전체</option>
									<c:forEach var="row" items="${set.ddJob}">
						              	<option value="${row.ddKey}">${row.ddValue}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<c:if test="${set.condiVO.screen eq 'admin'}">
							<tr>
								<th>어드민 여부</th>
								<td class="no_line">
									<select id="adminYn" name="adminYn">
										<option value="N">N</option>
										<option value="A">Admin</option>
										<option value="C">Contents Admin</option>
										<option value="M">Manage Admin</option>
									</select>
								</td>
							</tr>
							<tr>
								<th>강사 여부</th>
								<td class="no_line">
									<select id="teacherYn" name="teacherYn">
										<option value="N">N</option>
										<option value="Y">Y</option>
									</select>
								</td>
							</tr>
							<tr>
								<th>튜터 여부</th>
								<td class="no_line">
									<select id="tutorYn" name="tutorYn">
										<option value="N">N</option>
										<option value="Y">Y</option>
									</select>
								</td>
							</tr>
						</c:if>		
					</tbody>
				</table>
				
				<%-- 하단버튼 --%>
		  		<div class="tool_btn">
					<a href="#" id="saveBtn" onclick="javascript:lfn_btn('save'); return false;" class="blueBtn">저장</a>
					<a href="#" onclick="javascript:lfn_btn('list'); return false;" class="blueBtn">리스트</a>
		  		</div>
			</div>
			<!-- end content body -->
		</div>
	</div>
</div>

</form>
	
</body>
</html>



</div>
</div>
	