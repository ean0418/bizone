package com.flex.miniProject.board;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class BoardController {

    @Autowired
    private BoardDAO boardDAO;

    // 게시글 목록 확인
    @RequestMapping(value = "/board/list", method = RequestMethod.GET)
    public String boardList(HttpServletRequest req, Model model) {
        boardDAO.getAllBoards(req);
        model.addAttribute("contentPage", "../board/list.jsp");
        return "main/index";
    }

    // 게시글 작성 페이지 이동
    @RequestMapping(value = "/board/insert.go", method = RequestMethod.GET)
    public String goInsert(HttpServletRequest req) {
        req.setAttribute("contentPage", "../board/insert.jsp");
        return "main/index";
    }

    // 게시글 작성 처리
    @RequestMapping(value = "/board/insert", method = RequestMethod.POST)
    public String insertBoard(Bizone_board board, HttpServletRequest req) {
        boardDAO.insertBoard(board, req);
        return "redirect:/board/list";
    }

    // 게시글 상세 보기
    @RequestMapping(value = "/board/detail", method = RequestMethod.GET)
    public String boardDetail(@RequestParam("bb_no") int bb_no, HttpServletRequest req) {
        boardDAO.getBoardById(bb_no, req);
        req.setAttribute("contentPage", "../board/detail.jsp");
        return "main/index";
    }

    // 게시글 수정 페이지 이동
    @RequestMapping(value = "/board/update.go", method = RequestMethod.GET)
    public String goUpdate(@RequestParam("bb_no") int bb_no, HttpServletRequest req) {
        boardDAO.getBoardById(bb_no, req);
        req.setAttribute("contentPage", "../board/update.jsp");
        return "main/index";
    }

    // 게시글 수정 처리
    @RequestMapping(value = "/board/update", method = RequestMethod.POST)
    public String updateBoard(Bizone_board board, HttpServletRequest req) {
        boardDAO.updateBoard(board, req);
        return "redirect:/board/list";
    }

    // 게시글 삭제 처리
    @RequestMapping(value = "/board/delete", method = RequestMethod.POST)
    public String deleteBoard(@RequestParam("bb_no") int bb_no, HttpServletRequest req) {
        boardDAO.deleteBoard(bb_no, req);
        return "redirect:/board/list";
    }
}