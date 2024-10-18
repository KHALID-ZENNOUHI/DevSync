<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.DevSync.domain.User" %>
<%@ page import="org.DevSync.domain.TaskChangeRequest" %>
<!DOCTYPE html>
<html lang="en">

<!-- Mirrored from zoyothemes.com/kadso/html/ by HTTrack Website Copier/3.x [XR&CO'2014], Tue, 08 Oct 2024 10:43:05 GMT -->
<!-- Added by HTTrack --><meta http-equiv="content-type" content="text/html;charset=UTF-8" /><!-- /Added by HTTrack -->
<head>

    <meta charset="utf-8" />
    <title>Requests</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A fully featured admin theme which can be used to build CRM, CMS, etc."/>
    <meta name="author" content="Zoyothemes"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <!-- App favicon -->
    <link rel="shortcut icon" href="assets/images/favicon.ico">

    <!-- App css -->
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" id="app-style" />

    <!-- Icons -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />

</head>

<!-- body start -->
<body data-menu-color="dark" data-sidebar="default">

<!-- Begin page -->
<div id="app-layout">


    <!-- Topbar Start -->
    <jsp:include page="partials/_header.jsp"></jsp:include>
    <!-- end Topbar -->

    <!-- Left Sidebar Start -->
    <jsp:include page="partials/_sidebar.jsp"></jsp:include>
    <!-- Left Sidebar End -->

    <!-- ============================================================== -->
    <!-- Start Page Content here -->
    <!-- ============================================================== -->

    <div class="content-page">
        <div class="content">

            <!-- Start Content-->
            <div class="container-xxl">

                <div class="py-3 d-flex align-items-sm-center flex-sm-row flex-column">
                    <div class="flex-grow-1 d-flex align-items-center">
                        <i data-feather="send"></i>
                        <h4 class="fs-18 fw-semibold m-0">Task Change Requests</h4>
                    </div>
                </div>

                <!---requests display--->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Task Change Requests</h5>
                            </div><!-- end card header -->

                            <div class="card-body">
                                <!-- Table for displaying task change requests -->
                                <table class="table table-bordered dt-responsive table-responsive nowrap">
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
                                            </div><!-- end edit task modal -->
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="4" class="text-center">No task change requests found.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div><!-- end card body -->
                        </div><!-- end card -->
                    </div><!-- end col-12 -->
                </div><!-- end row -->

            </div> <!-- container-fluid -->
        </div> <!-- content -->

        <!-- Footer Start -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <div class="col fs-13 text-muted text-center">
                        &copy; <script>document.write(new Date().getFullYear())</script> - Made with <span class="mdi mdi-heart text-danger"></span> by <a href="#!" class="text-reset fw-semibold">KHALID ZENNOUHI</a>
                    </div>
                </div>
            </div>
        </footer>
        <!-- end Footer -->

    </div>
    <!-- ============================================================== -->
    <!-- End Page content -->
    <!-- ============================================================== -->


</div>
<!-- END wrapper -->

<!-- Vendor -->
<script src="assets/libs/jquery/jquery.min.js"></script>
<script src="assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/libs/simplebar/simplebar.min.js"></script>
<script src="assets/libs/node-waves/waves.min.js"></script>
<script src="assets/libs/waypoints/lib/jquery.waypoints.min.js"></script>
<script src="assets/libs/jquery.counterup/jquery.counterup.min.js"></script>
<script src="assets/libs/feather-icons/feather.min.js"></script>


<!-- App js-->
<script src="assets/js/app.js"></script>

</body>
</html>


