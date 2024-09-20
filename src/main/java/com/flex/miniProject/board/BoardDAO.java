package com.flex.miniProject.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
@Repository
public class BoardDAO {

    @Autowired
    private SqlSession ss;

    public void getAllBoards(HttpServletRequest req) {
        try {
            List<Bizone_board> boardList = ss.getMapper(BoardMapper.class).getAllBoards();

            // 로그 추가
            if (boardList == null || boardList.isEmpty()) {
                System.out.println("게시글이 없습니다.");
            } else {
                System.out.println("게시글 목록 크기: " + boardList.size());
            }

            req.setAttribute("boardList", boardList);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 목록을 불러오는 데 실패했습니다.");
        }
    }

    public void insertBoard(Bizone_board board, HttpServletRequest req) {
        try {
            // 게시글 최대 번호 가져오기
            int maxPostNum = ss.getMapper(BoardMapper.class).getMaxPostNum();

            // 게시글 번호 설정 (최대 번호 + 1)
            board.setBb_postNum(maxPostNum + 1);

            // 게시글 저장
            ss.getMapper(BoardMapper.class).insertBoard(board);

            // 게시글 작성 후 번호 재정렬
            ss.getMapper(BoardMapper.class).initializeRowNum();
            ss.getMapper(BoardMapper.class).reorderBoardNumbers();
            req.setAttribute("r", "게시글 작성 성공 및 번호 재정렬");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 작성 실패");
        }
    }

    // 게시글 조회
    public void getBoardByNo(int bb_no, HttpServletRequest req) {
        try {
            Bizone_board board = ss.getMapper(BoardMapper.class).getBoardByNo(bb_no);
            req.setAttribute("board", board);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글을 불러오는 데 실패했습니다.");
        }
    }

    // 게시글 수정
    public void updateBoard(Bizone_board board, HttpServletRequest req) {
        try {
            ss.getMapper(BoardMapper.class).updateBoard(board);
            req.setAttribute("r", "게시글 수정 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 수정 실패");
        }
    }

    // 게시글 삭제
    public void deleteBoard(int bb_no, HttpServletRequest req) {
        try {
            ss.getMapper(BoardMapper.class).deleteBoard(bb_no);
            ss.getMapper(BoardMapper.class).initializeRowNum();
            ss.getMapper(BoardMapper.class).reorderBoardNumbers();
            req.setAttribute("r", "게시글 삭제 성공 및 번호 재정렬");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 삭제 실패");
        }
    }

    public void increaseReadCount(int bb_no, HttpServletRequest req) {
        try {
            ss.getMapper(BoardMapper.class).increaseReadCount(bb_no);
            req.setAttribute("r", "조회수 증가 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "조회수 증가 실패");
        }
    }

    // 게시글 번호 재정렬
    public void reorderBoardNumbers(HttpServletRequest req) {
        try {
            ss.getMapper(BoardMapper.class).initializeRowNum();   // rownum 초기화
            ss.getMapper(BoardMapper.class).reorderBoardNumbers();  // 게시글 번호 재정렬
            req.setAttribute("r", "게시글 번호 재정렬 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 번호 재정렬 실패");
        }
    }

}