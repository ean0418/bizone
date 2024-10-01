package com.flex.bizone.board;

import com.flex.bizone.member.Bizone_member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping
public class CommentController {

    @Autowired
    private com.flex.bizone.board.CommentDAO commentDAO;

    // 댓글 작성 처리 메서드
    @RequestMapping(value = "/comment/insert", method = RequestMethod.POST)
    public String insertComment(Bizone_comment comment, HttpServletRequest req, RedirectAttributes rdAttr) {
        try {
            // 로그인 상태 확인
            Bizone_member loginMember = (Bizone_member) req.getSession().getAttribute("loginMember");
            if (loginMember == null) {
                rdAttr.addFlashAttribute("errorMsg", "로그인 후 이용 가능합니다.");
                return "redirect:/board/detail?bb_no=" + comment.getBc_bb_no();
            }

            // 로그인 상태일 경우 댓글 작성 처리
            comment.setBc_bm_nickname(loginMember.getBm_nickname()); // 로그인된 사용자의 닉네임 설정
            commentDAO.insertComment(comment, req);
            return "redirect:/board/detail?bb_no=" + comment.getBc_bb_no();
        } catch (Exception e) {
            e.printStackTrace();
            rdAttr.addFlashAttribute("errorMsg", "댓글 작성 중 오류가 발생했습니다.");
            return "redirect:/board/detail?bb_no=" + comment.getBc_bb_no();
        }
    }

    // 댓글 수정 모드로 전환
    @RequestMapping(value = "/comment/edit", method = RequestMethod.GET)
    public String editComment(@RequestParam("bc_no") int bc_no, @RequestParam("bb_no") int bb_no, HttpServletRequest req) {
        req.getSession().setAttribute("editCommentId", bc_no);
        return "redirect:/board/detail?bb_no=" + bb_no;
    }

    // 댓글 수정 처리
    @RequestMapping(value = "/comment/update", method = RequestMethod.POST)
    public String updateComment(com.flex.bizone.board.Bizone_comment comment, HttpServletRequest req, RedirectAttributes rdAttr) {
        try {
            if (req.getSession().getAttribute("loginMember") == null) {
                rdAttr.addFlashAttribute("errorMsg", "로그인 후 이용 가능합니다.");
                return "redirect:/board/detail?bb_no=" + comment.getBc_bb_no();
            }
            // 댓글 수정 처리 (DAO 호출)
            commentDAO.updateComment(comment, req);
            // 수정 후 세션에 저장된 댓글 ID 초기화
            req.getSession().removeAttribute("editCommentId");
            return "redirect:/board/detail?bb_no=" + comment.getBc_bb_no();
        } catch (Exception e) {
            e.printStackTrace();
            rdAttr.addFlashAttribute("errorMsg", "댓글 수정 중 오류가 발생했습니다.");
            return "redirect:/board/detail?bb_no=" + comment.getBc_bb_no();
        }
    }


    // 댓글 삭제 처리
    @RequestMapping(value = "/comment/delete", method = RequestMethod.POST)
    public String deleteComment(@RequestParam("bc_no") int bc_no, @RequestParam("bc_bb_no") int bc_bb_no, HttpServletRequest req, RedirectAttributes rdAttr) {
        try {
            commentDAO.deleteComment(bc_no, req);
            return "redirect:/board/detail?bb_no=" + bc_bb_no;
        } catch (Exception e) {
            e.printStackTrace();
            rdAttr.addFlashAttribute("errorMsg", "댓글 삭제 중 오류가 발생했습니다.");
            return "redirect:/board/detail?bb_no=" + bc_bb_no;
        }
    }
}


