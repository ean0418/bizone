package com.flex.bizone.map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bizone")
public class InterestAreaController {

    @Autowired
    private SqlSession ss;

    // 찜 추가
    @PostMapping("/addFavorite")
    public ResponseEntity<String> addFavorite(@RequestBody InterestAreaData rankData) {
        try {
            ss.getMapper(InterestAreaMapper.class).insertFavorite(rankData);
            return ResponseEntity.ok("찜 목록에 추가되었습니다.");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("찜 목록 추가 중 오류가 발생했습니다.");
        }
    }

    // 찜 목록 조회
    @GetMapping("/getFavoriteList")
    public ResponseEntity<List<InterestAreaData>> getFavoriteList(@RequestParam String bm_id) {
        System.out.println("Received bm_id: " + bm_id);  // 콘솔에 bm_id가 제대로 들어오는지 확인
        try {
            List<InterestAreaData> favoriteList = ss.getMapper(InterestAreaMapper.class).selectFavoritesByMemberId(bm_id);
            if (favoriteList.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT).body(favoriteList);
            }
            return ResponseEntity.ok(favoriteList);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }


    // 찜 삭제
    @DeleteMapping("/removeFavorite")
    public ResponseEntity<String> removeFavorite(@RequestBody Map<String, String> data) {
        String bm_id = data.get("bm_id");
        String ba_code = data.get("ba_code");
        String bb_code = data.get("bb_code");
        try {
            ss.getMapper(InterestAreaMapper.class).deleteFavorite(bm_id, ba_code, bb_code);
            return ResponseEntity.ok("찜 목록에서 삭제되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("찜 목록 삭제 중 오류가 발생했습니다.");
        }
    }
}
