package com.flex.bizone.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.security.Principal;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Repository
public class CommentDAO {

    @Autowired
    private SqlSession ss;

    // 댓글 목록 조회
    public void getAllComments(int bc_bb_no, HttpServletRequest req, String bm_id) {
        try {
            Map<String, Object> inputMap = new HashMap<>();
            inputMap.put("bc_bb_no", bc_bb_no);
            inputMap.put("bm_id", bm_id);
            List<CommentList> commentList = ss.getMapper(CommentMapper.class).getCommentsByBoardNo(inputMap);
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

    // 댓글 좋아요 토글
    public void toggleLike(int bc_no, String bb_bm_id, HttpServletRequest req) {
        try {
            CommentMapper mapper = ss.getMapper(CommentMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("bc_no", bc_no);
            params.put("bb_bm_id", bb_bm_id);

            int bb_no = mapper.getBoardNoByCommentNo(bc_no);
            params.put("bb_no", bb_no);  // 댓글이 속한 게시글 번호

            int likeCheck = mapper.checkUserLikedComment(params);

            if (likeCheck > 0) {
                mapper.unlikeComment(params);
                mapper.decreaseCommentLikeCount(bc_no);
            } else {
                mapper.likeComment(params);
                mapper.increaseCommentLikeCount(bc_no);
            }

            int updatedLikeCount = mapper.getCommentLikeCount(bc_no);
            req.setAttribute("updatedLikeCount", updatedLikeCount);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "댓글 좋아요 처리 중 오류가 발생했습니다.");
        }
    }

    // 댓글 좋아요 체크 메소드 추가
    public int checkUserLikedComment(int bc_no, String bb_bm_id, HttpServletRequest req) {
        Map<String, Object> params = new HashMap<>();
        params.put("bc_no", bc_no);
        params.put("bb_bm_id", bb_bm_id);

        return ss.getMapper(CommentMapper.class).checkUserLikedComment(params);
    }

    // 댓글 좋아요 수 가져오기
    public int getCommentLikeCount(int bc_no) {
        return ss.getMapper(CommentMapper.class).getCommentLikeCount(bc_no);
    }
}