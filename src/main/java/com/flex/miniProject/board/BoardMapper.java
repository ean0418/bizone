package com.flex.miniProject.board;

import org.apache.ibatis.annotations.Mapper;

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
}
