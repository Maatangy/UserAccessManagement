# Leucine Project Submission

The **User Access Management System** is a web-based application built to streamline user access requests within an organization. Designed with role-based access control, this system enables different functionalities based on user roles—**Employee**, **Manager**, and **Admin**. 

- **Employees** can request access to various software applications.
- **Managers** can view, approve, or reject access requests from employees.
- **Admins** can manage software applications and have complete control over user access.

The project uses Java Servlets and JSPs for backend processing, PostgreSQL for database management, and is deployed as a Maven project. This system provides a structured and secure workflow to manage access permissions efficiently, enhancing both security and operational productivity.


## Prerequisites

- **Java 17** or later
- **Maven** installed (to build and run the project)
- **PostgreSQL** database set up with the required tables and default users

## Database Setup

Before running the project, ensure the following tables exist in your PostgreSQL database:

- `users`
- `software`
- `requests`

You can find the SQL script to create these tables in the `sql` directory.

## Running the Project

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/User-Access-Management-System.git
   cd User-Access-Management-System
   ```

2. **Configure Database Connection**:
   Update the database connection details in each servlet if necessary. Example database connection:
   ```java
   String jdbcUrl = "jdbc:postgresql://127.0.0.1:5432/postgres";
   String dbUser = "postgres";
   String dbPassword = "password";
   ```

3. **Build the Project**:
   Use Maven to build the project:
   ```bash
   mvn clean package
   ```

4. **Deploy the WAR file to Tomcat**:
   - Copy the generated `.war` file (located in `target/mavenproject1-1.0-SNAPSHOT.war`) to the Tomcat `webapps` directory.
   - Start or restart Tomcat.

5. **Access the Application**:
   - Open a web browser and go to `http://localhost:8080/mavenproject1`.
   - Login with:
     - `manager` as **Manager**
     - `admin` as **Admin**

## Usage

- **Login**: Users can log in based on their role.
- **Sign Up**: New users can sign up and receive the default "Employee" role.
- **Request Access**: Employees can request access to software.
- **Approve/Reject Requests**: Managers can view and manage access requests.
- **Create Software**: Admins can add new software applications to the system.

## SQL Script

To set up the database, refer to the following SQL script or find it in the `sql` directory.

```sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('Employee', 'Manager', 'Admin'))
);

CREATE TABLE IF NOT EXISTS software (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    access_levels TEXT CHECK (access_levels IN ('Read', 'Write', 'Admin'))
);

CREATE TABLE IF NOT EXISTS requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    software_id INTEGER REFERENCES software(id) ON DELETE CASCADE,
    access_type TEXT NOT NULL CHECK (access_type IN ('Read', 'Write', 'Admin')),
    reason TEXT,
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected'))
);

-- Default Manager and Admin Users
INSERT INTO users (username, password, role) VALUES
('manager', 'manager_password', 'Manager'),
('admin', 'admin_password', 'Admin');
```

> **Note**: Replace `'manager_password'` and `'admin_password'` with actual passwords. Consider hashing these passwords for security.

## Troubleshooting

- **Database Connection Errors**: Ensure the database credentials are correct in each servlet and that PostgreSQL is running.
- **Class Not Found Errors**: Verify that the required dependencies are included in `pom.xml` and re-run `mvn clean package`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

This README provides the essential details to set up, run, and use the User Access Management System, with the servlets managing various functionalities. For more information, refer to specific Java classes within the `servlets` package.


---

### Project Structure



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
