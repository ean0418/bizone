package com.flex.bizone.board;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CommentMapper {

    // 게시글 번호로 댓글 조회
    List<com.flex.bizone.board.Bizone_comment> getCommentsByBoardNo(int bc_bb_no);

    // 댓글 작성
    void insertComment(com.flex.bizone.board.Bizone_comment comment);

    // 댓글 수정
    void updateComment(com.flex.bizone.board.Bizone_comment comment);

    // 댓글 삭제
    void deleteComment(int bc_no);

}
