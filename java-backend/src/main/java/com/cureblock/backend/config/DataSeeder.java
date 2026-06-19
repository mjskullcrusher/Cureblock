package com.cureblock.backend.config;

import com.cureblock.backend.model.User;
import com.cureblock.backend.model.UserRole;
import com.cureblock.backend.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

 private final UserRepository userRepository;
 private final PasswordEncoder passwordEncoder;

 public DataSeeder(UserRepository userRepository, PasswordEncoder passwordEncoder) {
 this.userRepository = userRepository;
 this.passwordEncoder = passwordEncoder;
 }

 @Override
 public void run(String... args) {
 if (userRepository.findByUsername("operator1").isEmpty()) {
 User u = new User();
 u.setUsername("operator1");
 u.setPasswordHash(passwordEncoder.encode("password123"));
 u.setRole(UserRole.operator);
 u.setMustResetPassword(false);
 userRepository.save(u);
 System.out.println(">> Seeded test user: operator1 / password123"); }
 }
}