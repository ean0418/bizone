package com.flex.bizone.board;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface CommentMapper {

    // 게시글 번호로 댓글 조회
    List<Bizone_comment> getCommentsByBoardNo(int bc_bb_no);

    // 댓글 작성
    void insertComment(Bizone_comment comment);

    // 댓글 수정
    int updateComment(Bizone_comment comment);

    // 댓글 삭제
    void deleteComment(int bc_no);

    // 댓글 좋아요 수 증가
    void increaseCommentLikeCount(int bc_no);

    // 댓글 좋아요 수 감소
    void decreaseCommentLikeCount(int bc_no);

//    // 사용자가 댓글에 좋아요 했는지 확인
//    int checkUserLikedComment(@Param("bc_no") int bc_no, @Param("bb_bm_id") String bb_bm_id);
//
//    // 좋아요 상태 추가
//    void likeComment(@Param("bc_no") int bc_no, @Param("bb_bm_id") String bb_bm_id);
//
//    // 좋아요 상태 제거
//    void unlikeComment(@Param("bc_no") int bc_no, @Param("bb_bm_id") String bb_bm_id);

    int checkUserLikedComment(Map<String, Object> params);

    void unlikeComment(Map<String, Object> params);

    void likeComment(Map<String, Object> params);

    int getCommentLikeCount(@Param("bc_no") int bc_no);

    int getBoardNoByCommentNo(@Param("bc_no") int bc_no);
}