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
    pcs_id = CLng(Request.QueryString("pcs_id"))
    ' Response.Write("<p>" & pcs_id & "</p>") '로그

    ' 데이터베이스에서 해당 pcs_id의 정보 조회하기
    ' sql = "SELECT tb_sm022.pcs_name, tb_sm022.pcs_price, tb_sm022.pcs_id " &_ 
    '     "FROM tb_sm022 WHERE tb_sm022.pcs_id=" & pcs_id

    ' 기능 확인 
    ' sql = "SELECT tb_sm022.pcs_name, tb_sm022.pcs_price, tb_sm022.pcs_id, tb_sm022.pcs_desc_txt, COUNT(tb_sm027.repl_id) as repl_content " & _
    '   "FROM tb_sm022 LEFT JOIN tb_sm027 ON tb_sm022.pcs_id = tb_sm027.pcs_id " & _
    '   "WHERE tb_sm022.pcs_id=" & pcs_id & _
    '   "GROUP BY tb_sm022.pcs_name, tb_sm022.pcs_price, tb_sm022.pcs_id"

    '상품 일부 확인
    sql = "SELECT tb_sm022.pcs_name, tb_sm022.pcs_price, tb_sm022.PCS_ID, tb_sm022.pcs_desc_txt, COUNT(tb_sm027.repl_id) as repl_counter" & _
      " FROM tb_sm022 LEFT JOIN tb_sm027 ON tb_sm022.pcs_id =tb_sm027.pcs_id" & _
      " WHERE tb_sm022.pcs_id=" & pcs_id &" " & _
      " GROUP BY tb_sm022.pcs_name, tb_sm022.pcs_price, tb_sm022.PCS_ID, tb_sm022.pcs_desc_txt"
	  response.write sql
' 안해! 왜!! 안나오는건데!! 
' sql = " SELECT tb_sm022.pcs_name, tb_sm022.pcs_price, tb_sm022.PCS_ID, tb_sm022.pcs_desc_txt, COUNT(tb_sm027.repl_id) as repl_counter" & _
'       " FROM tb_sm022" & _
'       " LEFT JOIN tb_sm027 ON tb_sm022.pcs_id = tb_sm027.PCS_ID" & _
'       '숫자만 매칭 =1 이면 숫자
'       " INNER JOIN tb_sm092 ON	tb_sm022.pcs_maker= tb_sm092.gubun_code AND ISNUMERIC(tb_SM092.CODE) = 1 AND tb_sm092.CODE =" & "'" & pcs_id & "'"& _
'       " WHERE tb_sm022.pcs_id=" & pcs_id & _
'       " GROUP BY tb_sm022.pcs_name, tb_sm022.pcs_price,tb_sm022.PCS_ID,tb_sm022.pcs_desc_txt"


    set rs=getRs(sql)
    ' img_url="<img class='item_img' src='//www.gvg.co.kr/dat2/042/" & rs("file_name") & "'>"
    Response.Write("<p>쿼리: " & sql & "</p>")

    If Not rs.EOF Then
        Response.Write("<h2>" & rs("pcs_name") & "</h2>")
        Response.Write("<h2>가격: " & rs("pcs_price") & "</h2>")
        Response.Write("<h2>리플수: " & rs("repl_counter") & "</h2>")
        Response.Write( rs("pcs_desc_txt"))

        

        ' Response.Write("<img class='item_img' src='//www.gvg.co.kr/dat2/042/" & rs("file_name") & "'>")

    Else 
        response.redirect("/error.html")
    End If

set Rs=Nothing
    %>
</body>
</html>