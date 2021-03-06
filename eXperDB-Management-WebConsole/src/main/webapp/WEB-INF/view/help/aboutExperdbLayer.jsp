<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<div id="pop_layer_aboutExperdb" class="pop-layer">
	<div class="pop-container">
		<div class="pop_cts" style="width: 40%; padding: 20px; margin: 0 auto;">
			<p class="tit" style="margin-bottom: 15px;">
				About eXperDB
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_aboutExperdb'), 'off');" style="float: right;"><img src="/images/ico_state_01.png"/></a>
			</p>
			<img src="../../images/popup/ico_logo.png" alt="eXperDB" style="margin: 0 auto; display: block; margin-bottom: 20px;"> 
			<table class="view">
				<caption>version,copyright</caption>
				<colgroup>
					<col style="width: 170px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="t1">Version</th>
						<td id="version"></td>
					</tr>
					<tr>
						<th scope="row" class="t1">Copyright</th>
						<td>2019, The eXperDB-Management Development Team</td>
					</tr>
					<tr>
						<th scope="row" class="t1" rowspan="3">Community</th>
						<td><a href="https://github.com/experdb/eXperDB-Management" target="_blank">https://github.com/experdb/eXperDB-Management</a></td>
					</tr>
					<tr>
						<td><a href="https://www.facebook.com/experdb" target="_blank">https://www.facebook.com/experdb</a></td>
					</tr>
					<tr>
						<td><a href="http://cafe.naver.com/psqlmaster" target="_blank">http://cafe.naver.com/psqlmaster</a></td>
					</tr>
				</tbody>
			</table>
			<br><br><br><br><br><br>
			<div class="btn_type_02">
				<a href="#n" class="btn"
					onclick="toggleLayer($('#pop_layer_aboutExperdb'), 'off');"><span><spring:message code="common.close"/></span></a>
			</div>
		</div>
	</div>
	<!-- //pop-container -->
</div>