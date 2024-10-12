package org.DevSync.Servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.DevSync.Domain.Enum.UserType;
import org.DevSync.Domain.User;
import org.DevSync.Service.Implementation.UserServiceImpl;
import org.DevSync.Service.Interface.UserService;
import org.DevSync.Util.PasswordHash;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private UserService userService;
    private PasswordHash passwordHash;

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.userService = new UserServiceImpl();
        this.passwordHash = new PasswordHash();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            list(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("create".equalsIgnoreCase(req.getParameter("action"))) {
            create(req, resp);
        }else if ("delete".equalsIgnoreCase(req.getParameter("action"))){
            delete(req, resp);
        }else if ("update".equalsIgnoreCase(req.getParameter("action"))){
            update(req, resp);
        }
    }

    private void create(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = this.passwordHash.hashPassword(request.getParameter("password"));
        UserType usertype = UserType.valueOf(request.getParameter("usertype"));

        User user = new User(username, firstName, lastName, email, password, usertype);
        userService.create(user);

        response.sendRedirect("user?action=list");
    }

    public void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long UserId = Long.parseLong(request.getParameter("id"));
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        UserType usertype = UserType.valueOf(request.getParameter("usertype"));
        Optional<User> userOptional = userService.findById(UserId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setUsername(username);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPassword(password);
            user.setUserType(usertype);
            userService.update(user);
        }
        response.sendRedirect("user?action=list");
    }

    public void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        userService.delete(userId);
        response.sendRedirect("user?action=list");
    }


    public void list(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setAttribute("users", userService.findAll());
        request.getRequestDispatcher("user.jsp").forward(request, response);
    }

}
