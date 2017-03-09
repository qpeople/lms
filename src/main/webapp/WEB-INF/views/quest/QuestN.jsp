<%@ page contentType="text/html;charset=utf-8"%>

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
function lfn_btn(pKind, pParam) {
	if ( pKind =="save" ) {
		if ( lfn_validate() == false )
			return false;
		
		if ( confirm("생성하시겠습니까?") == true ) {
			btnUnbind("saveBtn");
			$.ajax({
				type :"POST",
				url : context +"/quest/questIns.do",
				dataType :"json",
				data : $("#frm").serialize(),
				success : function(json){
					if ( json.rtnMode == "EXIST") {
						alert("<spring:message code="lms.msg.existData" text="-" />");
						btnBind("saveBtn");
					} else if ( json.rtnMode == "INSERT_OK") {
						alert("<spring:message code="lms.msg.insertOk" text="-" />");
						lfn_btn("list");
					}
				},
				error : function(e) {
					alert("<spring:message code="lms.msg.systemError" text="-" />");
				}
			})
		}
	} else if ( pKind =="list" ) {
		gfn_goPage('/quest/questList'); 
	}
}

function lfn_validate() {
	//Validation 검사
	
	if ( formValid.check("qgId",{isNecess:true}) == false )
		return false;
	
	var totalGrade = 0;
	
	seqs = $("[id=seqs]");
	types = $("[id=types]");
	questions = $("[id=questions]");
	qa1s = $("[id=qa1s]");
	qa2s = $("[id=qa2s]");
	qa3s = $("[id=qa3s]");
	qa4s = $("[id=qa4s]");

	for ( i = 0; i < seqs.length; i++ ) {
		if ( formValid.check("seqs",{isNecess:true,isNum:true,maxLeng:2},i) == false )
			return false;
		if ( formValid.check("questions",{isNecess:true,maxLeng:400},i) == false )
			return false;
		if ( types[i].value == "G" ) {
			if ( formValid.check("qa1s",{isNecess:true,maxLeng:200},i) == false )
				return false;
			if ( formValid.check("qa2s",{isNecess:true,maxLeng:200},i) == false )
				return false;
			if ( formValid.check("qa3s",{isNecess:true,maxLeng:200},i) == false )
				return false;
			if ( formValid.check("qa4s",{isNecess:true,maxLeng:200},i) == false )
				return false;
		}
		//순번 검사
		for ( m = i + 1; m < seqs.length; m++ ) {
			if ( $(seqs[i]).val() == $(seqs[m]).val() ) {
				alert("같은 순번이 존재합니다.");
				$(seqs[m]).select();
				return false;
			}
		}
	}
		
	return true;
}

function f_add() {
	var cnt = $("[id=seqs]").length;
	
	var newitem = $("#mainTbl tr:eq(2)").clone();
    $("#mainTbl").append(newitem);
    
    //초기화
    $("[id=seqs]")[cnt].value = "";
    $("[id=types]")[cnt].value = "G";
    $("[id=questions]")[cnt].value = "";
    $("[id=qa1s]")[cnt].value = "";
    $("[id=qa2s]")[cnt].value = "";
    $("[id=qa3s]")[cnt].value = "";
    $("[id=qa4s]")[cnt].value = "";
}

function f_delete(obj) {
	if($("#mainTbl tr").length < 7){
		alert("<spring:message code="lms.msg.noDeleteMore" text="-" />");
		return false;
	}
	   
    jQuery(obj).parent().parent().remove();
    
    $("#mainTbl tr").removeClass("alt");
    $("#mainTbl tr:even").addClass("alt");
}

function lfn_comboChg() {
	var types = $("[id=types]");
	var qa1s = $("[id=qa1s]");
	var qa2s = $("[id=qa2s]");
	var qa3s = $("[id=qa3s]");
	var qa4s = $("[id=qa4s]");

	for ( i = 0; i < types.length; i++ ) {
		if ( types[i].value == "G" ) {
			$(qa1s[i]).removeAttr("readonly"); 
			$(qa2s[i]).removeAttr("readonly"); 
			$(qa3s[i]).removeAttr("readonly"); 
			$(qa4s[i]).removeAttr("readonly"); 
		} else {
			qa1s[i].value = "";
			qa2s[i].value = "";
			qa3s[i].value = "";
			qa4s[i].value = "";
			
			$(qa1s[i]).attr("readonly","readolny"); 
			$(qa2s[i]).attr("readonly","readolny"); 
			$(qa3s[i]).attr("readonly","readolny"); 
			$(qa4s[i]).attr("readonly","readolny"); 
		}
	}
}

</script>

<body>

<form id="frm" name="frm" action="" method="post">
<div id="wrap">
	<div id="container">
    	<div id="contents">
      		<div id="content_head">
        		<h1 class="title">설문지 관리</h1>
        		<ul class="gnb">
	          		<li>HOME</li>
	          		<li>설문관리</li>
	          		<li class="last">설문지 관리</li>
        		</ul>
			</div>

			<div id="article">
		    	<h3 class="title">설문지 생성</h3>

		      	<%-- 조건 --%>
		      	<div id="search">
		      		<div class="search_1">
		              	<label for="qgId">설문지 그룹명</label>
		              	<select id="qgId" name="qgId">
			              	<option value="">전체</option>
							<c:forEach var="row" items="${set.ddQuestGroup}">
				              	<option value="${row.ddKey}">${row.ddValue}</option>
							</c:forEach>
						</select>
		            </div>
		   		</div>
		   		
				<%-- 테이블 --%>
		   		<table summary="" id="mainTbl">
					<caption></caption>
					<thead>
					  	<tr class="guide">
	  						<th width="60"></th>
	  						<th width="75"></th>
	  						<th></th>
	  						<th width="60"></th>
  						</tr>
						<tr>
							<th>순번</th>
							<th>타입</th>
							<th>질문</th>
							<th class="no_line">삭제</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach begin="1" end="20" varStatus="idx">
				            <tr <c:if test="${idx.count%2 eq 1}"> class="alt"</c:if>>
				              	<td class="subject"><input id="seqs" name="seqs" value="${idx.index}" style="width:40px"/></td>
				              	<td class="subject">
				              		<select id="types" name="types" onchange="lfn_comboChg()">
				              			<option value="G">객관식</option>
				              			<option value="J">주관식</option>
				              		</select>
				              	</td>
				              	<td class="subject">
				              		<input id="questions" name="questions" value="question - ${idx.index}" style="width:490px"/><br>
				              		<input id="qa1s" name="qa1s" value="val1" style="width:115px"/>
				              		<input id="qa2s" name="qa2s" value="val2" style="width:117px"/>
				              		<input id="qa3s" name="qa3s" value="val3" style="width:120px"/>
				              		<input id="qa4s" name="qa4s" value="val4" style="width:120px"/>
				              	</td>
				              	<td class="no_line subject">
				              		<a href="#" onclick="f_delete(this)" class="blueBtn">삭제</a>
				              	</td>
				            </tr>
						</c:forEach>
					</tbody>
				</table>
				
				<%-- 하단버튼 --%>http://localhost:8080/quest/questV.do#
		  		<div class="tool_btn">
					<a href="#" onclick="f_add()" class="blueBtn">추가</a>
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


