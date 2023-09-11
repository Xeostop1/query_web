<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품설명</title>
</head>
<body>
    <!--#include virtual=/sb/inc/vbutil.inc-->

    <%
    pcs_id = Request.QueryString("pcs_id")
    ' Response.Write("<p>" & pcs_id & "</p>") '로그

    ' 데이터베이스에서 해당 pcs_id의 정보 조회하기
    sql = "SELECT tb_sm022.pcs_name, tb_sm022.pcs   _price " &_ 
        "FROM tb_sm022 WHERE tb_sm022.pcs_id=" & pcs_id

    set rs=getRs(sql)

    If Not rs.EOF Then
        Response.Write("<h2>" & rs("pcs_name") & "</h2>")
        Response.Write("<p>가격: " & rs("pcs_price") & "</p>")
    Else 
        response.redirect("/error.html")
    End If

set Rs=Nothing


    %>
</body>
</html>