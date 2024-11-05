//package ar.edu.utn.frc.tup.lc.iv.security.lucho;
//
//import ar.edu.utn.frc.tup.lc.iv.entities.UserEntity;
//import ar.edu.utn.frc.tup.lc.iv.repositories.UserRepository;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.stereotype.Service;
//
//@Service
//public class CustomUserDetailsService implements UserDetailsService {
//
//    // Aquí deberías inyectar tu repositorio de usuarios (UserRepository)
//    private final UserRepository userRepository;
//
//    public CustomUserDetailsService(UserRepository userRepository) {
//        this.userRepository = userRepository;
//    }
//
//    @Override
//    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        // Buscar usuario en la base de datos
//        UserEntity user = userRepository.findByUsername(username);
//
//        if(user == null) {
//            throw new UsernameNotFoundException("User not found");
//        }
//
//        // Devolver UserDetails, que Spring Security entiende
//        return new CustomUserDetails(user);
//    }
//}