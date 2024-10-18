<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.DevSync.domain.User" %>
<%@ page import="org.DevSync.domain.Task" %>
<%@ page import="org.DevSync.domain.Tag" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="org.DevSync.domain.Enum.UserType" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Tasks</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Task Management Board" />
    <meta name="author" content="Your Name" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <link rel="shortcut icon" href="assets/images/favicon.ico">
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" id="app-style" />
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
          integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Add custom CSS for drag and drop styling -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .draggable-zone {
            display: flex;
            justify-content: space-between;
        }
        .draggable {
            margin-bottom: 20px;
        }
        .dropzone {
            border: 2px dashed #ccc;
            padding: 10px;
            min-height: 300px;
            position: relative; /* Added to position the drop target */
        }
        .dropzone.over {
            background-color: #f0f0f0;
        }
        .card.draggable-card {
            cursor: move;
        }
        .card.draggable-card.placeholder {
            border: 2px dashed #007bff; /* Style for the placeholder */
            background-color: #e0e7ff; /* Light blue background for placeholder */
            opacity: 0.5; /* Slightly transparent */
        }
    </style>
</head>

<body data-menu-color="dark" data-sidebar="default">

<div id="app-layout">
    <jsp:include page="partials/_header.jsp"></jsp:include>
    <jsp:include page="partials/_sidebar.jsp"></jsp:include>

    <div class="content-page">
        <div class="content">
            <div class="container-xxl">
                <div class="py-3 d-flex align-items-sm-center flex-sm-row flex-column">
                    <div class="flex-grow-1 d-flex align-items-center">
                        <i data-feather="file-text"></i>
                        <h4 class="fs-18 fw-semibold m-0">Task Management</h4>
                    </div>
                </div>
                <div class="card px-3">
                    <div class="py-3 d-flex align-items-sm-center flex-sm-row flex-column">
                        <div class="flex-grow-1 d-flex align-items-center">
                            <i data-feather="file-text"></i>
                            <h4 class="fs-18 fw-semibold m-0">Tasks</h4>
                        </div>
                        <div>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#taskModal">
                                <i class="fas fa-plus me-2"></i> Add New Task
                            </button>
                        </div>
                    </div>
                </div>

                <div class="row draggable-zone">
                    <!-- Pending Tasks Column -->
                    <div class="col-md-4">
                        <h3 class="text-center">Pending Tasks</h3>
                        <div class="dropzone" id="pendingTasks" ondragover="allowDrop(event)" ondrop="drop(event)">
                            <%
                                List<Task> tasksPending = (List<Task>) request.getAttribute("tasksPending");
                                if (tasksPending == null || tasksPending.isEmpty()) {
                            %>
                            <span></span>
                            <%
                            } else {
                                for (Task task : tasksPending) {
                            %>
                            <div class="card draggable-card" draggable="true" ondragstart="drag(event)" id="task-<%= task.getId() %>">
                                <div class="card-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm rounded me-3 d-flex align-items-center justify-content-center">
                                                <img src="assets/images/users/user-11.jpg" class="img-fluid rounded-circle" alt="">
                                            </div>
                                            <div>
                                                <h5 class="fs-14 mb-1"><%= task.getAssignedTo().getUsername() %></h5>
                                            </div>
                                        </div>
                                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.USER) { %>
                                        <div>
                                            <form class="form-inline d-inline" method="post" action="task">
                                                <input type="hidden" name="id" value="<%= task.getId() %>">
                                                <input type="hidden" name="action" value="request">
                                                <button type="submit" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                                    <i data-feather="send"></i>
                                                </button>
                                            </form>
                                        </div>
                                        <% } %>
                                    </div>

                                </div>
                                <div class="card-body">
                                    <h5 class="card-title"><%= task.getTitle() %></h5>
                                    <p class="card-text text-muted"><%= task.getDescription() %></p>
                                    <% for (Tag tag : task.getTags()) { %>
                                    <span class="badge rounded-pill text-bg-secondary"><%= tag.getName() %></span>
                                    <% } %>
                                </div>
                                <div class="card-footer text-muted d-flex justify-content-between align-items-center">
                                    <span><%= task.getDeadline() %></span>
                                    <div>
                                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                                        <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                            <i class="fas fa-pen me-2" style="cursor: pointer;" ></i>
                                        </button>
                                        <% } %>
                                        <form class="form-inline d-inline" method="post" action="task">
                                            <input type="hidden" name="id" value="<%= task.getId() %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="btn btn-link"><i class="fas fa-trash" style="cursor: pointer;" ></i></button>
                                        </form>
                                    </div>
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
                        <h3 class="text-center">In Progress Tasks</h3>
                        <div class="dropzone" id="inProgressTasks" ondragover="allowDrop(event)" ondrop="drop(event)">
                            <%
                                List<Task> tasksInProcess = (List<Task>) request.getAttribute("tasksInProcess");
                                if (tasksInProcess == null || tasksInProcess.isEmpty()) {
                            %>
                            <span></span>
                            <%
                            } else {
                                for (Task task : tasksInProcess) {
                            %>
                            <div class="card draggable-card" draggable="true" ondragstart="drag(event)" id="task-<%= task.getId() %>">
                                <div class="card-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm rounded me-3 d-flex align-items-center justify-content-center">
                                                <img src="assets/images/users/user-11.jpg" class="img-fluid rounded-circle" alt="">
                                            </div>
                                            <div>
                                                <h5 class="fs-14 mb-1"><%= task.getAssignedTo().getUsername() %></h5>
                                            </div>
                                        </div>
                                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.USER) { %>
                                        <div>
                                            <form class="form-inline d-inline" method="post" action="task">
                                                <input type="hidden" name="id" value="<%= task.getId() %>">
                                                <input type="hidden" name="action" value="request">
                                                <button type="submit" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                                    <i data-feather="send"></i>
                                                </button>
                                            </form>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title"><%= task.getTitle() %></h5>
                                    <p class="card-text text-muted"><%= task.getDescription() %></p>
                                    <% for (Tag tag : task.getTags()) { %>
                                    <span class="badge rounded-pill text-bg-secondary"><%= tag.getName() %></span>
                                    <% } %>
                                </div>
                                <div class="card-footer text-muted d-flex justify-content-between align-items-center">
                                    <span><%= task.getDeadline() %></span>
                                    <div>
                                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                                        <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                            <i class="fas fa-pen me-2" style="cursor: pointer;" ></i>
                                        </button>
                                        <% } %>
                                        <form class="form-inline d-inline" method="post" action="task">
                                            <input type="hidden" name="id" value="<%= task.getId() %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="btn btn-link"><i class="fas fa-trash" style="cursor: pointer;" ></i></button>
                                        </form>
                                    </div>
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
                        <h3 class="text-center">Completed Tasks</h3>
                        <div class="dropzone" id="completedTasks" ondragover="allowDrop(event)" ondrop="drop(event)">
                            <%
                                List<Task> tasksCompleted = (List<Task>) request.getAttribute("tasksCompleted");
                                if (tasksCompleted == null || tasksCompleted.isEmpty()) {
                            %>
                            <span></span>
                            <%
                            } else {
                                for (Task task : tasksCompleted) {
                            %>
                            <div class="card draggable-card" draggable="true" ondragstart="drag(event)" id="task-<%= task.getId() %>">
                                <div class="card-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm rounded me-3 d-flex align-items-center justify-content-center">
                                                <img src="assets/images/users/user-11.jpg" class="img-fluid rounded-circle" alt="">
                                            </div>
                                            <div>
                                                <h5 class="fs-14 mb-1"><%= task.getAssignedTo().getUsername() %></h5>
                                            </div>
                                        </div>
                                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.USER) { %>
                                        <div>
                                            <form class="form-inline d-inline" method="post" action="task">
                                                <input type="hidden" name="id" value="<%= task.getId() %>">
                                                <input type="hidden" name="action" value="request">
                                                <button type="submit" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                                    <i data-feather="send"></i>
                                                </button>
                                            </form>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title"><%= task.getTitle() %></h5>
                                    <p class="card-text text-muted"><%= task.getDescription() %></p>
                                    <% for (Tag tag : task.getTags()) { %>
                                    <span class="badge rounded-pill text-bg-secondary"><%= tag.getName() %></span>
                                    <% } %>
                                </div>
                                <div class="card-footer text-muted d-flex justify-content-between align-items-center">
                                    <span><%= task.getDeadline() %></span>
                                    <div>
                                        <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                                        <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getId() %>">
                                            <i class="fas fa-pen me-2" style="cursor: pointer;" ></i>
                                        </button>

                                        <% } %>
                                        <form class="form-inline d-inline" method="post" action="task">
                                            <input type="hidden" name="id" value="<%= task.getId() %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="btn btn-link"><i class="fas fa-trash" style="cursor: pointer;" ></i></button>
                                        </form>
                                    </div>
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
        </div>

        <!-- Footer Start -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <div class="col fs-13 text-muted text-center">
                        © <script>document.write(new Date().getFullYear())</script> - Made with <span class="mdi mdi-heart text-danger"></span> by <a href="#!" class="text-reset fw-semibold">Your Name</a>
                    </div>
                </div>
            </div>
        </footer>
        <!-- end Footer -->

    </div>
    <!-- End Page content -->

</div>
<!-- END wrapper -->

<!-- Task Modal for Adding Task -->
<!-- Task Modal for Adding Task -->
<div class="modal fade" id="taskModal" tabindex="-1" aria-labelledby="addTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg"> <!-- Set to large for better layout -->
        <div class="modal-content">
            <div class="modal-header bg-primary text-white"> <!-- AdminLTE primary color -->
                <h5 class="modal-title" id="addTaskModalLabel">
                    <i class="fas fa-plus"></i> <!-- Icon for better look -->
                    Add Task
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button> <!-- White close button -->
            </div>
            <div class="modal-body">
                <form id="addTask" method="post" action="task">
                    <input type="hidden" name="action" value="create"> <!-- Action for adding -->

                    <!-- Title Input -->
                    <div class="form-group mb-3">
                        <label for="addTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addTitle" name="title" placeholder="Enter task title" required>
                    </div>

                    <!-- Description Input -->
                    <div class="form-group mb-3">
                        <label for="addDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="addDescription" name="description" rows="4" placeholder="Enter task description" required></textarea>
                    </div>

                    <!-- Deadline Input -->
                    <div class="form-group mb-3">
                        <label for="addDeadline" class="form-label">Deadline</label>
                        <input type="datetime-local" class="form-control" id="addDeadline" name="deadline" required>
                    </div>

                    <!-- Status Dropdown -->
                    <div class="form-group mb-3">
                        <label for="addStatus" class="form-label">Status</label>
                        <select class="form-control" id="addStatus" name="status">
                            <option value="NOT_STARTED">Pending</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="COMPLETED">Completed</option>
                        </select>
                    </div>

                    <!-- Tags Dropdown -->
                    <div class="form-group mb-3">
                        <label for="addTags" class="form-label">Tags</label>
                        <select class="form-control select2" id="addTags" name="tagName" multiple> <!-- Added select2 for better UX -->
                            <% for (Tag tag : (List<Tag>) request.getAttribute("tags")) { %>
                            <option value="<%= tag.getName() %>"><%= tag.getName() %></option>
                            <% } %>
                        </select>
                        <small class="form-text text-muted">Select multiple tags (hold Ctrl or Cmd to select more than one).</small>
                    </div>

                    <!-- Assign to User (Visible for Manager only) -->
                    <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                    <div class="form-group mb-3">
                        <label for="addUserId" class="form-label">Assign To</label>
                        <select class="form-control select2" id="addUserId" name="userId"> <!-- select2 for better user experience -->
                            <% for (User user : (List<User>) request.getAttribute("users")) { %>
                            <option value="<%= user.getId() %>"><%= user.getUsername() %></option>
                            <% } %>
                        </select>
                    </div>
                    <% } %>

                    <!-- Save Button -->
                    <div class="text-end"> <!-- Align the button to the right -->
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Task
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>



<%
    List<Task> allTasks = new ArrayList<>();
    allTasks.addAll(tasksPending);
    allTasks.addAll(tasksInProcess);
    allTasks.addAll(tasksCompleted);
    for (Task task : allTasks) {
%>
<!-- Edit Task Modal -->
<div class="modal fade" id="editTaskModal<%= task.getId() %>" tabindex="-1" aria-labelledby="editTaskModalLabel<%= task.getId() %>" aria-hidden="true">
    <div class="modal-dialog modal-lg"> <!-- Set to large for better layout -->
        <div class="modal-content">
            <div class="modal-header bg-primary text-white"> <!-- AdminLTE primary color -->
                <h5 class="modal-title" id="editTaskModalLabel<%= task.getId() %>">
                    <i class="fas fa-edit"></i> <!-- Icon for better look -->
                    Edit Task
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button> <!-- White close button -->
            </div>
            <div class="modal-body">
                <form id="editTask" method="post" action="task">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= task.getId() %>">

                    <!-- Title Input -->
                    <div class="form-group mb-3">
                        <label for="addTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="addTitle" name="title" value="<%= task.getTitle() %>" required>
                    </div>

                    <!-- Description Input -->
                    <div class="form-group mb-3">
                        <label for="addDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="addDescription" name="description" rows="4" required><%= task.getDescription() %></textarea>
                    </div>

                    <!-- Deadline Input -->
                    <div class="form-group mb-3">
                        <label for="addDeadline" class="form-label">Deadline</label>
                        <input type="datetime-local" class="form-control" id="addDeadline" name="deadline" value="<%= task.getDeadline() %>" required>
                    </div>

                    <!-- Status Dropdown -->
                    <div class="form-group mb-3">
                        <label for="addStatus" class="form-label">Status</label>
                        <select class="form-control" id="addStatus" name="status">
                            <option value="NOT_STARTED" <%= task.getTaskStatus().equals("NOT_STARTED") ? "selected" : "" %>>Pending</option>
                            <option value="IN_PROGRESS" <%= task.getTaskStatus().equals("IN_PROGRESS") ? "selected" : "" %>>In Progress</option>
                            <option value="COMPLETED" <%= task.getTaskStatus().equals("COMPLETED") ? "selected" : "" %>>Completed</option>
                        </select>
                    </div>

                    <!-- Tags Dropdown -->
                    <div class="form-group mb-3">
                        <label for="addTags" class="form-label">Tags</label>
                        <select class="form-control select2" id="addTags" name="tagName" multiple> <!-- Added select2 for better UX -->
                            <% for (Tag tag : (List<Tag>) request.getAttribute("tags")) { %>
                            <option value="<%= tag.getName() %>" <%= task.getTags().contains(tag) ? "selected" : "" %>><%= tag.getName() %></option>
                            <% } %>
                        </select>
                        <small class="form-text text-muted">Select multiple tags (hold Ctrl or Cmd to select more than one).</small>
                    </div>

                    <!-- Assign to User (Visible for Manager only) -->
                    <% if (((User) session.getAttribute("user")).getUserType() == UserType.MANAGER) { %>
                    <div class="form-group mb-3">
                        <label for="addUserId" class="form-label">Assign To</label>
                        <select class="form-control select2" id="addUserId" name="userId"> <!-- select2 for better user experience -->
                            <% for (User user : (List<User>) request.getAttribute("users")) { %>
                            <option value="<%= user.getId() %>" <%= task.getAssignedTo().getId() == user.getId() ? "selected" : "" %>><%= user.getUsername() %></option>
                            <% } %>
                        </select>
                    </div>
                    <% } %>

                    <!-- Save Button -->
                    <div class="text-end"> <!-- Align the button to the right -->
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Task
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%
    }
%>

<!-- Vendor -->
<script src="assets/libs/jquery/jquery.min.js"></script>
<script src="assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/libs/simplebar/simplebar.min.js"></script>
<script src="assets/libs/node-waves/waves.min.js"></script>
<script src="assets/libs/waypoints/lib/jquery.waypoints.min.js"></script>
<script src="assets/libs/jquery.counterup/jquery.counterup.min.js"></script>
<script src="assets/libs/feather-icons/feather.min.js"></script>
<!-- Bootstrap and JavaScript Dependencies -->
<script src="assets/js/app.js"></script>
<%
    String message = (String) request.getAttribute("message");
%>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Check if the message is not null before showing the alert
    var message = "<%= message != null ? message : "" %>";
    if (message) {
        Swal.fire({
            title: "Notification",
            text: message,
            icon: "info"
        });
    }
</script>


<!-- Custom Drag and Drop JavaScript -->
<script>
    function allowDrop(ev) {
        ev.preventDefault();
        ev.currentTarget.classList.add('over');
    }

    function drop(ev) {
        ev.preventDefault();
        const taskId = ev.dataTransfer.getData("text");
        const taskElement = document.getElementById(taskId);

        // Only append if not dropping onto another task
        if (ev.currentTarget !== taskElement.parentNode) {
            ev.currentTarget.appendChild(taskElement);
        }

        // Remove the 'over' class after drop
        ev.currentTarget.classList.remove('over');

        // Send an AJAX request to update the task status on the server
        const newStatus = ev.currentTarget.id;
        updateTaskStatus(taskId, newStatus);
    }

    function drag(ev) {
        ev.dataTransfer.setData("text", ev.target.id);
    }

    // Remove 'over' class when leaving dropzone
    const dropzones = document.querySelectorAll('.dropzone');
    dropzones.forEach(dropzone => {
        dropzone.addEventListener('dragleave', function () {
            this.classList.remove('over');
        });
    });

    function updateTaskStatus(taskId, newStatus) {
        // Replace '/task' with your actual server-side endpoint
        fetch('/task', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                taskId: taskId,
                status: newStatus,
            }),
        })
            .then(response => response.json())
            .then(data => {
                console.log('Success:', data);
            })
            .catch((error) => {
                console.error('Error:', error);
            });
    }
</script>

</body>
</html>