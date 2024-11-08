<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Requests</title>
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

    if (session == null || (!"Manager".equals(role) && !"Admin".equals(role))) {
        // Set a message and show a popup for unauthorized access
        out.println("<script>showPopup('Access denied: You are not a manager or admin.');</script>");
        return;
    }
%>

<div class="container">
    <h2>Pending Access Requests</h2>
    
    <!-- Logout button -->
    <form action="LogoutServlet" method="post" style="text-align:right;">
        <button type="submit">Logout</button>
    </form>

    <table border="1">
        <thead>
            <tr>
                <th>Employee Name</th>
                <th>Software Name</th>
                <th>Access Type</th>
                <th>Reason for Request</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% 
                boolean hasRequests = false;
                String jdbcUrl = "jdbc:postgresql://127.0.0.1:5432/postgres";
                String dbUser = "postgres";
                String dbPassword = "password";

                try {
                    Class.forName("org.postgresql.Driver");
                    try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
                        String query = "SELECT requests.id, users.username, software.name AS software_name, "
                                     + "requests.access_type, requests.reason "
                                     + "FROM requests "
                                     + "JOIN users ON requests.user_id = users.id "
                                     + "JOIN software ON requests.software_id = software.id "
                                     + "WHERE requests.status = 'Pending'";
                        try (PreparedStatement ps = conn.prepareStatement(query);
                             ResultSet rs = ps.executeQuery()) {

                            while (rs.next()) {
                                hasRequests = true;
                                int requestId = rs.getInt("id");
                                String employeeName = rs.getString("username");
                                String softwareName = rs.getString("software_name");
                                String accessType = rs.getString("access_type");
                                String reason = rs.getString("reason");
            %>
                                <tr>
                                    <td><%= employeeName %></td>
                                    <td><%= softwareName %></td>
                                    <td><%= accessType %></td>
                                    <td><%= reason %></td>
                                    <td>
                                        <!-- Separate form for each action -->
                                        <form action="ApprovalServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="request_id" value="<%= requestId %>">
                                            <button type="submit" name="action" value="Approve">Approve</button>
                                        </form>
                                        <form action="ApprovalServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="request_id" value="<%= requestId %>">
                                            <button type="submit" name="action" value="Reject">Reject</button>
                                        </form>
                                    </td>
                                </tr>
            <% 
                            }
                        }
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
            %>
                    <tr><td colspan="5">Error loading requests: <%= e.getMessage() %></td></tr>
            <% 
                }

                if (!hasRequests) { 
            %>
                <tr><td colspan="5">No pending requests available.</td></tr>
            <% 
                }
            %>
        </tbody>
    </table>
</div>
</body>
</html>
