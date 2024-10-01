package com.flex.bizone.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.List;

@Service
@Repository
public class CommentDAO {

    @Autowired
    private SqlSession ss;

    // 댓글 목록 조회
    public void getAllComments(int bc_bb_no, HttpServletRequest req) {
        try {
            List<Bizone_comment> commentList = ss.getMapper(CommentMapper.class).getCommentsByBoardNo(bc_bb_no);
            if (commentList != null && !commentList.isEmpty()) {
                System.out.println("댓글 수: " + commentList.size());
            } else {
                System.out.println("댓글이 없습니다.");
            }
            req.setAttribute("commentList", commentList);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "댓글 목록을 불러오는 데 실패했습니다.");
        }
    }

    // 댓글 작성
    public void insertComment(Bizone_comment comment, HttpServletRequest req) {
        try {
            ss.getMapper(CommentMapper.class).insertComment(comment);
            req.setAttribute("r", "댓글 작성 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "댓글 작성 실패");
        }
    }

    // 댓글 수정
    public void updateComment(Bizone_comment comment, HttpServletRequest req) {
        try {
            comment.setBc_updatedDate(new Timestamp(System.currentTimeMillis()));
            ss.getMapper(CommentMapper.class).updateComment(comment);
            req.setAttribute("r", "댓글 수정 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "댓글 수정 실패");
        }
    }

    // 댓글 삭제
    public void deleteComment(int bc_no, HttpServletRequest req) {
        try {
            ss.getMapper(CommentMapper.class).deleteComment(bc_no);
            req.setAttribute("r", "댓글 삭제 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "댓글 삭제 실패");
        }
    }
}
