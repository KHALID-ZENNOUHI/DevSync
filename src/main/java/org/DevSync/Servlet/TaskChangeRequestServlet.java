package org.DevSync.Servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.DevSync.Domain.Enum.UserType;
import org.DevSync.Domain.Jeton;
import org.DevSync.Domain.Task;
import org.DevSync.Domain.User;
import org.DevSync.Service.Implementation.JetonServiceImpl;
import org.DevSync.Service.Implementation.TaskChangeRequestServiceImpl;
import org.DevSync.Service.Implementation.TaskServiceImpl;
import org.DevSync.Service.Implementation.UserServiceImpl;
import org.DevSync.Service.Interface.JetonService;
import org.DevSync.Service.Interface.TaskChangeRequestService;
import org.DevSync.Service.Interface.TaskService;
import org.DevSync.Service.Interface.UserService;

import java.io.IOException;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/taskrequest")
public class TaskChangeRequestServlet extends HttpServlet {
    private TaskChangeRequestService taskChangeRequestService;
    private UserService userService;
    private TaskService taskService;
    private JetonService jetonService;

    public TaskChangeRequestServlet() {
        this.taskChangeRequestService = new TaskChangeRequestServiceImpl();
        this.userService = new UserServiceImpl();
        this.taskService = new TaskServiceImpl();
        this.jetonService = new JetonServiceImpl();
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.taskChangeRequestService = new TaskChangeRequestServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (((User) req.getSession().getAttribute("user")).getUserType() == UserType.MANAGER) listAllTaskRequests(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        approveTaskChangeRequest(req, resp);
    }

    public void listAllTaskRequests(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setAttribute("taskChangeRequests", taskChangeRequestService.findAll());
        request.setAttribute("users", userService.findAll().stream().filter(user -> user.getUserType() == UserType.USER).collect(Collectors.toList()));
        request.getRequestDispatcher("taskrequest.jsp").forward(request, response);
    }

    public void approveTaskChangeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Long taskId = Long.parseLong(request.getParameter("taskId"));
        Long userId = Long.parseLong(request.getParameter("userId"));
        Long taskChangeRequestId = Long.parseLong(request.getParameter("taskRequestId"));

        Optional<User> userOptional = userService.findById(userId);
        if (!userOptional.isPresent()) {
            request.setAttribute("message", "User not found!");
            response.sendRedirect("taskrequest");
            return;
        }
        User user = userOptional.get();

        Optional<Task> taskOptional = taskService.findById(taskId);
        if (!taskOptional.isPresent()) {
            request.setAttribute("message", "Task not found!");
            response.sendRedirect("taskrequest");
            return;
        }
        Task task = taskOptional.get();
        User oldUser = task.getAssignedTo();

        task.setAssignedTo(user);
        task.setAlreadyChanged(true);
        taskService.update(task);
        taskChangeRequestService.delete(taskChangeRequestId);
        Jeton jeton = jetonService.findJetonByUser(oldUser);
        jeton.setChangeJeton(jeton.getChangeJeton() - 1);
        jetonService.update(jeton);
        request.setAttribute("message", "Task change assignment request successfully!");
        response.sendRedirect("taskrequest");
    }
}
