<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Software</title>
    <link rel="stylesheet" href="styles.css">
    <script>
        // Function to hide the message after 3 seconds
        function hideMessage() {
            const messageDiv = document.getElementById("message");
            if (messageDiv) {
                setTimeout(() => {
                    messageDiv.style.display = "none";
                }, 3000);
            }
        }

        // Function to show the popup message for unauthorized access
        function showPopup(message) {
            const popup = document.getElementById("popupMessage");
            popup.innerText = message;
            popup.style.display = "block";
            setTimeout(() => {
                popup.style.display = "none";
            }, 3000);
        }

        window.onload = function() {
            hideMessage();
            <% if (request.getParameter("message") != null) { %>
                showPopup("<%= request.getParameter("message") %>");
            <% } %>
        };
    </script>
</head>
<body>
<div id="popupMessage"></div>

<%
    String role = (String) session.getAttribute("role");
    if (session == null || !"Admin".equals(role)) {
        out.println("<script>showPopup('Access denied: Only admins can create software.');</script>");
        return;
    }
%>

<div class="container">
    <h2>Create Software</h2>

    <%
        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
    %>
        <div id="message" class="message"><%= message %></div>
    <%
        }
    %>

    <form action="SoftwareServlet" method="POST">
        <label>Software Name:</label>
        <input type="text" name="name" required><br><br>

        <label>Description:</label>
        <textarea name="description" required></textarea><br><br>

        <label>Access Level:</label>
        <select name="access_level" required>
            <option value="Read">Read</option>
            <option value="Write">Write</option>
            <option value="Admin">Admin</option>
        </select><br><br>

        <button type="submit">Add Software</button>
    </form>

    <!-- Right-aligned logout button -->
    <div class="logout-container" style="text-align: right; margin-top: 20px;">
        <form action="LogoutServlet" method="post">
            <button type="submit">Logout</button>
        </form>
    </div>
</div>
</body>
</html>
