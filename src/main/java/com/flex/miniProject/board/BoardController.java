package com.flex.miniProject.board;

import com.flex.miniProject.member.Bizone_member;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class BoardController {

    @Autowired
    private BoardDAO boardDAO;

    @Autowired
    private CommentDAO commentDAO;

    // 게시판 기본 URL로 들어오면 /board/list로 리다이렉트
    @RequestMapping(value = "/board", method = RequestMethod.GET)
    public String redirectToBoardList() {
        return "redirect:/board/list"; // /board로 들어올 경우 /board/list로 리다이렉트
    }

    // 게시글 목록 조회
    @RequestMapping(value = "/board/list", method = RequestMethod.GET)
    public String boardList(@RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "") String bb_nickname,
                            HttpServletRequest req, Model model) {
        boardDAO.getAllBoards(page, bb_nickname, req); // 게시글 목록을 요청
        model.addAttribute("boardList", req.getAttribute("boardList")); // boardList를 JSP로 전달
        model.addAttribute("page", req.getAttribute("page"));
        model.addAttribute("totalPages", req.getAttribute("totalPages"));
        model.addAttribute("bb_nickname", bb_nickname); // 검색 필터값 유지
        model.addAttribute("contentPage", "board/list.jsp");
        return "index";
    }

    // 게시글 작성 페이지 이동
    @RequestMapping(value = "/board/insert.go", method = RequestMethod.GET)
    public String goInsert(HttpServletRequest req, RedirectAttributes rdAttr) {
        if (req.getSession().getAttribute("loginMember") == null) {
            rdAttr.addFlashAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            // req.setAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            // 리다이렉트시 attribute 값은 날아감
            // 날아가지 않게 리다이렉트 하는 방법?
            // => RedirectAttributes
            return "redirect:/board/list";
        }
        req.setAttribute("contentPage", "board/insert.jsp");
        return "index";
    }

    // 게시글 작성 처리
    @RequestMapping(value = "/board/insert", method = RequestMethod.POST)
    public String insertBoard(Bizone_board board, HttpServletRequest req, RedirectAttributes rdAttr) {
        try {
            if (req.getSession().getAttribute("loginMember") == null) {
                rdAttr.addFlashAttribute("errorMsg", "로그인 후 이용 가능합니다.");
                return "redirect:/board/list";
            }
            boardDAO.insertBoard(board, req);
            boardDAO.reorderBoardNumbers(req); // 게시물 번호 재정렬
            rdAttr.addFlashAttribute("successMsg", "게시글이 작성되었습니다.");
            return "redirect:/board/list";
        } catch (Exception e) {
            e.printStackTrace();
            rdAttr.addFlashAttribute("errorMsg", "게시글 작성 중 오류가 발생했습니다.");
            return "index";
        }
    }

    // 게시글 상세 보기 (조회 수 증가 포함)
    @RequestMapping(value = "/board/detail", method = RequestMethod.GET)
    public String boardDetail(@RequestParam("bb_no") int bb_no, HttpServletRequest req) {
        // 조회수 증가
        boardDAO.increaseReadCount(bb_no, req);

        // 게시글 상세 정보 가져오기
        boardDAO.getBoardByNo(bb_no, req);

        // 댓글 목록 가져오기
        commentDAO.getAllComments(bb_no, req);

        req.setAttribute("contentPage", "board/detail.jsp");
        return "index";
    }

    // 게시글 수정 페이지 이동
    @RequestMapping(value = "/board/update.go", method = RequestMethod.GET)
    public String goUpdate(@RequestParam("bb_no") int bb_no, HttpServletRequest req, RedirectAttributes rdAttr) {
        Bizone_member loginUser = (Bizone_member) req.getSession().getAttribute("loginMember");
        String userNickname = loginUser.getBm_nickname();
        Bizone_board board = boardDAO.getBoardByNo(bb_no, req);

        if (board == null || !board.getBb_bm_nickname().equals(userNickname)) {
            rdAttr.addFlashAttribute("errorMsg", "수정 권한이 없습니다.");
            return "redirect:/board/list";
        }
        req.setAttribute("board", board);
        req.setAttribute("contentPage", "board/update.jsp");
        return "index";
    }

    // 게시글 수정 처리
    @RequestMapping(value = "/board/update", method = RequestMethod.POST)
    public String updateBoard(Bizone_board board, HttpServletRequest req, RedirectAttributes rdAttr) {
        if (req.getSession().getAttribute("loginMember") == null) {
            rdAttr.addFlashAttribute("errorMsg", "로그인 후 이용 가능합니다.");
            return "redirect:/board/list";
        }
        boardDAO.updateBoard(board, req);
        rdAttr.addFlashAttribute("successMsg", "게시글이 수정되었습니다.");
        return "redirect:/board/list";
    }

    // 게시글 삭제 페이지 이동
    @RequestMapping(value = "/board/delete.go", method = RequestMethod.GET)
    public String goDelete(@RequestParam("bb_no") int bb_no, HttpServletRequest req, RedirectAttributes rdAttr) {
        Bizone_member loginUser = (Bizone_member) req.getSession().getAttribute("loginMember");
        String userNickname = loginUser.getBm_nickname();
        Bizone_board board = boardDAO.getBoardByNo(bb_no, req);

        if (board == null || !board.getBb_bm_nickname().equals(userNickname)) {
            rdAttr.addFlashAttribute("errorMsg", "삭제 권한이 없습니다.");
            return "redirect:/board/list";
        }
        req.setAttribute("board", board);
        req.setAttribute("contentPage", "board/delete.jsp");
        return "index";
    }

    // 게시글 삭제 처리
    @RequestMapping(value = "/board/delete", method = RequestMethod.POST)
    public String deleteBoard(@RequestParam("bb_no") int bb_no, HttpServletRequest req, RedirectAttributes rdAttr) {
        try {
//            String loginUser = (String) req.getSession().getAttribute("loginMember");
            Bizone_member loginUser = (Bizone_member) req.getSession().getAttribute("loginMember");
            String userNickname = loginUser.getBm_nickname();
            Bizone_board board = boardDAO.getBoardByNo(bb_no, req);

//            if (board == null || loginUser == null || !board.getBb_bm_nickname().equals(loginUser)) {
//                rdAttr.addFlashAttribute("errorMsg", "삭제 권한이 없습니다.");
//                return "redirect:/board/list";
//            }
            if (board == null || !board.getBb_bm_nickname().equals(userNickname)) {
                rdAttr.addFlashAttribute("errorMsg", "삭제 권한이 없습니다.");
                return "redirect:/board/list";
            }
            boardDAO.deleteBoard(bb_no, req);
            boardDAO.reorderBoardNumbers(req); // 게시물 번호 재정렬
            rdAttr.addFlashAttribute("successMsg", "게시글이 삭제되었습니다.");
            return "redirect:/board/list";
        } catch (Exception e) {
            e.printStackTrace();
            rdAttr.addFlashAttribute("errorMsg", "게시글 삭제 중 오류가 발생했습니다.");
            return "redirect:/board/list";
        }
    }
}