package com.flex.miniProject.board;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
public class BoardController {

    @RequestMapping(value="/board", method=RequestMethod.GET)
    public String board(HttpServletRequest req) {
        req.setAttribute("contentPage", "../board/board.jsp");
        return "main/index";
    }
}
