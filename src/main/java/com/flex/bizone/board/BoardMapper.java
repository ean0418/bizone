package com.flex.bizone.board;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {

//    int boardCount();

    // 게시글 목록 조회
    List<Bizone_board> getAllBoards();

    List<Bizone_board> getBoardsWithPaging(Map<String, Object> params);

    // 게시글 번호로 조회
    Bizone_board getBoardByNo(int bb_no);

    // 게시글 작성
    void insertBoard(Bizone_board board);

    // 게시글 수정
    void updateBoard(Bizone_board board);

    // 게시글 삭제
    void deleteBoard(int bb_no);

    // 조회수 증가
    void increaseReadCount(int bb_no);

    int reorderBoardNumbers();

    void initializeRowNum();

    // 최대 게시글 번호 가져오기
    int getMaxPostNum();

    int getBoardCount(String bb_nickname);

    // 상단 고정 게시글 목록 조회
    List<Bizone_board> getPinnedBoards();

    // 좋아요 수 증가
    void increaseBoardLikeCount(int bb_no);

    // 좋아요 수 감소
    void decreaseBoardLikeCount(int bb_no);

//    // 사용자가 게시글에 좋아요 했는지 확인
//    int checkUserLikedBoard(@Param("bb_no") int bb_no, @Param("bb_bm_id") String bb_bm_id);
//
//    // 좋아요 상태 추가
//    void likeBoard(@Param("bb_no") int bb_no, @Param("bb_bm_id") String bb_bm_id);
//
//    // 좋아요 상태 제거
//    void unlikeBoard(@Param("bb_no") int bb_no, @Param("bb_bm_id") String bb_bm_id);

    // 사용자가 게시글에 좋아요 했는지 확인
    int checkUserLikedBoard(Map<String, Object> params);

    // 좋아요 상태 추가
    void likeBoard(Map<String, Object> params);

    // 좋아요 상태 제거
    void unlikeBoard(Map<String, Object> params);

    int getBoardLikeCount(@Param("bb_no") int bb_no);
}