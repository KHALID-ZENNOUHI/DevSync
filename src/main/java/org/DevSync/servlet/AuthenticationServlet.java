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
import org.DevSync.domain.User;
import org.DevSync.repository.Implementation.UserRepositoryImpl;
import org.DevSync.service.Implementation.UserServiceImpl;
import org.DevSync.service.Interface.UserService;
import org.DevSync.util.PasswordHash;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/")
public class AuthenticationServlet extends HttpServlet {
    private UserService userService;
    private PasswordHash passwordHash;
    @Override
    public void init(ServletConfig config) throws ServletException {
        this.userService = new UserServiceImpl(new UserRepositoryImpl());
        TaskChangeRequestScheduler taskChangeRequestScheduler = new TaskChangeRequestScheduler();
        taskChangeRequestScheduler.start();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        Optional<User> userOptional = this.userService.findByEmail(email);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            String passwordHashed = user.getPassword();

            if (PasswordHash.checkPassword(password, passwordHashed)) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);

                switch (user.getUserType().name()) {
                    case "MANAGER":
                        resp.sendRedirect("user");
                        break;
                    case "USER":
                        resp.sendRedirect("task");
                        break;
                    default:
                        resp.sendRedirect("login");
                        break;
                }
            } else {
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    public void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        session.invalidate();
        req.getContextPath();
        resp.sendRedirect("/");
    }
}
