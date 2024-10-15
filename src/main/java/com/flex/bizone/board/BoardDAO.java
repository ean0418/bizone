package com.flex.bizone.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Repository
public class BoardDAO {

    @Autowired
    private SqlSession ss;

    public void getAllBoards(int page, String bb_bm_id, HttpServletRequest req) {
        try {
            int limit = 10;
            int offset = (page -1) * limit;

            Map<String, Object> params = new HashMap<>();
            params.put("offset", offset);
            params.put("limit", limit);
            params.put("bb_bm_id", bb_bm_id);
            List<Bizone_board> boardList = ss.getMapper(BoardMapper.class).getBoardsWithPaging(params);

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
    public Bizone_board getBoardByNo(int bb_no, HttpServletRequest req) {
        try {
            Bizone_board board = ss.getMapper(BoardMapper.class).getBoardByNo(bb_no);
            req.setAttribute("board", board);
            req.setAttribute("r", "게시글 조회 성공");
            return board;
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "게시글을 불러오는 데 실패했습니다.");
            return null;
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

    // 좋아요 토글
    public void toggleLike(int bb_no, String bb_bm_id, HttpServletRequest req) {
        try {
            BoardMapper mapper = ss.getMapper(BoardMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("bb_no", bb_no);
            params.put("bb_bm_id", bb_bm_id);

            // 사용자가 이미 좋아요를 눌렀는지 확인
            int likeCheck = mapper.checkUserLikedBoard(params);

            System.out.println("likeCheck :" + likeCheck);

            if (likeCheck > 0) {
                // 이미 좋아요를 눌렀다면 좋아요 취소
                mapper.unlikeBoard(params);  // 좋아요 취소
                mapper.decreaseBoardLikeCount(bb_no);  // 좋아요 수 감소
            } else {
                // 좋아요 추가
                mapper.likeBoard(params);  // 좋아요 추가
                mapper.increaseBoardLikeCount(bb_no);  // 좋아요 수 증가
            }

            // 갱신된 좋아요 수 조회
            int updatedLikeCount = mapper.getBoardLikeCount(bb_no);
            req.setAttribute("updatedLikeCount", updatedLikeCount);
            System.out.println("updatedLikeCount : " + updatedLikeCount);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "게시글 좋아요 처리 중 오류가 발생했습니다.");
        }
    }

    public Boolean isUserLikedBoard(int bb_no, String bb_bm_id) {
        Map<String, Object> inputMap = new HashMap<>();
        inputMap.put("bb_no", bb_no);
        inputMap.put("bb_bm_id", bb_bm_id);
        return ss.getMapper(BoardMapper.class).checkUserLikedBoard(inputMap) != 0;
    }

    // 게시글 좋아요 수 가져오기
    public int getBoardLikeCount(int bb_no) {
        return ss.getMapper(BoardMapper.class).getBoardLikeCount(bb_no);
    }

    // 게시글 좋아요 체크 메소드 추가
    public int checkUserLikedBoard(int bb_no, String bb_bm_id, HttpServletRequest req) {
        Map<String, Object> params = new HashMap<>();
        System.out.println("checkUserLikedBoard");
        System.out.println(bb_no);
        System.out.println(bb_bm_id);
        params.put("bb_no", bb_no);
        params.put("bb_bm_id", bb_bm_id);

        int result = ss.getMapper(BoardMapper.class).checkUserLikedBoard(params);
        System.out.println(result);

        return result;
    }
}