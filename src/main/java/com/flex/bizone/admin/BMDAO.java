package com.flex.bizone.admin;

import com.flex.bizone.board.Bizone_board;
import com.flex.bizone.board.BoardMapper;


import com.flex.bizone.member.Bizone_member;
import com.flex.bizone.member.MemberMapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BMDAO {

    @Autowired
    private SqlSession ss;

    // 모든 게시판 조회
    public void getAllBoards(int page, String bb_bm_id, HttpServletRequest req) {
        try {
            int limit = 10;
            int offset = (page -1) * limit;

            Map<String, Object> params = new HashMap<>();
            params.put("offset", offset);
            params.put("limit", limit);
            params.put("bb_bm_id", bb_bm_id);
            List<Bizone_board> boardList = ss.getMapper(BoardMapper.class).getBoardsWithPaging(params);
//            List<Bizone_board> boardList = ss.getMapper(BoardMapper.class)
//                    .getBoardsWithPaging(offset, limit, bb_nickname);

            int totalCount = ss.getMapper(BoardMapper.class).getBoardCount(bb_bm_id);
            int totalPages = (int) Math.ceil((double) totalCount / limit);

            // 로그 추가
            if (boardList == null || boardList.isEmpty()) {
                System.out.println("게시글이 없습니다.");
            } else {
                System.out.println("게시글 목록 크기: " + boardList.size());
            }

            req.setAttribute("boardList", boardList);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("page", page);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글 목록을 불러오는 데 실패했습니다.");
        }
    }
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

}
