package org.DevSync.Servelet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.DevSync.Domain.User;
import org.DevSync.Service.Implementation.UserServiceImpl;
import org.DevSync.Service.Interface.UserService;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("list".equalsIgnoreCase(req.getParameter("action"))){
            list(req, resp);
        }
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
        String password = request.getParameter("password");
        String usertype = request.getParameter("usertype");

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
        String usertype = request.getParameter("usertype");
        User user = userService.read(UserId);
        if (user != null) {
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
        List<User> users = userService.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("user.jsp").forward(request, response);
    }

    public String hashPassword(String plainPassword) {
        try {
            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            // Add plain-text password bytes to digest
            byte[] hashedBytes = md.digest(plainPassword.getBytes());

            // Convert the byte array into hexadecimal format
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            // Return the hashed password in hexadecimal format
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}
