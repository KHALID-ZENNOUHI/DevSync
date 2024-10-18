package org.DevSync.servlet;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.DevSync.domain.Enum.UserType;
import org.DevSync.domain.Jeton;
import org.DevSync.domain.User;
import org.DevSync.repository.Implementation.UserRepositoryImpl;
import org.DevSync.service.Implementation.JetonServiceImpl;
import org.DevSync.service.Implementation.UserServiceImpl;
import org.DevSync.service.Interface.JetonService;
import org.DevSync.service.Interface.UserService;
import org.DevSync.util.PasswordHash;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private UserService userService;
    private JetonService jetonService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.userService = new UserServiceImpl(new UserRepositoryImpl());
        this.jetonService = new JetonServiceImpl();
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
        User user = getAllAttributes(request);
        User savedUser = userService.create(user);
        if (savedUser.getUserType() == UserType.USER) {
            Jeton jeton = new Jeton();
            jeton.setUser(savedUser);
            jeton.setDeleteJeton(1);
            jeton.setChangeJeton(2);
            jeton.setLastResetDate(LocalDateTime.now());
            jetonService.create(jeton);
        }
        HttpSession session = request.getSession();
        session.setAttribute("message", "User created successfully!");
        response.sendRedirect("user?action=list");
    }

    public void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getAllAttributes(request);
        userService.update(user);
        HttpSession session = request.getSession();
        session.setAttribute("message", "User updated successfully!");
        response.sendRedirect("user?action=list");
    }

    public void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        userService.delete(userId);
        HttpSession session = request.getSession();
        session.setAttribute("message", "User deleted successfully!");
        response.sendRedirect("user?action=list");
    }


    public void list(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setAttribute("users", userService.findAll());
        request.getRequestDispatcher("user.jsp").forward(request, response);
    }

    public User getAllAttributes(HttpServletRequest request) {
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = PasswordHash.hashPassword(request.getParameter("password"));
        UserType usertype = UserType.valueOf(request.getParameter("usertype"));

        if (request.getParameter("action").equalsIgnoreCase("update")) {
            Long userId = Long.parseLong(request.getParameter("id"));
            Optional<User> userOptional = userService.findById(userId);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                user.setUsername(username);
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setEmail(email);
                user.setPassword(password);
                user.setUserType(usertype);
                return user;
            }
        }

        return new User(username, firstName, lastName, email, password, usertype);
    }

}
