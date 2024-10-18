<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.DevSync.domain.Tag" %>
<!DOCTYPE html>
<html lang="en">

<!-- Mirrored from zoyothemes.com/kadso/html/ by HTTrack Website Copier/3.x [XR&CO'2014], Tue, 08 Oct 2024 10:43:05 GMT -->
<!-- Added by HTTrack --><meta http-equiv="content-type" content="text/html;charset=UTF-8" /><!-- /Added by HTTrack -->
<head>

    <meta charset="utf-8" />
    <title>Tags</title>
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

                <!displaying the list of tags>
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Tags Management</h5>
                            </div><!-- end card header -->

                            <div class="card-body">
                                <!-- Button to trigger Add New Tag modal -->
                                <div class="mb-3">
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTagModal">
                                        Create New Tag
                                    </button>
                                </div>

                                <!-- Table for displaying Tags -->
                                <table id="dynamic-datatable" class="table table-bordered dt-responsive table-responsive nowrap">
                                    <thead>
                                    <tr>
                                        <th>Tag Name</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
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

                                            <!-- Edit Tag Modal (unique for each tag) -->
                                            <div class="modal fade" id="editTagModal<%= tag.getId() %>" tabindex="-1" role="dialog" aria-labelledby="editTagModalLabel<%= tag.getId() %>" aria-hidden="true">
                                                <div class="modal-dialog" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="editTagModalLabel<%= tag.getId() %>">Edit Tag: <%= tag.getName() %></h5>
                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                <span aria-hidden="true">&times;</span>
                                                            </button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form action="tag" method="POST">
                                                                <input type="hidden" name="id" value="<%= tag.getId() %>">

                                                                <div class="form-group">
                                                                    <label for="tag<%= tag.getId() %>">Tag Name</label>
                                                                    <input type="text" class="form-control" id="tag<%= tag.getId() %>" name="name" value="<%= tag.getName() %>" required>
                                                                </div>
                                                                <input type="hidden" name="action" value="update">
                                                                <button type="submit" class="btn btn-primary">Update Tag</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Delete Form -->
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
                                        <td colspan="2" class="text-center">No tags found.</td>
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
<!-- Add New Tag Modal -->
<div class="modal fade" id="addTagModal" tabindex="-1" role="dialog" aria-labelledby="addTagModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addTagModalLabel">Add New Tag</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="tag" method="POST">
                    <div class="form-group">
                        <label for="tagName">Tag Name</label>
                        <input type="text" class="form-control" id="tagName" name="name" required>
                    </div>
                    <input type="hidden" name="action" value="create">
                    <button type="submit" class="btn btn-primary">Add Tag</button>
                </form>
            </div>
        </div>
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
