package com.flex.miniProject.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MainController {
    @RequestMapping("/main")
    public String main(HttpServletRequest req) {
        req.setAttribute("contentPage", "mainpage.jsp");
        return "main/index";
    }
    @RequestMapping(value = "/main.go", method = RequestMethod.GET)
    public String main2(HttpServletRequest req) {
        return main(req);
    }
}