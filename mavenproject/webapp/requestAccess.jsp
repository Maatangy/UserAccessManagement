<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Access</title>
    <link rel="stylesheet" href="styles.css">
    
    <style>
        /* Style for the popup message */
        #popupMessage {
            display: none; /* Hidden by default */
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #f44336; /* Red for error */
            color: white;
            padding: 10px;
            border-radius: 5px;
            z-index: 1000;
        }
    </style>
    <script>
        // Function to show the popup message and hide it after 3 seconds
        function showPopup(message) {
            const popup = document.getElementById("popupMessage");
            popup.innerText = message;
            popup.style.display = "block";
            setTimeout(() => {
                popup.style.display = "none";
            }, 3000);
        }

        // Show the popup message if a message parameter is available
        window.onload = function() {
            <% if (request.getParameter("message") != null) { %>
                showPopup("<%= request.getParameter("message") %>");
            <% } %>
        };
    </script>
</head>
<body>
<div id="popupMessage"></div> <!-- Popup message container -->

<%
    // Check if the user has the appropriate role
    String role = (String) session.getAttribute("role");

    if (session == null || (!"Employee".equals(role) && !"Admin".equals(role))) {
        // Set a message and show a popup for unauthorized access
        out.println("<script>showPopup('Access denied: You are not an employee or admin.');</script>");
        return;
    }
%>

<div class="container">
    <h2>Request Access</h2>

    <form action="RequestServlet" method="post">
        <label for="software_id">Software Name:</label>
        <select id="software_id" name="software_id" required>
            <% 
                String jdbcUrl = "jdbc:postgresql://127.0.0.1:5432/postgres";
                String dbUser = "postgres";
                String dbPassword = "password";

                try {
                    Class.forName("org.postgresql.Driver");
                    try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
                        String query = "SELECT name FROM software";
                        try (PreparedStatement ps = conn.prepareStatement(query);
                             ResultSet rs = ps.executeQuery()) {

                            while (rs.next()) {
                                String softwareName = rs.getString("name");
            %>
                                <option value="<%= softwareName %>"><%= softwareName %></option>
            <% 
                            }
                        }
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
            %>
                    <option value="">Error loading software list: <%= e.getMessage() %></option>
            <% 
                }
            %>
        </select>

        <label for="access_type">Access Type:</label>
        <select id="access_type" name="access_type" required>
            <option value="Read">Read</option>
            <option value="Write">Write</option>
            <option value="Admin">Admin</option>
        </select>

        <label for="reason">Reason for Request:</label>
        <textarea id="reason" name="reason" required></textarea>

        <button type="submit">Submit Request</button>
    </form>
        <form action="LogoutServlet" method="post" style="text-align:right; margin-top: 20px;">
        <button type="submit">Logout</button>
    </form>
</div>
</body>
</html>
