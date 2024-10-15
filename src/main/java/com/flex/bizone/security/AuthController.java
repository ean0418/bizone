package com.flex.bizone.security;

import com.flex.bizone.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;

@RestController
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/member/login")
    public ResponseEntity<?> createAuthenticationToken(@RequestBody AuthenticationRequest request)
        throws AuthenticationException {
        String jwt = authService.login(request.getUsername(), request.getPassword());
        return ResponseEntity.ok(new AuthenticationResponse(jwt));
    }

    @GetMapping("/api/auth/status")
    @ResponseBody
    public String authStatus() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !Objects.equals(authentication.getName(), "anonymousUser")) {
            return "{\"loggedIn\": true, \"username\": \"" + authentication.getName() + "\"}";
        } else {
            return "{\"loggedIn\": false}";
        }
    }
}
