package com.flex.bizone.board;

import com.flex.bizone.member.Bizone_member;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.net.Authenticator;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

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
        return "redirect:/board/list";
    }

    // 게시글 목록 조회
    @RequestMapping(value = "/board/list", method = RequestMethod.GET)
    public String boardList(@RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "") String bb_bm_id,
                            HttpServletRequest req, Model model) {
        boardDAO.getAllBoards(page, bb_bm_id, req); // 게시글 목록을 요청
        model.addAttribute("boardList", req.getAttribute("boardList")); // boardList를 JSP로 전달
        model.addAttribute("page", req.getAttribute("page"));
        model.addAttribute("totalPages", req.getAttribute("totalPages"));
        model.addAttribute("bb_bm_id", bb_bm_id); // 검색 필터값 유지
        model.addAttribute("contentPage", "board/list.jsp");
        return "index";
    }

    // 게시글 작성 페이지 이동
    @RequestMapping(value = "/board/insert.go", method = RequestMethod.GET)
    public String goInsert(HttpServletRequest req, RedirectAttributes rdAttr) {
        req.setAttribute("contentPage", "board/insert.jsp");
        return "index";
    }

    // 게시글 작성 처리
    @RequestMapping(value = "/board/insert", method = RequestMethod.POST)
    public String insertBoard(Bizone_board board, HttpServletRequest req, RedirectAttributes rdAttr) {
        try {
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
    public String boardDetail(@RequestParam("bb_no") int bb_no, HttpServletRequest req, Principal principal, Authentication auth) {
        boardDAO.increaseReadCount(bb_no, req);
        boardDAO.getBoardByNo(bb_no, req);
        String bb_bm_id = "";
        if (auth != null) {
            bb_bm_id = principal.getName();
        }
        req.setAttribute("isUserLikedBoard", boardDAO.isUserLikedBoard(bb_no, bb_bm_id));
        commentDAO.getAllComments(bb_no, req, bb_bm_id);
        req.setAttribute("contentPage", "board/detail.jsp");
        return "index";
    }

    // 게시글 수정 페이지 이동
    @RequestMapping(value = "/board/update.go", method = RequestMethod.GET)
    public String goUpdate(@RequestParam("bb_no") int bb_no, HttpServletRequest req, RedirectAttributes rdAttr, Principal principal) {
        String userId = principal.getName();;
        Bizone_board board = boardDAO.getBoardByNo(bb_no, req);

        if (board == null || !board.getBb_bm_id().equals(userId)) {
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
        boardDAO.updateBoard(board, req);
        rdAttr.addFlashAttribute("successMsg", "게시글이 수정되었습니다.");
        return "redirect:/board/list";
    }

    // 게시글 삭제 페이지 이동
    @RequestMapping(value = "/board/delete.go", method = RequestMethod.GET)
    public String goDelete(@RequestParam("bb_no") int bb_no, HttpServletRequest req, RedirectAttributes rdAttr, Principal principal) {
        String userId = principal.getName();
        Bizone_board board = boardDAO.getBoardByNo(bb_no, req);

        if (board == null || !board.getBb_bm_id().equals(userId)) {
            rdAttr.addFlashAttribute("errorMsg", "삭제 권한이 없습니다.");
            return "redirect:/board/list";
        }
        req.setAttribute("board", board);
        req.setAttribute("contentPage", "board/delete.jsp");
        return "index";
    }

    // 게시글 삭제 처리
    @RequestMapping(value = "/board/delete", method = RequestMethod.POST)
    public String deleteBoard(@RequestParam("bb_no") int bb_no, HttpServletRequest req, RedirectAttributes rdAttr, Principal principal) {
        try {
            String userId = principal.getName();
            Bizone_board board = boardDAO.getBoardByNo(bb_no, req);

            if (board == null || !board.getBb_bm_id().equals(userId)) {
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

    // 게시글 좋아요 토글
    @RequestMapping(value = "/board/toggleLike", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> toggleLike(@RequestParam("bb_no") int bb_no, Principal principal, HttpServletRequest req) {
        Map<String, Object> response = new HashMap<>();

        String bm_id = principal.getName();  // 변경된 부분
        System.out.println(bm_id);
        boardDAO.toggleLike(bb_no, bm_id, req);

        int updatedLikeCount = (int) req.getAttribute("updatedLikeCount");
        response.put("success", true);
        response.put("isLiked", boardDAO.checkUserLikedBoard(bb_no, bm_id, req) > 0);
        System.out.println(response.get("isLiked"));
        response.put("likeCount", updatedLikeCount);

        return response;
    }
}