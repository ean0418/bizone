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

    // 게시글 목록 불러오기
    public void getAllBoards(HttpServletRequest req) {
        try {
            List<Bizone_board> boardList = ss.getMapper(BoardMapper.class).getAllBoards();
            req.setAttribute("boardList", boardList);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 목록을 불러오는 데 실패했습니다.");
        }
    }

    // 게시글 작성
    public void insertBoard(Bizone_board board, HttpServletRequest req) {
        try {
            ss.getMapper(BoardMapper.class).insertBoard(board);
            req.setAttribute("r", "게시글 작성 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 작성 실패");
        }
    }

    // 게시글 조회
    public void getBoardById(int bn_no, HttpServletRequest req) {
        try {
            Bizone_board board = ss.getMapper(BoardMapper.class).getBoardByNo(bn_no);
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
    public void deleteBoard(int bn_no, HttpServletRequest req) {
        try {
            ss.getMapper(BoardMapper.class).deleteBoard(bn_no);
            req.setAttribute("r", "게시글 삭제 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 삭제 실패");
        }
    }
}