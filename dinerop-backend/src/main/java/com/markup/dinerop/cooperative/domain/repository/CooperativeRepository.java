package com.markup.dinerop.cooperative.domain.repository;

import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.util.List;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import jakarta.persistence.LockModeType;
import java.util.Optional;


@Repository
public interface CooperativeRepository extends
        JpaRepository<Cooperative, Long>,
        JpaSpecificationExecutor<Cooperative> {

    List<Cooperative> findByCiudadIgnoreCase(String ciudad);

    List<Cooperative> findByCiudadIgnoreCaseAndProvinciaIgnoreCase(String ciudad, String provincia);

    List<Cooperative> findByProvinciaIgnoreCase(String provincia);

    List<Cooperative> findByCiudadIgnoreCaseAndMontoMaximoCreditoGreaterThanEqual(
            String ciudad,
            BigDecimal montoMaximo
    );

    List<Cooperative> findByProvinciaIgnoreCaseAndMontoMaximoCreditoGreaterThanEqual(
            String provincia,
            BigDecimal montoMaximo
    );

    List<Cooperative> findByCiudadIgnoreCaseAndProvinciaIgnoreCaseAndMontoMaximoCreditoGreaterThanEqual(
            String ciudad,
            String provincia,
            BigDecimal montoMaximo
    );

    List<Cooperative> findTop10ByOrderByIdDesc();

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select c from Cooperative c where c.id = :id")
    Optional<Cooperative> lockById(@Param("id") Long id);
}
