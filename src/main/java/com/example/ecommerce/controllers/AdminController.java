package com.example.ecommerce.controllers;
import com.example.ecommerce.services.AdminService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;

import java.util.Map;

@RestController
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }
    @PostMapping("/login")
    public ResponseEntity<Map<String, Boolean>> login(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        String password = request.get("password");
        boolean success = adminService.login(username, password);
        Map<String, Boolean> response = Collections.singletonMap("success", success);
        if (success) {
            return ResponseEntity.ok(response); // Login successful
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response); // Login failed
        }
    }
    @GetMapping("/addCategory")
    public String showAddCategoryPage() {
        return "addCategory.jsp"; // Return the name of the HTML template
    }

    @GetMapping("/addSubCategory")
    public String showAddSubCategoryPage() {
        return "addSubCategory.jsp";
    }

    @GetMapping("/addProduct")
    public String showManageProductsPage() {
        return "addProduct.jsp";
    }

    @GetMapping("/addSubProduct")
    public String showManageSubProductsPage() {
        return "addSubProduct.jsp";
    }

    @GetMapping("/customerProfiles")
    public String showCustomerProfilesPage() {
        return "customerProfiles.jsp";
    }

    @GetMapping("/logout")
    public String logout() {
        return "adminLogin.jsp";
    }
}