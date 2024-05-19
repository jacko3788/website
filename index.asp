<%@ Language=VBScript %>
<!--#include file="connect.asp" -->

<%
If Request.Form("action") = "add" Then
    Dim conn, sql, dateInput, faultInput, stationInput, serialInput

    dateInput = Request.Form("dateInput")
    faultInput = Request.Form("faultInput")
    stationInput = Request.Form("stationInput")
    serialInput = Request.Form("serialInput")

    Set conn = GetConnection()
    sql = "INSERT INTO Faults (Date, Description, Station, SerialNumber) VALUES ('" & dateInput & "', '" & faultInput & "', '" & stationInput & "', '" & serialInput & "')"
    conn.Execute(sql)
    conn.Close
    Set conn = Nothing
End If

If Request.QueryString("action") = "delete" Then
    Dim id

    id = Request.QueryString("id")
    Set conn = GetConnection()
    sql = "DELETE FROM Faults WHERE ID=" & id
    conn.Execute(sql)
    conn.Close
    Set conn = Nothing
End If
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fault Tracker</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        margin: 0;
        padding: 20px;
    }

    h1 {
        color: #333;
    }

    label {
        display: block;
        margin-bottom: 5px;
        color: #333;
    }

    input[type="date"],
    input[type="text"] {
        width: 100%;
        padding: 8px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }

    button {
        padding: 10px 20px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    button:hover {
        background-color: #45a049;
    }

    h2 {
        color: #333;
        margin-top: 20px;
    }

    ul {
        list-style-type: none;
        padding: 0;
    }

    li {
        margin-bottom: 10px;
        background-color: #fff;
        padding: 10px;
        border-radius: 4px;
    }

    li button {
        padding: 6px 12px;
        background-color: #f44336;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        float: right;
    }

    li button:hover {
        background-color: #d32f2f;
    }
</style>
</head>
<body>
<h1>Fault Tracker</h1>
<form method="post" action="index.asp">
    <label for="dateInput">Date:</label>
    <input type="date" id="dateInput" name="dateInput">
    <label for="faultInput">Fault:</label>
    <input type="text" id="faultInput" name="faultInput" placeholder="Enter fault description">
    <label for="stationInput">Station:</label>
    <input type="text" id="stationInput" name="stationInput" placeholder="Enter station">
    <label for="serialInput">Serial Number:</label>
    <input type="text" id="serialInput" name="serialInput" placeholder="Enter serial number">
    <input type="hidden" name="action" value="add">
    <button type="submit">Add Fault</button>
</form>

<h2>Saved Faults</h2>
<input type="text" id="searchInput" oninput="searchFaults()" placeholder="Search faults">
<ul id="faultList">
<%
Set conn = GetConnection()
Set rs = conn.Execute("SELECT * FROM Faults")

Do Until rs.EOF
%>
    <li>
        Date: <%= rs("Date") %>, Fault: <%= rs("Description") %>, Station: <%= rs("Station") %>, Serial Number: <%= rs("SerialNumber") %> 
        <a href="index.asp?action=delete&id=<%= rs("ID") %>">Delete</a>
    </li>
<%
    rs.MoveNext
Loop

rs.Close
Set rs = Nothing
conn.Close
Set conn = Nothing
%>
</ul>

<script>
function searchFaults() {
    var searchInput = document.getElementById("searchInput").value.toLowerCase();
    var faultList = document.getElementById("faultList");
    var faults = faultList.getElementsByTagName("li");

    for (var i = 0; i < faults.length; i++) {
        var fault = faults[i].innerText.toLowerCase();
        if (fault.includes(searchInput)) {
            faults[i].style.display = "";
        } else {
            faults[i].style.display = "none";
        }
    }
}
</script>

</body>
</html>
