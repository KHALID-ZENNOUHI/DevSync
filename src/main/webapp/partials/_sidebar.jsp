<%@ page import="org.DevSync.domain.User" %>
<%@ page import="org.DevSync.domain.Enum.UserType" %>
<!-- Left Sidebar Start -->
<div class="app-sidebar-menu">
    <div class="h-100" data-simplebar>

        <!--- Sidemenu -->
        <div id="sidebar-menu">

            <div class="logo-box">
                <a class='logo logo-light' href='#'>
                                <span class="logo-sm">
                                    <img src="assets/images/logo-sm.png" alt="" height="22">
                                </span>
                    <span class="logo-lg">
                                    <img src="assets/images/logo-light.png" alt="" height="24">
                                </span>
                </a>
                <a class='logo logo-dark' href='#'>
                                <span class="logo-sm">
                                    <img src="assets/images/logo-sm.png" alt="" height="22">
                                </span>
                    <span class="logo-lg">
                                    <img src="assets/images/logo-dark.png" alt="" height="24">
                                </span>
                </a>
            </div>

            <ul id="side-menu">

                <li class="menu-title">Menu</li>
                <% User user =(User) session.getAttribute("user");
                    if(user.getUserType() == UserType.MANAGER){ %>

                <li>
                    <a href='#'>
                        <i data-feather="home"></i>
                        <span class="badge bg-success rounded-pill float-end">9+</span>
                        <span> Dashboard </span>
                    </a>
                </li>

                <li>
                    <a href='user'>
                        <i data-feather="users"></i>
                        <span> Users </span>
                    </a>
                </li>

                <li>
                    <a href='taskrequest'>
                        <i data-feather="send"></i>
                        <span> Requests </span>
                    </a>
                </li>

                <li>
                    <a href='task'>
                        <i data-feather="file-text"></i>
                        <span> Tasks </span>
                    </a>
                </li>
                <% } else { %>
                <li>
                    <a href='task'>
                        <i data-feather="file-text"></i>
                        <span> Tasks </span>
                    </a>
                </li>

                <%  } %>


            </ul>

        </div>
        <!-- End Sidebar -->


    </div>
</div>
<!-- Left Sidebar End -->