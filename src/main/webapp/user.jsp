<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.DevSync.domain.User" %>
<!DOCTYPE html>
<html lang="en">

<!-- Mirrored from zoyothemes.com/kadso/html/ by HTTrack Website Copier/3.x [XR&CO'2014], Tue, 08 Oct 2024 10:43:05 GMT -->
<!-- Added by HTTrack --><meta http-equiv="content-type" content="text/html;charset=UTF-8" /><!-- /Added by HTTrack -->
<head>

    <meta charset="utf-8" />
    <title>Users</title>
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
                        <i data-feather="users" class="me-2"></i>
                        <h4 class="fs-18 fw-semibold m-0">Users</h4>
                    </div>
                </div>

                <!-- Display users-->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="card-title mb-0">All Users</h5>
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                        Create New User
                                    </button>
                                </div>
                            </div><!-- end card header -->

                            <div class="card-body">
                                <table id="dynamic-datatable" class="table table-bordered dt-responsive table-responsive nowrap">
                                    <thead>
                                    <tr>
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
                                        List<User> users = (List<User>) request.getAttribute("users");
                                        if (users != null && !users.isEmpty()) {
                                            for (User user : users) {
                                    %>
                                    <tr>
                                        <td><%= user.getUsername() %></td>
                                        <td><%= user.getFirstName() %></td>
                                        <td><%= user.getLastName() %></td>
                                        <td><%= user.getEmail() %></td>
                                        <td><%= user.getUserType() %></td>
                                        <td>
                                            <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editUserModal<%= user.getId() %>">
                                                Edit
                                            </button>

                                            <!-- Modal for editing User (unique for each user) -->
                                            <div class="modal fade" id="editUserModal<%= user.getId() %>" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel<%= user.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editUserModalLabel<%= user.getId() %>">Edit User: <%= user.getUsername() %></h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form action="user" method="POST">
                                                                <input type="hidden" name="id" value="<%= user.getId() %>">

                                                                <div class="row g-3">
                                                                    <div class="col-xxl-6">
                                                                        <div>
                                                                            <label for="username<%= user.getId() %>" class="form-label">Username</label>
                                                                            <input type="text" class="form-control" id="username<%= user.getId() %>" name="username" value="<%= user.getUsername() %>" required>
                                                                        </div>
                                                                    </div><!--end col-->
                                                                    <div class="col-xxl-6">
                                                                        <div>
                                                                            <label for="firstName<%= user.getId() %>" class="form-label">First Name</label>
                                                                            <input type="text" class="form-control" id="firstName<%= user.getId() %>" name="firstName" value="<%= user.getFirstName() %>" required>
                                                                        </div>
                                                                    </div><!--end col-->
                                                                    <div class="col-xxl-6">
                                                                        <div>
                                                                            <label for="lastName<%= user.getId() %>" class="form-label">Last Name</label>
                                                                            <input type="text" class="form-control" id="lastName<%= user.getId() %>" name="lastName" value="<%= user.getLastName() %>" required>
                                                                        </div>
                                                                    </div><!--end col-->
                                                                    <div class="col-xxl-6">
                                                                        <div>
                                                                            <label for="email<%= user.getId() %>" class="form-label">Email</label>
                                                                            <input type="email" class="form-control" id="email<%= user.getId() %>" name="email" value="<%= user.getEmail() %>" required>
                                                                        </div>
                                                                    </div><!--end col-->
                                                                    <div class="col-xxl-6">
                                                                        <div>
                                                                            <label for="password<%= user.getId() %>" class="form-label">Password</label>
                                                                            <input type="password" class="form-control" id="password<%= user.getId() %>" name="password" value="<%= user.getPassword() %>" required>
                                                                        </div>
                                                                    </div><!--end col-->
                                                                    <div class="col-xxl-6">
                                                                        <label for="usertype<%= user.getId() %>" class="form-label">User Type</label>
                                                                        <select class="form-control" id="usertype<%= user.getId() %>" name="usertype" required>
                                                                            <option value="USER" <%= user.getUserType().name().equalsIgnoreCase("USER") ? "selected" : "" %>>User</option>
                                                                            <option value="MANAGER" <%= user.getUserType().name().equalsIgnoreCase("MANAGER") ? "selected" : "" %>>Manager</option>
                                                                        </select>
                                                                    </div><!--end col-->
                                                                    <div class="col-lg-12">
                                                                        <div class="hstack gap-2 justify-content-end">
                                                                            <input type="hidden" name="action" value="update">
                                                                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                                            <button type="submit" class="btn btn-primary">Update User</button>
                                                                        </div>
                                                                    </div><!--end col-->
                                                                </div><!--end row-->
                                                            </form> <!-- end form -->
                                                        </div> <!-- end modal body -->
                                                    </div> <!-- end modal content -->
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
                                        <td colspan="6" class="text-center">No users found.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Display users-->

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
<!-- Modal for Adding New User -->
<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="user" method="POST">
                    <div class="row g-3">
                        <div class="col-xxl-6">
                            <div>
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required placeholder="Enter username">
                            </div>
                        </div><!--end col-->
                        <div class="col-xxl-6">
                            <div>
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" required placeholder="Enter first name">
                            </div>
                        </div><!--end col-->
                        <div class="col-xxl-6">
                            <div>
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" required placeholder="Enter last name">
                            </div>
                        </div><!--end col-->
                        <div class="col-xxl-6">
                            <div>
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required placeholder="Enter your email">
                            </div>
                        </div><!--end col-->
                        <div class="col-xxl-6">
                            <div>
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required placeholder="Enter password">
                            </div>
                        </div><!--end col-->
                        <div class="col-xxl-6">
                            <label for="usertype" class="form-label">User Type</label>
                            <select class="form-control" id="usertype" name="usertype" required>
                                <option value="USER">User</option>
                                <option value="MANAGER">Manager</option>
                            </select>
                        </div><!--end col-->
                        <div class="col-lg-12">
                            <div class="hstack gap-2 justify-content-end">
                                <input type="hidden" name="action" value="create">
                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Add User</button>
                            </div>
                        </div><!-- end col -->
                    </div><!-- end row -->
                </form> <!-- end form -->
            </div> <!-- end modal body -->
        </div> <!-- end modal content -->
    </div>
</div>


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

