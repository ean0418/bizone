package com.flex.miniProject.member;

import java.util.List;

public interface KakaoMapper {
    public abstract int kakaoInsert(KakaoVO k);
    public abstract List<KakaoVO> findKakao(KakaoVO k);
}
