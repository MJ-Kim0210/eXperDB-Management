<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>" />

<script src="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script> 
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>
var scd_id = ${scd_id};

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#workList').DataTable({
	scrollY : "245px",
	scrollX : true,
	bDestroy: true,
	processing : true,
	searching : false,	
	bSort: false,
	columns : [
	{data : "idx", className : "dt-center", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]],  defaultContent : ""},
	{data : "wrk_id",  defaultContent : "", visible: false },
	{data : "db_svr_nm",  defaultContent : ""}, //서버명
	{data : "bsn_dscd_nm",  defaultContent : ""},
	{data : "bck_bsn_dscd_nm",  defaultContent : ""}, //구분
	{data : "wrk_nm", className : "dt-left", defaultContent : ""
		,"render": function (data, type, full) {
			if(full.bsn_dscd_nm != "MIGRATION"){
			  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
			}else{
				return '<span title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
			}
		}
	}, //work명
	{ data : "wrk_exp",
		render : function(data, type, full, meta) {	 	
			var html = '';					
			html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
			return html;
		},
		defaultContent : ""
	},
	{data : "nxt_exe_yn", className: "dt-center", defaultContent: ""}
	]
});

    table.on( 'order.dt search.dt', function () {
    	table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
    
}


/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();


 	$.ajax({
		url : "/selectWrkScheduleList.do",
		data : {
			scd_id : scd_id
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {	
			table.rows({selected: true}).deselect();
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
	
});

</script>
<style>
#workinfo{
	width: 50% !important;
	height: 500px !important;
	margin-top: 0px !important;
}

#scriptInfo{
	width: 60% !important;
	height: 500px !important;
	margin-top: 0px !important;
}
</style>
<%@include file="../cmmn/commonLocale.jsp"%>  
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/workScriptInfo.jsp"%>

<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">
			<spring:message code="schedule.workList" />
		</p>
		<div class="overflow_area">
			<table id="workList" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th width="30"><spring:message code="common.no" /></th>
						<th width="0"></th>
						<th width="100"><spring:message code="data_transfer.server_name" /></th>
						<th width="100"><spring:message code="common.division" /></th>	
						<th width="130"><spring:message code="backup_management.detail_div"/></th>		
						<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
						<th width="300" class="dt-center"><spring:message code="common.work_description" /></th>
						<th width="80"><spring:message code="schedule.onerror" /></th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01"> </span> <a href="#n" class="btn" onclick="window.close();"><span>
			<spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</html>