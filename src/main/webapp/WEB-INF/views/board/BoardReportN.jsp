<%@ page contentType="text/html;charset=utf-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="FCK" uri="http://java.fckeditor.net" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>
</title>

<%@ include file="../common/commBoardInclude.jsp" %>

</head>

<script type="text/javascript">

var preUrl = "/board/"; 

$(document).ready(function() {
	$("#attachFrame").attr("src","/board/attachI.do?" + "pSeq=${set.condiVO.seq}&kind=B_REPORT&mode=TEMP");
	$("textarea[name='contents']").cleditor();
	$("textarea[name='contents']").val("");
});

function lfn_btn(pKind, pParam) {
	if ( pKind =="save" ) {
		if ( lfn_validate() == false )
			return false;
		
		if ( confirm("저장하시겠습니까?") == false )
			return false;
		
		btnUnbind("saveBtn");
		$.ajax({
			type :"POST",
			url : context + preUrl + "boardReportIns.do",
			dataType :"json",
			data : $("#frm").serialize(),
			success : function(json){
				if ( json.rtnMode == "INSERT_OK") {
					lfn_btn("list");
				}
			},
			error : function(e) {
				alert("<spring:message code="lms.msg.systemError" text="-" />");
			}
		})
	} else if ( pKind =="list" ) {
		gfn_goPage(preUrl + "boardReportList",top.gCondition.boardReport.param); 
	}
}

function lfn_validate() {
	if ($("#title").val() == "") {
	    alert('제목을 입력해 주세요.');
	    $("#title").select();
	    return false;
	}  
	
	if ($("textarea[name='contents']").val() == "") {
	    alert('내용을 입력해주세요.');
	    return false;
	} 
	
	if ( formValid.check("title",{maxLeng:200}) == false )
		return false;
	if ( checkByte($("textarea[name='contents']").val()) > board_contents_length ) {
		alert("입력 가능한 자릿수를 넘었습니다. (" + checkByte($("textarea[name='contents']").val()) + ")");
		$("textarea[name='contents']").Focus();
		return false;
	}	
	
	return true;
}


</script>

<body>


<form id="frm" name="frm" action="" method="post" enctype="multipart/form-data">
	<input id="courseId" name="courseId" value="${set.condiVO.courseId}" type="hidden"/>
	<input id="isPopup" name="isPopup" value="${set.condiVO.isPopup}" type="hidden"/>

<div id="wrap">
	<div id="container">
    	<div id="contents">
<c:if test="${set.condiVO.courseId eq 0}"> 
      		<div id="content_head">
        		<h1 class="title">레포트</h1>
        		<ul class="gnb">
	          		<li>HOME</li>
	          		<li>게시물 관리</li>
	          		<li class="last">레포트</li>
        		</ul>
			</div>
</c:if>

			<div id="article">
				<%-- 조건 --%>
		    	<h3 class="title">게시물 생성</h3>
		      	
				<table class="input">
					<caption></caption>
					<thead>
					  	<tr class="guide">
	  						<th width="130"></th>
	  						<th></th>
	  					</tr>
					</thead>
					<tbody>
						<tr>
							<th>제목</th>
							<td class="no_line"><input id="title" name="title" type="text" value=""/></td>
						</tr>
						<tr>
							<th>내용</th>
							<td class="textbox no_line">
								<textarea id="contents" name="contents"></textarea>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td class="textbox no_line">
								<iframe id="attachFrame" name="attachFrame" style="width:675px;height:100px"></iframe>
							</td>
						</tr>
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

</body>
</html>


