<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<input type="hidden" value="${frcsId }" id="frcsId"/>
<div class="content-page">
   <div class="content">
      <div class="container-fluid">
          <div class="row">
              <div class="col-12">
                  <div class="page-title-box">
                      <div class="page-title-right">
                          <ol class="breadcrumb m-0">
                              <li class="breadcrumb-item"><a href="javascript: void(0);">홈</a></li>
                              <li class="breadcrumb-item"><a href="javascript: void(0);">재고 트레이딩</a></li>
                              <li class="breadcrumb-item active">트레이딩 내역</li>
                          </ol>
                      </div>
                      <h4 class="page-title">트레이딩 내역</h4>
                  </div>
              </div>
          </div>
      
         <input type="hidden" id="page" name="page">
          <div class="row">
              <div class="col-12">
                  <div class="card">
                      <div class="card-body">
<!--                           <form id="searchForm" action="/owner/tradingList.do" method="post"> -->
                          <div class="row mb-2">
                              <div class="col-xl-8">
                                  <h5>필터</h5>
                                  <div class="mt-2">
	                                  <c:set value="${sendReceive }" var="sendReceive"/>
	                             	  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input sendReceive" id="all" name="sendReceive" value="all" checked <c:if test="${fn:contains(sendReceive,'all') }">checked</c:if>> 
		                                  <label class="form-check-label" for="all">전체</label>
	                              	  </div>
	                             	  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input sendReceive" id="send" name="sendReceive" value="send" <c:if test="${fn:contains(sendReceive,'send') }">checked</c:if>>
		                                  <label class="form-check-label" for="send">발신</label>
	                               	  </div>
	                               	  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input sendReceive" id="receive" name="sendReceive" value="receive" <c:if test="${fn:contains(sendReceive,'receive') }">checked</c:if>>
		                                  <label class="form-check-label" for="receive">수신</label>
	                               	  </div>
                           		  </div>                       
                              </div>
                          </div>
                     	  <div class="row mb-2">
                              <div class="col-xl-8">
                                  <h5>진행상태</h5>
                                  <c:set value="${progress }" var="progress"/>
                                  <div class="mt-2">
	                                  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input" id="progressAll" name="progress" value="all" checked<c:if test="${fn:contains(progress,'all') }">checked</c:if>>
		                                  <label class="form-check-label" for="progressAll">전체</label>
	                                  </div>
	                                  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input" id="requesting" name="progress" value="requesting" <c:if test="${fn:contains(progress,'requesting') }">checked</c:if>>
		                                  <label class="form-check-label" for="requesting">요청중</label>
	                                  </div>
	                                  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input" id="completed" name="progress" value="completed" <c:if test="${fn:contains(progress,'completed') }">checked</c:if>>
		                                  <label class="form-check-label" for="completed">거래완료</label>
	                                  </div>
	                                  <div class="form-check form-check-inline">
		                                  <input type="checkbox" class="form-check-input" id="refuse" name="progress" value="refuse" <c:if test="${fn:contains(progress,'refuse') }">checked</c:if>>
		                                  <label class="form-check-label" for="refuse">거절</label>
	                                  </div>
                                  </div>                          
                              </div>
                          </div>
