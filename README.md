Below is the complete code setup for a **User Access Management System** as described, including **Servlets, JSP files, and PostgreSQL database scripts**.

---

### Project Structure

Assuming the project structure:

```
UserAccessManagement/
├── src/
│   └── servlets/
│       ├── SignUpServlet.java
│       ├── LoginServlet.java
│       ├── SoftwareServlet.java
│       ├── RequestServlet.java
│       └── ApprovalServlet.java
├── webapp/
│   ├── signup.jsp
│   ├── login.jsp
│   ├── createSoftware.jsp
│   ├── requestAccess.jsp
│   └── pendingRequests.jsp
├── WEB-INF/
│   └── web.xml
└── pom.xml
```

### 1. Database Setup (PostgreSQL)

Create tables in PostgreSQL for `users`, `software`, and `requests`.

```sql
-- PostgreSQL script to create tables
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL
);

CREATE TABLE software (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    access_levels VARCHAR(20) NOT NULL
);

CREATE TABLE requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    software_id INTEGER REFERENCES software(id),
    access_type VARCHAR(20),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);
```

### Deployment Instructions

1. **Clean and Build the Project** in NetBeans.
2. **Deploy** to Tomcat.
3. Access the application at `http://localhost:8080/UserAccessManagement`.

This should give you a fully functional User Access Management System. Let me know if you encounter any issues!
