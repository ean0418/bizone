package com.flex.bizone.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MainController {

    @RequestMapping("/main")
    public String map(HttpServletRequest req) {
        req.setAttribute("contentPage", "map/map.jsp");
        return "index";
    }
    @RequestMapping(value = "/main.go", method = RequestMethod.GET)
    public String main2(HttpServletRequest req) {
        return map(req);
    }

    @RequestMapping("/board")
    public String board(HttpServletRequest req) {
        req.setAttribute("contentPage", "board/list.jsp");
        return "index";
    }
    @RequestMapping("/info")
    public String info(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/info.jsp");
        return "index";
    }
    @RequestMapping("/rank")
    public String rank(HttpServletRequest req) {
        req.setAttribute("contentPage", "rank/rank.jsp");
        return "index";
    }
}