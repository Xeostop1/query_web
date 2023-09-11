<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>List</title>
    <style>
        a{text-decoration: none;}
        ul,li{list-style: none;}
        .t_img{width: 50px; height: 50px;}
        .page_num{margin:auto; width: 400px;} 
    </style>


  </head>
  <body>
    <!--#include virtual=/sb/inc/vbutil.inc-->
    <!--#include virtual=/sb/inc/count.inc-->
    

    <div id="wrap">
      <h2>List</h2>
    <!--#include virtual=/sb/inc/heder.inc-->  
      <% 
        page = Request.QueryString("page")
        if page = "" then page = 1
        ' sort = Request.QueryString("sort")
        if sort = "" then sort = "sysdate DESC"
        dir_id = CLng(Request.QueryString("dir_id"))
        ' response.write("<p>page: " & page & "<br><br></p>")
        ' response.write("<p>sort: " & sort & "<br><br></p>")
        ' response.write("<p>dir_id: " & dir_id & "<br><br></p>")

        If Not IsNumeric(page) Or page <= 0 Then
            page = 1
        End If

        PerPage = 10
        startPage = (page - 1) * PerPage + 1

       '총 페이지수 
       total_sql ="SELECT COUNT(*) AS total FROM tb_sm022 WHERE dir_id="& dir_id &" AND delyn='N'"
       set rsTotal=getRs(total_sql)
       totalR=rsTotal("total")
       totalPages=Ceiling(totalR / PerPage)


        sql="SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY "
        Select Case sort 
            Case "sysdate_asc"
                sql=sql&"sysdate ASC"
            Case "sysdate_desc"
                sql=sql&"sysdate DESC"
            Case "pcs_name_asc"
                sql=sql&"pcs_name ASC"
            Case "pcs_name_desc"
                sql=sql&"pcs_name DESC"    
            Case "pcs_price_desc"
                sql=sql&"pcs_price ASC"
            Case "pcs_price_asc"
                sql=sql&"pcs_price DESC" 
            '디폴트 최신순  
            Case Else 
                sql=sql&"sysdate DESC"
        End Select 


        '섬네일 URL + case 문에서 넘어오면 뒤쪽 쿼리로 보여주기 varchar 기본세팅 값 30
        sql = sql & ") AS RowNum, pcs_name, sysdate, pcs_price," &_
                    " ISNULL(CONCAT(CAST(tb_SM022_thumbs.http AS VARCHAR(200)), '/', CAST(tb_SM022_thumbs.file_name AS VARCHAR(200))), 'NULL') as t_url "
        sql = sql & " FROM tb_sm022 LEFT JOIN tb_SM022_THUMBS ON tb_SM022.pcs_id = tb_SM022_THUMBS.pcs_id"
        sql = sql & " WHERE DIR_ID=" & dir_id & " AND delyn='N') as index_t"
        sql = sql & " WHERE index_t.RowNum >= "& startPage &" AND index_t.RowNum < "&(startPage + PerPage)

        If startPage + PerPage <= totalR then
            sql=sql & "  AND index_t.RowNum < "&(startPage + PerPage)
            
        End If
        Response.Write("<p>" & sql & "</p>")

        set rs=getRs(sql)        
        Response.Write("<form action='list.asp' method='get'>")
        Response.Write("<input type='hidden' name='dir_id' value='" & dir_id & "' >")
        Response.Write("<input type='hidden' name='page' value='" & page & "' >")
            Response.Write("<select name='sort' onchange='this.form.submit()'>")
                Response.Write("<option value='' selected>정렬 방식 선택</option>")
                Response.Write("<option value='sysdate_desc'>업데이트 순 (내림차순)</option>")
                Response.Write("<option value='sysdate_asc'>업데이트 순 (오름차순)</option>")
                Response.Write("<option value='pcs_name_desc'>상품 이름 순 (내림차순)</option>")
                Response.Write("<option value='pcs_name_asc'>상품 이름 순 (오름차순)</option>")
                Response.Write("<option value='pcs_price_desc'>가격 순 (내림차순)</option>")
                Response.write("<option value='pcs_price_asc'> 가격 순(오름 차순) </option>")
            Response.write"</select>"

   ' 데이터 출력
   While Not rs.EOF 
        Response.Write("<ul id='data_table'>")
        If rs("t_url") = "NULL" Then
            Response.write "<li>이미지 없음: "
        Else
            Response.write "<li><img src='"&rs("t_url")&"' alt ='Thumbnail' class=t_img>"
        End If
        Response.write "&nbsp;" & rs("pcs_name")&" / "
        Response.write rs("sysdate")&" / "
        Response.write rs("pcs_price")&"</li>"
        rs.MoveNext 
        Response.Write("</ul>")
    Wend

	  set rs=Nothing

' 페이징 처리
        Response.write("<div class='page_num'>")
        start_num = ((CInt(page) - 1) \ 10) * 10 + 1
        end_num = start_num + 9

        If start_num > 1 Then
            
        Response.Write("<a href='list.asp?dir_id=" & dir_id & "&page=" & (start_num-1) & "'>Previous</a>") 
        End If

        For i = start_num To Min(end_num, totalPages)
        If i = CInt(page) Then
            Response.Write(" <strong>" & i & "</strong> ")
        Else 
            Response.Write("<a href='list.asp?dir_id=" & dir_id & "&page=" &  i  & "'>" &  i  & "</a>")
        End If  
        Next
            
        If end_num < totalPages Then   
            Response.Write("<a href='list.asp?dir_id=" & dir_id & "&page=" & (end_num+1) & "'>Next</a>")
        End If    
        Response.write("<br><br><br></div>")
        set rs=Nothing
        %>
</div>
</body>