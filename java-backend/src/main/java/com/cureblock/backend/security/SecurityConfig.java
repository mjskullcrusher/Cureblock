package com.cureblock.backend.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

 @Bean
 public PasswordEncoder passwordEncoder() {
 return new BCryptPasswordEncoder();
 }

 @Bean
 public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
 http
 .cors(cors -> {})// enable CORS using the bean below
 .csrf(csrf -> csrf.disable())
 .authorizeHttpRequests(auth -> auth
           .requestMatchers("/auth/**", "/health", "/api/**").permitAll()
 .anyRequest().authenticated()
 );
 return http.build();
 }
 @Bean
 public org.springframework.web.cors.CorsConfigurationSource corsConfigurationSource() {
 org.springframework.web.cors.CorsConfiguration config = new org.springframework.web.cors.CorsConfiguration();
 config.setAllowedOrigins(java.util.List.of("*"));
 config.setAllowedMethods(java.util.List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
 config.setAllowedHeaders(java.util.List.of("*"));
 org.springframework.web.cors.UrlBasedCorsConfigurationSource source =
 new org.springframework.web.cors.UrlBasedCorsConfigurationSource();
 source.registerCorsConfiguration("/**", config);
 return source;
 }
}