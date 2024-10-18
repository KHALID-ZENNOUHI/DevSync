package org.DevSync.servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.DevSync.domain.Tag;
import org.DevSync.service.Implementation.TagServiceImpl;
import org.DevSync.service.Interface.TagService;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/tag")
public class TagServlet extends HttpServlet {
    private TagService tagService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.tagService = new TagServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        list(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("create".equalsIgnoreCase(req.getParameter("action"))) {
            create(req, resp);
        }else if ("delete".equalsIgnoreCase(req.getParameter("action"))) {
            delete(req, resp);
        } else if ("update".equalsIgnoreCase(req.getParameter("action"))) {
            update(req, resp);
        }
    }

    public void create(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        Tag tag = new Tag(name);
        tagService.create(tag);
        response.sendRedirect("tag?action=list");
    }

    public void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String name = request.getParameter("name");
        Optional<Tag> tagOptional = tagService.findById(id);
        if (tagOptional.isPresent()) {
            Tag tag = tagOptional.get();
            tag.setName(name);
            tagService.update(tag);
        }
        response.sendRedirect("tag?action=list");
    }

    public void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        tagService.delete(id);
        response.sendRedirect("tag?action=list");
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setAttribute("tags", tagService.findAll());
        request.getRequestDispatcher("tag.jsp").forward(request, response);
    }
}
