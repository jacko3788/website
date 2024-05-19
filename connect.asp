<%
Dim connStr
connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("faulttracker.accdb") & ";Persist Security Info=False;"

Function GetConnection()
    Dim conn
    Set conn = Server.CreateObject("ADODB.Connection")
    conn.Open connStr
    Set GetConnection = conn
End Function
%>