<%--                           <sec:csrfInput/> --%>
<!--                           </form> -->
                    	  <br>
                          <div class="table-responsive">
                              <table class="table table-centered table-nowrap mb-0">
                                  <thead class="table-light">
                                      <tr>
                                          <th style="text-align:center; width:2%;"></th>
                                          <th style="text-align:center; width:5%;">순번</th>
                                          <th style="text-align:center; width:15%;">트레이딩 신청일</th>
                                          <th style="text-align:center; width:10%;">수신/발신</th>
                                          <th style="text-align:center; width:15%;">트레이딩 대상 가맹점</th>
                                          <th style="text-align:center; width:15%;">제품명</th>
                                          <th style="text-align:center; width:10%;">수량</th>
                                          <th style="text-align:center; width:10%;">진행상태</th>
                                          <th style="text-align:center; width:10%;"></th>
                                      </tr>
                                  </thead>
                                  <tbody>
                                     <c:set value="${pagingVO.dataList }" var="tradList"/>
                                     <c:choose>
                                        <c:when test="${empty tradList }">
                                           <tr>
                                              <td colspan="9" style="text-align:center">
                                               		 트레이딩 내역이 존재하지 않습니다.
                                              </td>
                                           </tr>
                                        </c:when>
                                        <c:otherwise>
                                           <c:forEach items="${tradList }" var="trad" varStatus="stat">
                                              <tr>
                                                   <td style="text-align:center">
	                                                   <div>
		                                                   <input type="hidden" class="tradNo" value="${trad.tradNo }">
		                                                   <input type="hidden" class="vdprodCd" value="${trad.vdprodCd }">
		                                                   <input type="hidden" class="frcsId" value="${trad.frcsId }">
		                                                   <input type="hidden" class="frcsId2" value="${trad.frcsId2 }">
		                                                   <input type="hidden" class="tradStts" value="${trad.tradStts }">
	                                                   </div>
                                                   </td>
                                                   <td style="text-align:center">${stat.count }</td>
                                                   <td style="text-align:center">
                                                   <fmt:formatDate value="${trad.tradDate }" pattern="yyyy/MM/dd"/>
                                                   </td>
                                                   <td style="text-align:center">
                                                   <c:set value="${frcsId }" var="myfrcsId"/>
                                                     <c:if test="${trad.frcsId ne myfrcsId }">
                                               		      수신
                                                     </c:if>
                                                     <c:if test="${trad.frcsId eq myfrcsId }">
                                             			발신
                                                     </c:if>
                                                   </td>
                                                   <td style="text-align:center" class="frcsName">
                                                      <c:if test="${trad.frcsId eq myfrcsId }">
                                                         ${trad.frcsName2 }
                                                     </c:if>
                                                     <c:if test="${trad.frcsId ne myfrcsId }">
                                                        ${trad.frcsName }
                                                     </c:if>
                                                   </td>
                                                   <td style="text-align:center" class="vdprodName">
                                                      ${trad.vdprodName }
                                                   </td>
                                                      <td style="text-align:center" class="tradQy">${trad.tradQy }</td>
                                                   <td style="text-align:center">
                                                      <c:if test="${trad.frcsId eq myfrcsId }">
                                                         <c:if test="${trad.tradStts eq '요청'}">
                                                    	        대기(요청중)
                                                         </c:if>
                                                         <c:if test="${trad.tradStts eq '수락'}">
                                                   	       	 수락
                                                         </c:if>
                                                         <c:if test="${trad.tradStts eq '거절'}">
                                                           	 거절
                                                         </c:if>
                                                      </c:if>
                                                      <c:if test="${trad.frcsId ne myfrcsId }">
                                              				${trad.tradStts }
                                                      </c:if>
                                                   </td>
                                                   <td style="text-align:center">
                                                      <c:if test="${trad.frcsId ne myfrcsId }">
                                                         <c:if test="${trad.tradStts eq '요청'}">
                                                            <button class="btn btn-primary reqBtn">요청처리</button>
                                                         </c:if>
                                                         <c:if test="${trad.tradStts ne '요청'}">
                                                            <button class="btn btn-primary detailBtn">상세내역</button>
                                                         </c:if>
                                                     </c:if>
                                                     <!-- 내가 요청했을 때 -->
                                                     <c:if test="${trad.frcsId eq myfrcsId }">
                                                         <button class="btn btn-primary detailMyBtn">상세내역</button>
                                                     </c:if>
                                                   </td>
                                               </tr>
                                           </c:forEach>   
                                        </c:otherwise>
                                     </c:choose>
                                  </tbody>
                              </table>
                          </div>
                          <br><br>
                          <form id="pageForm" class="row gy-2 gx-2 align-items-center justify-content-xl-start justify-content-between">                                      
                        <input type="hidden" name="page" id="page"/>
                     </form> 
                     <nav aria-label="Page navigation example" id="pagingArea">
                        ${pagingVO.pagingHTML }
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
   var pageForm = $("#pageForm");
   var reqBtn = $(".reqBtn");   // 요청 btn
   var detailMyBtn = $(".detailMyBtn");
   var detailBtn = $(".detailBtn");
   var searchForm = $("#searchForm");
   var frcsId = $("#frcsId").val();
   
   console.log('${sendReceive}');
   console.log('${progress}');
   
   searchForm.on("click",function(){
      console.log("submit");
      searchForm.submit();
   });
   
   pagingArea.on("click","a",function(event){
      event.preventDefault();
      var pageNo = $(this).data("page");
      pageForm.find("#page").val(pageNo);
      pageForm.submit();
   });
   
   
   var checkedList = [];	// 체크된 애들을 담을 배열

   $(".sendReceive").on("click", function() {
	    var checkVal = $(this).attr('value');	// 체크된 체크박스의 값
	    
	    if ($(this).prop('checked')) {
	        checkedList.push(checkVal);
	    } else {
	        var index = checkedList.indexOf(checkVal);
	        if (index !== -1) {
	            checkedList.splice(index, 1);
	        }
	    }
	    
	    if (checkedList.length === 0) {
	        $("#all").prop("checked",true);
	        checkedList.push("all");
	    } else {
	        $("#all").prop("checked", false);
	        var index = checkedList.indexOf('all');
	        if (index !== -1) {
	            checkedList.splice(index, 1);
	        }
	    }
       console.log(checkedList);
       
       
       $.ajax({
    	   type : "post",
    	   url : "/owner/tradingSearch.do",
    	   beforeSend : function(xhr){   // csrf토큰 보내기 위함
               xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");   //key value로 보낸다.
            },
           data : {"sendReceive": checkedList, frcsId : frcsId },
           dataType: "json",
      	   success: function(res){
      		   console.log(res);
      	   }
       });
   });
   
   // 요청처리버튼
   reqBtn.on("click",function(){
      
      var frcsName = $(this).closest('tr').find('.frcsName').text();
      var vdprodName =$(this).closest('tr').find('.vdprodName').text();
      var tradQy =$(this).closest('tr').find('.tradQy').text();
      var frcsId =$(this).closest('tr').find('.frcsId').val();
      var frcsId2 =$(this).closest('tr').find('.frcsId2').val();
      var vdprodCd =$(this).closest('tr').find('.vdprodCd').val();
      var tradNo =$(this).closest('tr').find('.tradNo').val();
      var text = "요청 가맹점명 : " + frcsName +"<br>";
      text += "요청 제품명 : " + vdprodName + "<br>";
      text += "요청 수량 : " + tradQy;
      
      Swal.fire({
          title: "트레이딩 내역",
          html: text,
          showCancelButton: true,
          showConfirmButton: true,
          confirmButtonText: "수락",
          cancelButtonText: "거절",
          icon: "info",
      }).then((result) => {
          if (result.dismiss === Swal.DismissReason.cancel) {
             // 거절을 누르면
              Swal.fire({
                  title: "거절 사유 입력",
                  input: 'text',
                  inputPlaceholder: "거절 사유를 입력하세요",
                  confirmButtonText: "확인",
                cancelButtonText: "취소",
                preConfirm: function (reason) {
                   if(reason === ""){
                      Swal.showValidationMessage("거절 사유를 입력해주세요.");
                   }else{
                      var tradRm = reason;
                      
                      var data = {
                         tradRm : tradRm,
                         tradNo : tradNo
                      };
                      
                      // 거절 시 
                      $.ajax({
                         type : "post",
                           url : "/owner/tradingRefuse.do",
                           beforeSend : function(xhr){   // csrf토큰 보내기 위함
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");   //key value로 보낸다.
                         },
                         data : JSON.stringify(data),
                            contentType : "application/json; charset=utf-8",
                         success : function(res){
                            Swal.fire({
                                  title: "트레이딩 거절",
                                  text: "정상적으로 처리 되었습니다",
                                  confirmButtonText: "확인",
                                  icon: "success",
                                  preConfirm: function () {
                                      location.href = "/owner/tradingList.do";
                                  }
                              });
                         }
                      });
                   }
                }
              });
             
          } else if (result.isConfirmed) {
              var data = {
                  tradNo: tradNo,
                  frcsId: frcsId,
                  frcsId2: frcsId2,
                  vdprodCd: vdprodCd,
                  tradQy: tradQy,
              };
               
               // 요청가맹점은 재고 +처리, 응답가맹점은 재고-처리
               $.ajax({
                  type : "post",
                  url : "/owner/tradingSuccess.do",
                  beforeSend : function(xhr){   // csrf토큰 보내기 위함
                   xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");   //key value로 보낸다.
                },
                data : JSON.stringify(data),
                   contentType : "application/json; charset=utf-8",
                success : function(res){
                   if(res === "OK"){
                      Swal.fire({
                            title: "트레이딩 수락",
                            text: "정상적으로 수락 되었습니다",
                            confirmButtonText: "확인",
                            icon: "success",
                            preConfirm: function () {
                                location.href = "/owner/tradingList.do";
                            }
                        });
                   }
                }
               });
            }   
         });
   });
   
   detailMyBtn.on("click",function(){
      
      var frcsName = $(this).closest('tr').find('.frcsName').text().trim();
      var vdprodName =$(this).closest('tr').find('.vdprodName').text().trim();
      var tradQy =$(this).closest('tr').find('.tradQy').text().trim();
      var frcsId =$(this).closest('tr').find('.frcsId').val();
      var frcsId2 =$(this).closest('tr').find('.frcsId2').val();
      var vdprodCd =$(this).closest('tr').find('.vdprodCd').val();
      var tradNo =$(this).closest('tr').find('.tradNo').val();
      var tradStts =$(this).closest('tr').find('.tradStts').val();
      
      var data = {
         frcsId : frcsId,
         vdprodCd : vdprodCd
      }
      
      $.ajax({
         type : "post",
         url : "/owner/tradingDetail.do",
         beforeSend : function(xhr){   // csrf토큰 보내기 위함
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");   //key value로 보낸다.
         },
         data : JSON.stringify(data),
           contentType : "application/json; charset=utf-8",
         success : function(res){
            
            console.log(res)
            
            var str = "";
            str += "요청 가맹점 : "+ frcsName + "<br>"
            str += "제품 : " + vdprodName + " (" + tradQy + "개) <br>"
            str += "상태 : " + tradStts + "<br>"
            str += "내 재고 수량 ▶ " + res.invntryQy ; 
            
            Swal.fire({
                  title: "상세내역",
                  html: str,
                  confirmButtonText: "확인",
                  icon: "info",
                  preConfirm: function () {
                  }
              });
         }
      });
   });
      // 응답 가맹점
      detailBtn.on("click",function(){
         
         var frcsName = $(this).closest('tr').find('.frcsName').text().trim();
         var vdprodName =$(this).closest('tr').find('.vdprodName').text().trim();
         var tradQy =$(this).closest('tr').find('.tradQy').text().trim();
         var frcsId =$(this).closest('tr').find('.frcsId').val();
         var frcsId2 =$(this).closest('tr').find('.frcsId2').val();
         var vdprodCd =$(this).closest('tr').find('.vdprodCd').val();
         var tradNo =$(this).closest('tr').find('.tradNo').val();
         var tradStts =$(this).closest('tr').find('.tradStts').val();
         
         var data = {
            frcsId : frcsId2,
            vdprodCd : vdprodCd
         }
         
         $.ajax({
            type : "post",
            url : "/owner/tradingReqDetail.do",
            beforeSend : function(xhr){   // csrf토큰 보내기 위함
               xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");   //key value로 보낸다.
            },
            data : JSON.stringify(data),
              contentType : "application/json; charset=utf-8",
              success : function(res){
               
               console.log(res)
               
               var str = "";
               str += "요청 가맹점 : "+ frcsName + "<br>";
               str += vdprodName + " " + tradQy + "개 " + tradStts + "<br>";
               str += "내 재고 수량 ▶ " + res.invntryQy ; 
               
               Swal.fire({
                     title: "상세내역",
                     html: str,
                     confirmButtonText: "확인",
                     icon: "info",
                     preConfirm: function () {
                     }
                 });
            }
         });
      
      });
   });
</script>