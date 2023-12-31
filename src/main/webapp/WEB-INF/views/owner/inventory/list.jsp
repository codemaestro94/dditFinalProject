<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<style type="text/css">
  .sortType {
	cursor: pointer;
	}
</style>

<input type="hidden" id="frcsId" value="${frcsId }">
<div class="content-page">
	<div class="content">
		<div class="container-fluid">
		    <div class="row">
		        <div class="col-12">
		            <div class="page-title-box">
		                <div class="page-title-right">
		                    <ol class="breadcrumb m-0">
		                        <li class="breadcrumb-item"><a href="javascript: void(0);">홈</a></li>
		                        <li class="breadcrumb-item"><a href="javascript: void(0);">상품 물류 관리</a></li>
		                        <li class="breadcrumb-item active">재고 관리</li>
		                    </ol>
		                </div>
		                <h4 class="page-title">재고 관리</h4>
		            </div>
		        </div>
		    </div>
		    
		    <div class="row">
		        <div class="col-12">
		            <div class="card">
		                <div class="card-body">
		                    <div class="row mb-2">
		                    <!-- 검색창 -->
		                        <div class="col-xl-8">
									<form id="searchForm" class="row gy-2 gx-2 align-items-center justify-content-xl-start justify-content-between">		                                
									<input type="hidden" name="page" id="page"/>
		                                <div class="col-auto">
		                                    <div class="d-flex align-items-center">
		                                        <label for="searchType" class="me-2"></label>
		                                        <select class="form-select" name="searchType" id="searchType">
		                                            <option value="vdprodName" <c:if test="${searchType eq 'vdprodName' }">selected</c:if>>제품명</option>
		                                            <option value="vdprodCd" <c:if test="${searchType eq 'vdprodCd' }">selected</c:if>>제품코드</option>
		                                        </select>
		                                    </div>
		                                </div>
		                                <div class="col-auto">
		                                    <label for="searchWord" class="visually-hidden">Search</label>
		                                    <input type="search" class="form-control" id="searchWord" name="searchWord" placeholder="검색어를 입력해주세요." value="${searchWord }">
		                                </div>
		                                <div class="col-auto">
		                                    <div class="d-flex align-items-center d-flex align-items-baseline">
		                                <button type="button" class="btn btn-primary" id="searchBtn">
										    <i class="mdi mdi-magnify search-icon"></i>검색                            			
		                                </button>
		                                	</div>
		                                </div>
		                            </form>                            
		                        </div>
		                        
		                        <div class="col-xl-4">
		                            <div class="text-xl-end mt-xl-0 mt-2">
		                                <button type="button" class="btn btn-light mb-2" id="inventUpdateBtn"><i class="mdi mdi-plus-circle me-2"></i>신규 제품 업데이트</button>
		                                <button type="button" class="btn btn-success mb-2" onclick="location.href='/owner/inventory/excel.do'">엑셀 다운로드</button>
		                            </div> 
		                        </div>
		                    </div>
							<br>
							<!-- 리스트 출력 -->
		                    <div class="table-responsive">
		                        <table class="table table-centered table-nowrap mb-0 table-hover">
		                            <thead class="table-light">
		                                <tr>
<!-- 		                                    <th style="width: 3%;"></th> -->
		                                    <th style="text-align:center; width:15%;" class="sortType" data-sort="vdprod_cd">제품 코드<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:15%;" class="sortType" data-sort="vdprod_name">제품명<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:12%;" class="sortType" data-sort="invntry_qy">현 재고수량<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:12%;" class="sortType" data-sort="proprt_qy">적정 재고수량<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:14%;" class="sortType" data-sort="hdforward_price">구매단가<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:12%;" class="sortType" data-sort="frcsorder_qy">이번달 입고량<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:12%;" class="sortType" data-sort="dlivy_qy">이번달 출고량<i class="searchTypeIcon ri-arrow-down-s-fill"></i></th>
		                                    <th style="text-align:center; width:15%;"></th>
		                                </tr>
		                            </thead>
		                            <tbody id="tBody">
