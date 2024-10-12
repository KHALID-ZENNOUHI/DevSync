<%@ page import="org.DevSync.Domain.Tag" %>
<%@ page import="java.util.List" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <title>User List</title>
</head>
<body>
<div class="container mt-4">
    <h1 class="text-center">Tasks</h1>

    <div class="mt-4 text-center">
        <a href="task" class="btn btn-secondary">Tasks</a>
        <a href="user" class="btn btn-secondary">Users</a>
    </div>
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addUserModal">
        Create New Tag
    </button>

    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>Tag Name</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Assuming the 'tags' list is set in request scope by the servlet
            List<Tag> tags = (List<Tag>) request.getAttribute("tags");
            if (tags != null && !tags.isEmpty()) {
                for (Tag tag : tags) {
        %>
        <tr>
            <td><%= tag.getName() %></td>
            <td>
                <!-- Edit Button and Modal -->
                <button type="button" class="btn btn-warning btn-sm" data-toggle="modal" data-target="#editTagModal<%= tag.getId() %>">
                    Edit
                </button>

                <!-- Modal for editing Tag (unique for each tag) -->
                <div class="modal fade" id="editTagModal<%= tag.getId() %>" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel<%= tag.getId() %>" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editUserModalLabel<%= tag.getId() %>">Edit Tag: <%= tag.getName() %></h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form action="tag" method="POST">
                                    <input type="hidden" name="id" value="<%= tag.getId() %>">

                                    <div class="form-group">
                                        <label for="username<%= tag.getId() %>">tag name</label>
                                        <input type="text" class="form-control" id="tag<%= tag.getId() %>" name="name" value="<%= tag.getName() %>" required>
                                    </div>
                                    <input type="hidden" name="action" value="update">
                                    <button type="submit" class="btn btn-primary">Update User</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>


                <form action="tag" method="POST" style="display: inline;">
                    <input type="hidden" name="id" value="<%= tag.getId() %>">
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
            <td colspan="7" class="text-center">No tags found.</td>
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
                <form action="tag" method="POST">
                    <div class="form-group">
                        <label for="name">tag name</label>
                        <input type="text" class="form-control" id="name" name="name" required>
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


