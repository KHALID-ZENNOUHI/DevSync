<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.DevSync.Domain.Task, org.DevSync.Domain.Tag, java.util.List" %>
<%@ page import="org.DevSync.Domain.Enum.UserType" %>
<%@ page import="org.DevSync.Domain.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.stream.Collectors" %>
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
    <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
    <div class="mt-4 text-center">
        <a href="user" class="btn btn-secondary">Users</a>
        <a href="tag" class="btn btn-secondary">Tags</a>
        <a href="taskrequest" class="btn btn-secondary">Requests</a>
    </div>
    <% } %>
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
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#taskModal">
        Create New Task
    </button>

    <div class="row">
        <!-- Pending Tasks Column -->
        <div class="col-md-4">
            <h3>Pending Tasks</h3>
            <div class="card-columns">
                <%
                    List<Task> tasksPending = (List<Task>) request.getAttribute("tasksPending");
                    if (tasksPending == null || tasksPending.isEmpty()) {
                %>
                <p>No pending tasks available.</p>
                <%
                } else {
                    for (Task task : tasksPending) {
                %>
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title"><%= task.getTitle() %></h5>
                        <p class="card-text"><%= task.getDescription() %></p>
                        <p><strong>Deadline:</strong> <%= task.getDeadline() %></p>
                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                        <p><strong>Assigned To:</strong> <%= task.getAssignedTo().getUsername() %></p>
                        <% } %>
                        <p><strong>Tags:</strong> <%= task.getTags().stream().map(Tag::getName).collect(Collectors.joining(", ")) %></p>
                        <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">Edit</button>
                        <form class="form-inline d-inline" method="post" action="task">
                            <input type="hidden" name="id" value="<%= task.getId() %>">
                            <input type="hidden" name="action" value="delete">
                            <button class="btn btn-sm btn-danger">Delete</button>
                        </form>
                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.USER) { %>
                        <form class="form-inline d-inline" method="post" action="task">
                            <input type="hidden" name="id" value="<%= task.getId() %>">
                            <input type="hidden" name="action" value="request">
                            <button class="btn btn-sm btn-success">Change</button>
                        </form>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <!-- In Progress Tasks Column -->
        <div class="col-md-4">
            <h3>In Progress Tasks</h3>
            <div class="card-columns">
                <%
                    List<Task> tasksInProcess = (List<Task>) request.getAttribute("tasksInProcess");
                    if (tasksInProcess == null || tasksInProcess.isEmpty()) {
                %>
                <p>No in-progress tasks available.</p>
                <%
                } else {
                    for (Task task : tasksInProcess) {
                %>
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title"><%= task.getTitle() %></h5>
                        <p class="card-text"><%= task.getDescription() %></p>
                        <p><strong>Deadline:</strong> <%= task.getDeadline() %></p>
                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                        <p><strong>Assigned To:</strong> <%= task.getAssignedTo().getUsername() %></p>
                        <% } %>
                        <p><strong>Tags:</strong> <%= task.getTags().stream().map(Tag::getName).collect(Collectors.joining(", ")) %></p>
                        <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">Edit</button>
                        <form class="form-inline d-inline" method="post" action="task">
                            <input type="hidden" name="id" value="<%= task.getId() %>">
                            <input type="hidden" name="action" value="delete">
                            <button class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <!-- Completed Tasks Column -->
        <div class="col-md-4">
            <h3>Completed Tasks</h3>
            <div class="card-columns">
                <%
                    List<Task> tasksCompleted = (List<Task>) request.getAttribute("tasksCompleted");
                    if (tasksCompleted == null || tasksCompleted.isEmpty()) {
                %>
                <p>No completed tasks available.</p>
                <%
                } else {
                    for (Task task : tasksCompleted) {
                %>
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title"><%= task.getTitle() %></h5>
                        <p class="card-text"><%= task.getDescription() %></p>
                        <p><strong>Deadline:</strong> <%= task.getDeadline() %></p>
                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                        <p><strong>Assigned To:</strong> <%= task.getAssignedTo().getUsername() %></p>
                        <% } %>
                        <p><strong>Tags:</strong> <%= task.getTags().stream().map(Tag::getName).collect(Collectors.joining(", ")) %></p>
                        <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">Edit</button>
                        <form class="form-inline d-inline" method="post" action="task">
                            <input type="hidden" name="id" value="<%= task.getId() %>">
                            <input type="hidden" name="action" value="delete">
                            <button class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>
</div>

<!-- Task Modal for Adding/Editing Task -->
<div class="modal fade" id="taskModal" tabindex="-1" aria-labelledby="taskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="taskModalLabel">Add Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="taskForm" method="post" action="task">
                    <input type="hidden" id="taskId" name="taskId">
                    <input type="hidden" name="action" id="taskAction" value="create">
                    <div class="mb-3">
                        <label for="title" class="form-label">Title</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="deadline" class="form-label">Deadline</label>
                        <input type="datetime-local" class="form-control" id="deadline" name="deadline" required>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-control" id="status" name="status">
                            <option value="NOT_STARTED">Pending</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="COMPLETED">Completed</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="tags" class="form-label">Tags</label>
                        <select class="form-control" id="tags" name="tagName" multiple>
                            <%
                                List<Tag> tags = (List<Tag>) request.getAttribute("tags");
                                for (Tag tag : tags) {
                            %>
                            <option value="<%= tag.getName() %>"><%= tag.getName() %></option>
                            <%
                                }
                            %>
                        </select>
                        <small class="form-text text-muted">Select multiple tags (hold Ctrl or Cmd to select more than one).</small>
                    </div>
                    <!-- Only show user selection if the logged-in user is an admin -->
                    <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                    <div class="mb-3">
                        <label for="userId" class="form-label">Assign To</label>
                        <select class="form-control" id="userId" name="userId">
                            <%
                                List<User> users = (List<User>) request.getAttribute("users");
                                for (User user : users) {
                            %>
                            <option value="<%= user.getId() %>"><%= user.getUsername() %></option>
                            <% } %>
                        </select>
                    </div>
                    <% } %>
                    <button type="submit" class="btn btn-primary">Save Task</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Edit Task Modals -->
<%
    List<Task> allTasks = new ArrayList<>();
    allTasks.addAll(tasksPending);
    allTasks.addAll(tasksInProcess);
    allTasks.addAll(tasksCompleted);
    for (Task task : allTasks) {
%>
<div class="modal fade" id="editTaskModal<%= task.getId() %>" tabindex="-1" aria-labelledby="editTaskModalLabel<%= task.getId() %>" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editTaskModalLabel<%= task.getId() %>">Edit Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editTask" method="post" action="task">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= task.getId() %>">
                    <div class="mb-3">
                        <label for="addTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addTitle" name="title" value="<%= task.getTitle() %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="addDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="addDescription" name="description" required><%= task.getDescription() %></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="addDeadline" class="form-label">Deadline</label>
                        <input type="datetime-local" class="form-control" id="addDeadline" name="deadline" value="<%= task.getDeadline() %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="addStatus" class="form-label">Status</label>
                        <select class="form-control" id="addStatus" name="status">
                            <option value="NOT_STARTED" <%= task.getTaskStatus().equals("NOT_STARTED") ? "selected" : "" %>>Pending</option>
                            <option value="IN_PROGRESS" <%= task.getTaskStatus().equals("IN_PROGRESS") ? "selected" : "" %>>In Progress</option>
                            <option value="COMPLETED" <%= task.getTaskStatus().equals("COMPLETED") ? "selected" : "" %>>Completed</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="addTags" class="form-label">Tags</label>
                        <select class="form-control" id="addTags" name="tagName" multiple>

                            <% for (Tag tag : (List<Tag>) request.getAttribute("tags")) { %>
                            <option value="<%= tag.getName() %>" <%= task.getTags().contains(tag) ? "selected" : "" %>><%= tag.getName() %></option>
                            <% } %>
                        </select>
                        <small class="form-text text-muted">Select multiple tags (hold Ctrl or Cmd to select more than one).</small>
                    </div>
                    <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                    <div class="mb-3">
                        <label for="addUserId" class="form-label">Assign To</label>
                        <select class="form-control" id="addUserId" name="userId">
                            <% for (User user : (List<User>) request.getAttribute("users")) { %>
                            <option value="<%= user.getId() %>" <%= task.getAssignedTo().getId() == user.getId() ? "selected" : "" %>><%= user.getUsername() %></option>
                            <% } %>
                        </select>
                    </div>
                    <% } %>
                    <button type="submit" class="btn btn-primary">Save Task</button>
                </form>
            </div>
        </div>
    </div>
</div>
<%
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
