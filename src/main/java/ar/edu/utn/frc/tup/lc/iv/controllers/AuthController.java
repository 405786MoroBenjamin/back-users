package ar.edu.utn.frc.tup.lc.iv.controllers;

import ar.edu.utn.frc.tup.lc.iv.dtos.get.GetUserDto;
import ar.edu.utn.frc.tup.lc.iv.dtos.post.ChangePassword;
import ar.edu.utn.frc.tup.lc.iv.dtos.post.PostLoginDto;
import ar.edu.utn.frc.tup.lc.iv.security.jwt.JwtUtil;
import ar.edu.utn.frc.tup.lc.iv.services.Interfaces.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Controlador REST para manejar operaciones de Autenticación.
 * Expone Endpoints para gestionar un inicio de sesión utilizando JWT.
 */
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    /** Servicio para manejar la lógica de usuarios. */
    private final UserService userService;


    /**
     * Devuelve la confirmación de un inicio de sesión exitoso.
     *
     * @param credentials credenciales del logueo.
     * @throws IllegalArgumentException excepción credenciales inválidas.
     * @return respuesta de confirmación de logueo.
     */
    @PostMapping("/login")
    public Map<String, String> login(@RequestBody PostLoginDto credentials) {
        GetUserDto user = userService.verifyLogin(credentials);

        if (user != null) {
            // Crear el mapa de claims con todos los campos de GetUserDto
            Map<String, Object> claims = new HashMap<>();
            claims.put("id", user.getId());
            claims.put("name", user.getName());
            claims.put("lastname", user.getLastname());
            claims.put("username", user.getUsername());
            claims.put("email", user.getEmail());
            claims.put("phone_number", user.getPhone_number());
            claims.put("dni", user.getDni());
            claims.put("active", user.getActive());
            claims.put("avatar_url", user.getAvatar_url());
            claims.put("datebirth", user.getDatebirth().toString());  // Convertir LocalDate a String
            claims.put("roles", user.getRoles());
            claims.put("plot_id", user.getPlot_id());
            claims.put("telegram_id", user.getTelegram_id());

            String token = "";
            // Generar el token
            if (user.getEmail() == null) {
                token = JwtUtil.generateToken(user.getUsername(), claims);
            }
            else {
                token = JwtUtil.generateToken(user.getEmail(), claims);
            }

            // Devolver el token
            Map<String, String> response = new HashMap<>();
            response.put("token", token);
            return response;
        } else {
            throw new IllegalArgumentException("Invalid credentials");
        }
    }

    /**
     * Valida un token JWT.
     *
     * @param token token a validar.
     * @return responde indicando si el token es válido o no.
     */
    @PostMapping("/validateToken")
    public Map<String, String> validateToken(@RequestBody String token) {
        Map<String, String> response = new HashMap<>();
        try {
            //JwtUtil.validateToken(token);
            response.put("message", "Valid token");
        } catch (IllegalArgumentException e) {
            response.put("message", "Invalid token");
            System.out.println(e.getMessage());
        }
        return response;
    }

    /**
     * Endpoint para cambiar la contraseña de un usuario.
     * @param changePasswordDto DTO con las contraseñas actual y nueva.
     * @return respuesta de confirmación de cambio de contraseña.
     */
    @PutMapping("/changePassword")
    public Map<String, String> changePassword(@RequestBody ChangePassword changePasswordDto) {
        userService.changePassword(changePasswordDto);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Contraseña actualizada exitosamente");
        return response;
    }

}

