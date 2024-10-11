package com.flex.bizone.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class HomeController {
    @RequestMapping("/")
    public String home(HttpServletRequest req) {
        req.setAttribute("contentPage", "map/map.jsp");
        return "index";
    }
}
