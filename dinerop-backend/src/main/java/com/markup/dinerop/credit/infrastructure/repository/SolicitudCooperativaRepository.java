package com.markup.dinerop.credit.infrastructure.repository;

import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.dto.CooperativeCreditRequestItemDto;
import org.springframework.data.repository.query.Param;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;



import java.util.List;
import java.util.Optional;

public interface SolicitudCooperativaRepository extends JpaRepository<SolicitudCooperativa, Long> {

    boolean existsBySolicitudIdAndCooperativaId(Long solicitudId, Long cooperativaId);

    @Query("""
    SELECT sc
    FROM SolicitudCooperativa sc
    JOIN FETCH sc.creditRequest cr
    WHERE cr.clientId = :clientId
""")
    List<SolicitudCooperativa> findAllByClientId(@Param("clientId") Long clientId);



        @Query("""
        select new com.markup.dinerop.credit.dto.CooperativeCreditRequestItemDto(
            sc.solicitudId,
            coalesce(cr.clientId, account.idUser),
            cr.email,
            cr.amount,
            cr.tipo,
            cr.fechaSolicitud,
            sc.estado,
            coalesce(
                concat(persona.nombres, ' ', persona.apellidos),
                concat(pre.firstName, ' ', pre.lastName)
            ),
            coalesce(persona.cedula, pre.identification)
        )
        from SolicitudCooperativa sc
        join sc.creditRequest cr
        left join com.markup.dinerop.auth.entity.User account
            on lower(account.email) = lower(cr.email)
        left join com.markup.dinerop.auth.entity.UserPreRegistration pre
            on pre.userId = coalesce(cr.clientId, account.idUser)
        left join com.markup.dinerop.onboarding.domain.entity.SolicitudOnboarding onboarding
            on onboarding.usuarioId = coalesce(cr.clientId, account.idUser)
        left join com.markup.dinerop.onboarding.domain.entity.PersonaOnboarding persona
            on persona.solicitud = onboarding
            and persona.rol = com.markup.dinerop.onboarding.domain.enums.RolPersona.SOLICITANTE
        where sc.cooperativaId = :cooperativaId
        order by cr.fechaSolicitud desc
    """)

    List<CooperativeCreditRequestItemDto> findRequestsByCooperativaId(@Param("cooperativaId") Long cooperativaId);

    Optional<SolicitudCooperativa> findBySolicitudIdAndCooperativaId(Long solicitudId, Long cooperativaId);

    //----------------------------------------------------------------------------------------------------------------
    //Metodo para obtener detalle de solicitud en diversas cooperativas
    //----------------------------------------------------------------------------------------------------------------

    @Query("""
    SELECT sc
    FROM SolicitudCooperativa sc
    JOIN FETCH sc.creditRequest cr
    WHERE cr.clientId = :clientId
      AND cr.id = :solicitudId
      AND sc.estado IN :estados
    ORDER BY sc.fechaActualizacion DESC NULLS LAST
""")
    List<SolicitudCooperativa> findByClientIdAndSolicitudIdAndEstado(
            @Param("clientId") Long clientId,
            @Param("solicitudId") Long solicitudId,
            @Param("estados") List<SolicitudCooperativaStatus> estados
    );



    //----------------------------------------------------------------------------------------------------------------
    //Metodo para aceptar una solicitud pre-aprobada con validacion incluida para no aceptar mas de una solicitud
    //----------------------------------------------------------------------------------------------------------------

    boolean existsBySolicitudIdAndEstado(Long solicitudId, SolicitudCooperativaStatus estado);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
    SELECT sc
    FROM SolicitudCooperativa sc
    JOIN FETCH sc.creditRequest cr
    WHERE cr.clientId = :clientId
      AND cr.id = :solicitudId
      AND sc.cooperativaId = :cooperativaId
""")
    Optional<SolicitudCooperativa> findForClientAcceptance(
            @Param("clientId") Long clientId,
            @Param("solicitudId") Long solicitudId,
            @Param("cooperativaId") Long cooperativaId
    );






}

