<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.DevSync.Domain.Task, org.DevSync.Domain.Tag, java.util.List" %>
<%@ page import="org.DevSync.Domain.Enum.UserType" %>
<%@ page import="org.DevSync.Domain.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="org.DevSync.Domain.TaskChangeRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h1 class="text-center">Tasks</h1>
    <div class="mt-4 text-center">
        <a href="user" class="btn btn-secondary">Users</a>
        <a href="tag" class="btn btn-secondary">Tags</a>
        <a href="task" class="btn btn-secondary">Tasks</a>
    </div>
    <%
        String message = (String) session.getAttribute("message");
        if (message != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= message %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
            session.removeAttribute("message"); // Remove the message after displaying it
        }
    %>
    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>Task Title</th>
            <th>Assigned To</th>
            <th>Request Date</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Assuming the 'taskChangeRequests' list is set in request scope by the servlet
            List<TaskChangeRequest> taskChangeRequests = (List<TaskChangeRequest>) request.getAttribute("taskChangeRequests");
            if (taskChangeRequests != null && !taskChangeRequests.isEmpty()) {
                for (TaskChangeRequest changeRequest : taskChangeRequests) {
        %>
        <tr>
            <td><%= changeRequest.getTask().getTitle() %></td>
            <td><%= changeRequest.getTask().getAssignedTo().getUsername() %></td>
            <td><%= changeRequest.getChangeDate() %></td>
            <td>
                <!-- Edit Button and Modal -->
                <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= changeRequest.getTask().getId() %>">
                    Edit
                </button>

                <!-- Modal for editing Task (unique for each task) -->
                <div class="modal fade" id="editTaskModal<%= changeRequest.getTask().getId() %>" tabindex="-1" aria-labelledby="editTaskModalLabel<%= changeRequest.getTask().getId() %>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editTaskModalLabel<%= changeRequest.getTask().getId() %>">Edit Task</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="editTask" method="post" action="taskrequest">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="taskId" value="<%= changeRequest.getTask().getId() %>">
                                    <input type="hidden" name="taskRequestId" value="<%= changeRequest.getId() %>">
                                    <div class="mb-3">
                                        <label for="addUserId" class="form-label">Assign To</label>
                                        <select class="form-control" id="addUserId" name="userId">
                                            <%
                                                List<User> users = (List<User>) request.getAttribute("users");
                                                User assignedUser = changeRequest.getTask().getAssignedTo();
                                                if (users != null && !users.isEmpty()) {
                                                    for (User user : users) {
                                                        if (!user.getId().equals(assignedUser.getId())) {
                                            %>
                                            <option value="<%= user.getId() %>"><%= user.getUsername() %></option>
                                            <%
                                                        }
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Update Task</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
