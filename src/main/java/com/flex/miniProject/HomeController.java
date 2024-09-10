package com.flex.miniProject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class HomeController {
    @RequestMapping("/index")
    public String home(HttpServletRequest req) {
        req.setAttribute("contentPage", "mainpage.jsp");
        return "index";
    }
}