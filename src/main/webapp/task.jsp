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
<div class="container">
    <h1 class="text-center my-4">Task Management</h1>

    <!-- Button to trigger task modal -->
    <div class="d-flex justify-content-end mb-3">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#taskModal">
            Add Task
        </button>
    </div>

    <div class="row">
        <!-- Pending Tasks Column -->
        <div class="col-md-4">
            <h3>Pending Tasks</h3>
            <div class="card-columns">
                <%
                    List<Task> tasksPending = (List<Task>) request.getAttribute("tasksPending");
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
                        <p><strong>Tags:</strong>
                                <%
                            String tagTitles = task.getTags().stream()
                                    .map(Tag::getName)
                                    .collect(Collectors.joining(", "));
                        %>
                            <p><%= tagTitles %> </p>
                            <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                Edit
                            </button>
                        <button class="btn btn-sm btn-danger" onclick="deleteTask(<%= task.getId() %>)">Delete</button>
                    </div>
                </div>
                <%
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
                        <p><strong>Tags:</strong>
                                <%
                            String tagTitles = task.getTags().stream()
                                    .map(Tag::getName)
                                    .collect(Collectors.joining(", "));
                        %>
                            <p><%= tagTitles %> </p>
                            <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                Edit
                            </button>
                        <button class="btn btn-sm btn-danger" onclick="deleteTask(<%= task.getId() %>)">Delete</button>
                    </div>
                </div>
                <%
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
                        <p><strong>Tags:</strong>
                        <%
                            String tagTitles = task.getTags().stream()
                                    .map(Tag::getName)
                                    .collect(Collectors.joining(", "));
                        %>
                        <p><%= tagTitles %> </p>
                            <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                Edit
                            </button>
                        <button class="btn btn-sm btn-danger" onclick="deleteTask(<%= task.getId() %>)">Delete</button>
                    </div>
                </div>
                <%
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
                <form id="addTaskForm" method="post" action="task">
                    <input type="hidden" name="action" value="create">
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
