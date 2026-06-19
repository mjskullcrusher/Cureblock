package com.cureblock.backend.controller;

import com.cureblock.backend.model.User;
import com.cureblock.backend.repository.UserRepository;
import com.cureblock.backend.security.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/auth")
public class AuthController {

 private final UserRepository userRepository;
 private final PasswordEncoder passwordEncoder;
 private final JwtUtil jwtUtil;

 public AuthController(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
 this.userRepository = userRepository;
 this.passwordEncoder = passwordEncoder;
 this.jwtUtil = jwtUtil;
 }

    @PostMapping("/login")
 public Map<String, Object> login(@RequestBody Map<String, String> body) {
 String username = body.get("username");
 String password = body.get("password");

 Optional<User> found = userRepository.findByUsername(username);
 if (found.isEmpty() || !passwordEncoder.matches(password, found.get().getPasswordHash())) {
 return Map.of("error", "Invalid credentials");
 }

 User user = found.get();
 String token = jwtUtil.generateToken(user.getUsername(), user.getRole().name());
 return Map.of(
                 "token", token,
                 "role", user.getRole().name(),
                 "mustResetPassword", user.isMustResetPassword()
                 );
 }
}