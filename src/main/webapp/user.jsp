<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.DevSync.Domain.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>User List</title>
</head>
<body>
<div class="container mt-4">
    <h1>User List</h1>

    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addUserModal">
        Create New User
    </button>

    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>User Type</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Assuming the 'users' list is set in request scope by the servlet
            List<User> users = (List<User>) request.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                for (User user : users) {
        %>
        <tr>
            <td><%= user.getId() %></td>
            <td><%= user.getUsername() %></td>
            <td><%= user.getFirstName() %></td>
            <td><%= user.getLastName() %></td>
            <td><%= user.getEmail() %></td>
            <td><%= user.getUserType() %></td>
            <td>
                <!-- Edit Button and Modal -->
                <button type="button" class="btn btn-warning btn-sm" data-toggle="modal" data-target="#editUserModal<%= user.getId() %>">
                    Edit
                </button>

                <!-- Modal for editing User (unique for each user) -->
                <div class="modal fade" id="editUserModal<%= user.getId() %>" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel<%= user.getId() %>" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editUserModalLabel<%= user.getId() %>">Edit User: <%= user.getUsername() %></h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form action="user" method="POST">
                                    <input type="hidden" name="id" value="<%= user.getId() %>">

                                    <div class="form-group">
                                        <label for="username<%= user.getId() %>">Username</label>
                                        <input type="text" class="form-control" id="username<%= user.getId() %>" name="username" value="<%= user.getUsername() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="firstName<%= user.getId() %>">First Name</label>
                                        <input type="text" class="form-control" id="firstName<%= user.getId() %>" name="firstName" value="<%= user.getFirstName() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="lastName<%= user.getId() %>">Last Name</label>
                                        <input type="text" class="form-control" id="lastName<%= user.getId() %>" name="lastName" value="<%= user.getLastName() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="email<%= user.getId() %>">Email</label>
                                        <input type="email" class="form-control" id="email<%= user.getId() %>" name="email" value="<%= user.getEmail() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="password<%= user.getId() %>">Password</label>
                                        <input type="password" class="form-control" id="password<%= user.getId() %>" name="password" value="<%= user.getPassword() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="usertype<%= user.getId() %>">User Type</label>
                                        <select class="form-control" id="usertype<%= user.getId() %>" name="usertype" required>
                                            <option value="USER" <%= user.getUserType().equalsIgnoreCase("USER") ? "selected" : "" %>>User</option>
                                            <option value="MANAGER" <%= user.getUserType().equalsIgnoreCase("MANAGER") ? "selected" : "" %>>Manager</option>
                                        </select>
                                    </div>
                                    <input type="hidden" name="action" value="update">
                                    <button type="submit" class="btn btn-primary">Update User</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>


                <form action="user" method="POST" style="display: inline;">
                    <input type="hidden" name="id" value="<%= user.getId() %>">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                </form>
            </td>

        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="7" class="text-center">No users found.</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

<!-- Modal for Adding New User -->
<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="user" method="POST">
                <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" class="form-control" id="firstName" name="firstName" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" class="form-control" id="lastName" name="lastName" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="usertype">User Type</label>
                        <select class="form-control" id="usertype" name="usertype" required>
                            <option value="USER">user</option>
                            <option value="MANAGER">manager</option>
                        </select>
                    </div>
                    <input type="hidden" name="action" value="create">
                    <button type="submit" class="btn btn-primary">Add User</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
