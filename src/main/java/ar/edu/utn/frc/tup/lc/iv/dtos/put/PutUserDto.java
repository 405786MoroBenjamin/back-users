package ar.edu.utn.frc.tup.lc.iv.dtos.put;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PutUserDto {

    @NotNull(message = "El nombre no puede ser nulo")
    @Size(min = 1, max = 50, message = "El nombre debe tener entre 1 y 50 caracteres")
    private String name;

    @NotNull(message = "El apellido no puede ser nulo")
    @Size(min = 1, max = 50, message = "El apellido debe tener entre 1 y 50 caracteres")
    private String lastName;

    @NotNull(message = "El DNI no puede ser nulo")
    @Size(min = 1, max = 11, message = "El DNI debe ser valido")
    private String dni;

    @NotNull(message = "El contacto no puede ser nulo")
    @Size(min = 10, max = 20, message = "El numero de telefono debe tener un formato valido")
    private String phoneNumber;

    @NotNull(message = "El correo electrónico no puede ser nulo")
    @Email(message = "El correo electrónico debe ser válido")
    private String email;

    private String avatar_url;

    @NotNull(message = "La fecha de nacimiento no puede ser nula")
    private LocalDate datebirth;

    @NotNull(message = "Los roles no pueden ser nulos")
    @Size(min = 1, message = "Debe tener al menos un rol")
    private String[] roles ;

    private Integer userUpdateId;

    private Integer telegram_id;
}
