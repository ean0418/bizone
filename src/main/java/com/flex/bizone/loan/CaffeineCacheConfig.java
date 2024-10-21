package com.flex.bizone.loan;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
public class CaffeineCacheConfig {

    @Bean
    public CacheManager cacheManager() {
        Caffeine<Object, Object> caffeine = Caffeine.newBuilder()
                .expireAfterWrite(1, TimeUnit.HOURS)  // 캐시 만료 시간: 1시간
                .maximumSize(1000);  // 최대 1000개의 엔트리까지 캐시 가능

        CaffeineCacheManager cacheManager = new CaffeineCacheManager("loanProducts");
        cacheManager.setCaffeine(caffeine);
        return cacheManager;
    }
}