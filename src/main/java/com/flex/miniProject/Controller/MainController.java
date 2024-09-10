package com.flex.miniProject.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MainController {
    @RequestMapping("/main")
    public String main(HttpServletRequest req) {
        req.setAttribute("contentPage", "mainpage.jsp");
        return "main/main";
    }
}