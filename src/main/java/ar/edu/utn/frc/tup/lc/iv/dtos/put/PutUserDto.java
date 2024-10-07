package ar.edu.utn.frc.tup.lc.iv.dtos.put;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PutUserDto {
    private Integer id;
    private String name;
    private String lastName;
    private String dni;
    private Integer contactId;
    private String email;
    private String avatarUrl;
    private LocalDate birthDate;
    private List<Integer> userRoles;
}
