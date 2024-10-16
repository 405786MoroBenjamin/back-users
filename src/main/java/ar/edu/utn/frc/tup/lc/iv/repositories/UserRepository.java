package ar.edu.utn.frc.tup.lc.iv.repositories;

import ar.edu.utn.frc.tup.lc.iv.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
    UserEntity findByUsername(String username);
    //UserEntity findByEmail(String email);
    Optional<UserEntity> findById(Integer integer);
    Optional<List<UserEntity>> findByActive(boolean isActive);

    UserEntity findByDni(String dni);
    //Optional<UserEntity> getUserByEmail(String email);

    @Query("SELECT u FROM UserEntity u " +
            "JOIN UserRoleEntity ur ON ur.user.id = u.id " +
            "JOIN RoleEntity r ON ur.role.id = r.id " +
            "JOIN PlotUserEntity pu ON pu.user.id = u.id " +
            "WHERE r.description = 'Owner' " +
            "AND pu.plotId = :plotId " +
            "AND u.active = true")
    Optional<UserEntity> findUsersByPlotIdAndOwnerRole(@Param("plotId") Integer plotId);
}