<%-- 		                            	<c:set value="${pagingVO.dataList }" var="inventList"/> --%>
<%-- 		                            	<c:choose> --%>
<%-- 		                            		<c:when test="${empty inventList }"> --%>
<!-- 		                            			<tr> -->
<!-- 	                            					<td colspan="9" style="text-align:center"> -->
<!-- 	                            					<br> -->
<!-- 	                            						조회할 제품 재고가 존재하지 않습니다. <br> -->
<!-- 	                            					<br> -->
<!-- 	                            					</td> -->
<!-- 		                            			</tr> -->
<%-- 		                            		</c:when> --%>
<%-- 											<c:otherwise> --%>
<%-- 												<c:forEach items="${inventList }" var="invent" varStatus="stat"> --%>
<!-- 													<tr> -->
<!-- 					                                    <td></td> -->
<%-- 					                                    <td style="text-align:center">${invent.vdprodCd }</td> --%>
<%-- 					                                    <td style="text-align:center">${invent.vdprodName }</td> --%>
<!-- 						                              	<td style="text-align:center" id="invntryQytd"> -->
<%-- 														    <span id="invntryQySpan">${invent.invntryQy }</span> --%>
<%-- 														    <input type="hidden" class="invntryQyInput" type="text" value="${invent.invntryQy }" id="invntryQy" name="invntryQy"> --%>
<!-- 														</td> -->
<!-- 					                                    <td style="text-align:center" id="proprtQytd"> -->
<%-- 					                                    <span id="proprtQySpan">${invent.proprtQy }</span> --%>
<%-- 					                                		<input type="hidden" class="proprtQyInput" type="text" value="${invent.proprtQy }" id="proprtQy" name="proprtQy"> --%>
<!-- 					                                    </td> -->
<!-- 					                                    <td style="text-align:center" id="hdforwardPricetd"> -->
<%-- 					                                    	<input type="hidden" class="hdforwardPriceInput" value="${invent.hdforwardPrice }"> --%>
<%-- 					                                    	<fmt:formatNumber value="${invent.hdforwardPrice }" type="number"/>(원) --%>
<!-- 					                                    </td> -->
<!-- 					                                    <td style="text-align:center"> -->
<%-- 					                              			${invent.frcsorderQy } --%>
<!-- 					                                    </td> -->
<!-- 					                                    <td style="text-align:center"> -->
<%-- 															${invent.dlivyQy} --%>
<!-- 					                                    </td> -->
<!-- 					                                    <td style="text-align:center"> -->
<%-- 															<button type="button" class="btn btn-danger updateBtn" data-frcsid="${invent.frcsId }">수정</button> --%>
<!-- 					                                    </td> -->
<!-- 					                                </tr> -->
<%-- 												</c:forEach> --%>
<%-- 											</c:otherwise> --%>
<%-- 		                            	</c:choose> --%>
		                            </tbody>
		                        </table>
		                    </div>
		                    <br>
							<nav aria-label="Page navigation example" id="pagingArea">
							</nav>
		                </div>
		            </div>
		        </div>
		    </div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var pagingArea = $("#pagingArea");
	var searchForm = $("#searchForm");
	var tBody = $("#tBody");
	var inventUpdateBtn = $("#inventUpdateBtn");	// 신규 제품 업데이트 버튼
	var invntryQy;	// 현 재고수량 값
	var proprtQy;	// 적정 재고수량 값
	var invntryQyVal; // +- 처리 후 값
	var proprtQyVal;	// +- 처리 후 값
	var vdprodCd;	// 제품코드
	var sortTypeTh = $(".sortType");
	var searchTypeIconAll = $(".searchTypeIcon");
	var frcsId = $("#frcsId").val();
	var searchBtn = $("#searchBtn");	// 검색 버튼
	
	// 페이지 로딩될 때 list뿌림
    openPage();
	
	function openPage(){
		var searchType = $("#searchType").val();
		var searchWord = $("#searchWord").val();
		var currentPage = 1;
		var sortType = 'vdprod_cd'; 
		var sortOrder = 'asc';
		
		sortPaging(sortType,sortOrder,currentPage,searchType,searchWord);
		comparison();
	}
	
	// 검색
	searchBtn.on("click",function(){
		var searchType = $("#searchType").val();
		var searchWord = $("#searchWord").val();
		var currentPage = 1;
		var sortType = 'vdprod_cd'; 
		var sortOrder = 'asc';
		
		sortPaging(sortType,sortOrder,currentPage,searchType,searchWord);
	});
	
	// 정렬
	sortTypeTh.on("click",function(){
		var searchType = $("#searchType").val();
		var searchWord = $("#searchWord").val();
		var sortType = $(this).data("sort");	// 정렬할 th종류 가져오기
		var searchTypeIcon = $(this).find(".searchTypeIcon"); 
		var iconClassName = searchTypeIcon.attr("class");	// class명 가져오기
		var sortOrder;	// 정렬 순서
		var currentPage = 1;
		
		// down이 포함되어있으면 up으로 바꿔주고
		if(iconClassName.includes('down')){
			searchTypeIconAll.attr("class","searchTypeIcon ri-arrow-down-s-fill");
			searchTypeIcon.attr("class","searchTypeIcon ri-arrow-up-s-fill");
			sortOrder = "asc";
		}
		
		// up이 포함되어있으면 down으로 바꿔준다.
		if(iconClassName.includes('up')){
			searchTypeIcon.attr("class","searchTypeIcon ri-arrow-down-s-fill");
			sortOrder = "desc";
		}
		
		sortPaging(sortType,sortOrder,currentPage,searchType,searchWord);
	});
	
	// 페이징
	pagingArea.on("click","a",function(event){
		event.preventDefault();
		var pageNo = $(this).data("page");
		
		var searchType = $("#searchType").val();
		var searchWord = $("#searchWord").val();
		var sortType = 'vdprod_cd'; 
		var sortOrder = 'asc';
		
		sortPaging(sortType,sortOrder,pageNo,searchType,searchWord);
	});
	
	
	function sortPaging(sortType,sortOrder,currentPage,searchType,searchWord){
		
		// 뭘 기준으로 정렬할건지 , up인지 down인지 , 프랜차이즈 아이디를 보내면 된다.
		var data = {
			frcsId : frcsId,
			sortType : sortType,
			sortOrder : sortOrder,
			currentPage : currentPage,
			searchType : searchType,
			searchWord : searchWord
		}
		
		$.ajax({
			type: "post",
			url : "/owner/inventory/inventSort.do",
			beforeSend : function(xhr){	// csrf토큰 보내기 위함
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");	//key value로 보낸다.
			},
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			success : function(res){
				
				comparison();
				tBody.empty();
				pagingArea.html(res.pagingHTML);
				
				var length = res.dataList.length;
				
				for(var i=0; i<length; i++){
// 					console.log(res.dataList[i]);
					
					var invntryQyVal = parseInt(res.dataList[i].invntryQy);	// 현 재고수량 input 요소의 값
				    var proprtQyVal = parseInt(res.dataList[i].proprtQy);	// 적정 재고수량 input 요소의 값
				   
				    var style = "";
				    if (proprtQyVal >= invntryQyVal) {
				        style = 'font-weight: bold; color:red';
				    } else {
				        style = 'color:black';
				    }
				    
					var row = $("<tr>")
					  .append($("<td>").text(res.dataList[i].vdprodCd).attr('style', 'text-align:center'))
				        .append($("<td>").text(res.dataList[i].vdprodName).attr('style', 'text-align:center'))
				        .append($("<td>").attr({'style': 'text-align:center', 'id': 'invntryQytd'})
				            .append($("<span>").attr({'style' : style, 'id': 'invntryQySpan'}).text(res.dataList[i].invntryQy))
				            .append($("<input>").attr({'type': 'hidden', 'class':'invntryQyInput', 'value': res.dataList[i].invntryQy, 'id': 'invntryQy', 'name': 'invntryQy' })))
				        .append($("<td>").attr({ 'style': 'text-align:center', 'id': 'proprtQytd' })
			        		.append($("<span>").attr('id', 'proprtQySpan').text(res.dataList[i].proprtQy))
				            .append($("<input>").attr({'type': 'hidden', 'class':'proprtQyInput', 'value': res.dataList[i].proprtQy, 'id': 'proprtQy', 'name': 'proprtQy' })))
				        .append($("<td>").text(numberToString(res.dataList[i].hdforwardPrice)).attr({'style': 'text-align:center', 'id': 'hdforwardPricetd' })
				        	.append($("<input>").attr({'type': 'hidden', 'class':'hdforwardPriceInput','value': res.dataList[i].hdforwardPrice})))
				        .append($("<td>").text(res.dataList[i].frcsorderQy).attr('style', 'text-align:center'))
				        .append($("<td>").text(res.dataList[i].dlivyQy).attr('style', 'text-align:center'))
				        .append($("<td>").html('<button type="button" class="btn btn-danger updateBtn" data-frcsid="' + res.dataList[i].frcsId + '">수정</button>').attr('text-align', 'center'));
				    tBody.append(row);
				}
			}
		});
	}
	
	// 적정재고수량 이하 시, 빨간색 글씨로 경고
	function comparison(){
		$("#tBody tr").each(function(){		// tBody 안의 tr태그 선택 (forEach문으로 반복문 도는 아이들)
			var tr = $(this);	// 반복문 도는 대상 tr태그 
			var invntryQyInput = tr.find(".invntryQyInput");	// 반복문 돌고 있는 tr의 현 재고수량 input 요소
			var proprtQyInput = tr.find(".proprtQyInput");		// 반복문 돌고 있는 tr의 적정 재고수량 input 요소
			var invntryQySpan = tr.find("#invntryQySpan");		// 반목문 돌고 있는 tr의 현 재고수량 값이 감싸져있는 span 요소
			
			var invntryQyVal = parseInt(invntryQyInput.val());	// 현 재고수량 input 요소의 값
		    var proprtQyVal = parseInt(proprtQyInput.val());	// 적정 재고수량 input 요소의 값
	
		    console.log(invntryQyVal, proprtQyVal);
		    
	        // 적정재고수량보다 현 재고수량이 적거나 같으면 현 재고수량 빨갛게 보이게
	        if (proprtQyVal >= invntryQyVal) {
	        	invntryQySpan.attr("style", "font-weight: bold; color:red;");
	        }
		});
	}

	// 수정 버튼을 눌렀을 때 버튼 글씨가 변경으로 바뀌면서 +- 를 설정할 수 있게
	tBody.on("click",".updateBtn",function(){
		// 버튼 텍스트값
		var thisEle = $(this);
		var btnText = thisEle.text();
		
		// 버튼 텍스트값이 수정이면 
		var tr = thisEle.closest("tr");	// <tr>
	   	var td = tr.children();	// <td>
	   	
		if(btnText== "수정"){
			$(this).text("변경");
			$(this).attr("class","btn btn-primary updateBtn");
			
			// 버튼이 눌린 row 정보
			invntryQy = tr.find("#invntryQy").val(); // 현 재고 수량
			proprtQy = td.find("#proprtQy").val(); // 적정 수량
			
			console.log(invntryQy);
			console.log(proprtQy);
			
			vdprodCd = td.eq(0).text();	// 제품코드
			
			var invntryStr = "<div class='input-group bootstrap-touchspin bootstrap-touchspin-injected'>";
			invntryStr += "<span class='input-group-btn input-group-prepend'><button class='btn btn-primary bootstrap-touchspin-down invntryDown' type='button'>-</button></span>";
			invntryStr += "<input data-toggle='touchspin' type='text' value='"+invntryQy+"'class='form-control text-end invntryQyInput' id='"+vdprodCd+"'>";
			invntryStr += "<span class='input-group-btn input-group-append'><button class='btn btn-primary bootstrap-touchspin-up invntryUp' type='button'>+</button></span></div>";
			
			var proprtQyStr = "<div class='input-group bootstrap-touchspin bootstrap-touchspin-injected'>";
			proprtQyStr += "<span class='input-group-btn input-group-prepend'><button class='btn btn-primary bootstrap-touchspin-down proprtDown' type='button'>-</button></span>";
			proprtQyStr += "<input data-toggle='touchspin' type='text' value='"+proprtQy+"'class='form-control text-end proprtQyInput' id='"+vdprodCd+"'>";
			proprtQyStr += "<span class='input-group-btn input-group-append'><button class='btn btn-primary bootstrap-touchspin-up proprtUp' type='button'>+</button></span></div>";
			
			var invntryQytd = tr.find("#invntryQytd");	// 현 재고수량 td
			var proprtQytd = tr.find("#proprtQytd"); 	// 적정 재고 수량 td
			
			invntryQytd.html(invntryStr);	
			proprtQytd.html(proprtQyStr);
			
			// 숫자 외 입력 방지
			regularCheck(".invntryQyInput");
			regularCheck(".proprtQyInput");
		}
		
		
		if(btnText=="변경"){	// "변경" 버튼을 클릭했을 때 서버로 데이터 전송
			
			var frcsId = thisEle[0].dataset.frcsid;	// 프랜차이즈 id
			var invntryQyInput = tr.find(".invntryQyInput");
		    var proprtQyInput = tr.find(".proprtQyInput");
		    var invntryQyVal = parseInt(invntryQyInput.val());
		    var proprtQyVal = parseInt(proprtQyInput.val());
			var hdforwardPriceInput = tr.find(".hdforwardPriceInput");
			var hdforwardPriceVal = hdforwardPriceInput.val();
		    
			var data = {
				invntryQy : invntryQyVal,
				proprtQy : proprtQyVal,
				vdprodCd : vdprodCd,
				frcsId : frcsId,
				hdforwardPrice : hdforwardPriceVal
			};

			
			console.log(data);
			
			// 수정 비동기처리 
			$.ajax({
				type : "post",
				url : "/owner/inventory/update.do",
				beforeSend : function(xhr){	// csrf토큰 보내기 위함
					xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");	//key value로 보낸다.
				},
				data : JSON.stringify(data),
				contentType : "application/json; charset=utf-8",
				success : function(res){
					console.log(res);
					if(res == "OK"){
						 Swal.fire({
				            title: "수정 성공",
				            text: "정상적으로 수정되었습니다",
				            confirmButtonText: "확인",
				            icon: "success",
				            preConfirm: function () {
				                location.href = "/owner/inventory.do";
				            }
				        });
					}
				}
			});
		}	
	});

	// +,- 처리 함수
	function plusMinus(buttonClass, inputClass, increment){
		tBody.on("click", buttonClass, function(){
			var ele = $(this);	// 누른 버튼
	 		var injectEle = ele.parents(".bootstrap-touchspin-injected");
			var inputEle = injectEle.find(inputClass);
			
			var currentValue = parseInt(inputEle.val());	// +나 - 누르기 전 현재 값
			var nowVal = 0;
			
			if(increment){
				nowVal = currentValue + 1;
			}else{
				if (currentValue > 0) {
		 	        nowVal = currentValue - 1;
		 	    }else{
		 	    	return;	// 현재 값이 0이면 더 감소할 수 없게
		 	    }
			}
			inputEle.val(nowVal);
		});
	}
	
	// 현 재고수량 + 버튼 눌렀을 때 숫자 증가
	plusMinus(".invntryUp",".invntryQyInput",true);
	
	// 현 재고수량 - 버튼 눌렀을 때 숫자 감소
	plusMinus(".invntryDown",".invntryQyInput",false);
	
	// 적정 재고수량 + 버튼 눌렀을 때 숫자 증가
	plusMinus(".proprtUp",".proprtQyInput",true);
	
	// 적정 재고수량 - 버튼 눌렀을 때 숫자 증가
	plusMinus(".proprtDown",".proprtQyInput",false);

	// 3자리 단위로 ,찍기
	function numberToString(number) {
	    return new Intl.NumberFormat('ko-KR').format(number);
	}
	
	
	// 초기 재고 설정
	$("#beginBtn").on("click",function(){

		var frcsId = $("#frcsId").val();
		
		$.ajax({
			type : "post",
			url : "/owner/inventory/beginSetting.do",
			beforeSend : function(xhr){	// csrf토큰 보내기 위함
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");	//key value로 보낸다.
			},
			data : {frcsId : frcsId},
			success : function(res){
				console.log(res);
				if(res == "OK"){
					 Swal.fire({
			            title: "초기 설정 성공",
			            text: "정상적으로 설정되었습니다",
			            confirmButtonText: "확인",
			            icon: "success",
			            preConfirm: function () {
			                location.href = "/owner/inventory.do";
			            }
			        });
				}
			}
		});
	});
	
	// 신규 제품 업데이트
	inventUpdateBtn.on("click",function(){
		
		var frcsId = $("#frcsId").val();
		
		$.ajax({
			type : "post",
			url : "/owner/inventory/inventAdd.do",
			beforeSend : function(xhr){	// csrf토큰 보내기 위함
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");	//key value로 보낸다.
			},
			data : {frcsId : frcsId},
			success : function(res){
				
				if(res == "EXIST"){
					Swal.fire({
			            title: "업데이트 내역 없음",
			            text: "업데이트할 신규 제품이 존재하지 않습니다.",
			            confirmButtonText: "확인",
			            icon: "info",
			        });
				}
				if(res == "OK"){
					 Swal.fire({
			            title: "업데이트 성공",
			            text: "정상적으로 제품 업데이트가 되었습니다.",
			            confirmButtonText: "확인",
			            icon: "success",
			            preConfirm: function () {
			                location.href = "/owner/inventory.do";
			            }
			        });
				}
				
				if(res == "FAILED"){
					 Swal.fire({
			            title: "업데이트 실패",
			            text: "제품 업데이트에 실패하였습니다.",
			            confirmButtonText: "확인",
			            icon: "error",
			            preConfirm: function () {
			                location.href = "/owner/inventory.do";
			            }
			        });
				}
			}
		})
	});
	
	// input에 숫자만 입력할 수 있게끔 정규식 검사
	function regularCheck(name){
		$(name).keyup(function(){
			var replace_text = $(this).val().replace(/[^-0-9]/g,"");
			$(this).val(replace_text);
		});
	}
	
});

	
</script>
