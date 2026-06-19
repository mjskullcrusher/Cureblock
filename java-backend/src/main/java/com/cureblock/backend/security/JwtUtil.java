package com.cureblock.backend.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;
import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtUtil {

 // A fixed secret key (fine for development; move to config later)
 private final SecretKey key = Keys.hmacShaKeyFor(
     "cureblock-dev-secret-key-change-this-to-something-long-32bytes!".getBytes());

 private final long EXPIRY_MS = 1000 * 60 * 60 * 8; // 8 hours

 public String generateToken(String username, String role) {
 return Jwts.builder()
         .subject(username)
         .claim("role", role)
         .issuedAt(new Date())
         .expiration(new Date(System.currentTimeMillis() + EXPIRY_MS))
         .signWith(key)
         .compact();
 }

 public String extractUsername(String token) {
     return Jwts.parser().verifyWith(key).build()
             .parseSignedClaims(token).getPayload().getSubject();
}

 public String extractRole(String token) {
     return Jwts.parser().verifyWith(key).build()
             .parseSignedClaims(token).getPayload().get("role", String.class);
 }

 public boolean isValid(String token) {
     try {
         Jwts.parser().verifyWith(key).build().parseSignedClaims(token);
         return true;
     } catch (Exception e) {
         return false;
     }
 }
}