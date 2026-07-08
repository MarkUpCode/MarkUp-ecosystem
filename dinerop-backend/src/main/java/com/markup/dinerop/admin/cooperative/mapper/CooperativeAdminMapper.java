package com.markup.dinerop.admin.cooperative.mapper;

import com.markup.dinerop.admin.cooperative.dto.response.CooperativeDetailResponse;
import com.markup.dinerop.admin.cooperative.dto.response.CooperativeListItemResponse;
import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Component;
import com.markup.dinerop.admin.cooperative.dto.request.CreateCooperativeRequest;
import com.markup.dinerop.admin.cooperative.dto.request.UpdateCooperativeRequest;


@Component
public class CooperativeAdminMapper {

    public CooperativeListItemResponse toListItem(Cooperative cooperative) {

        return new CooperativeListItemResponse(

                cooperative.getId(),

                cooperative.getNombre(),

                cooperative.getCiudad(),

                cooperative.getProvincia(),

                cooperative.getTelefono(),

                cooperative.getCalificacion(),

                cooperative.getMontoMaximoCredito()

        );

    }

    public CooperativeDetailResponse toDetail(Cooperative cooperative) {

        return new CooperativeDetailResponse(

                cooperative.getId(),

                cooperative.getLegacyId(),

                cooperative.getNombre(),

                cooperative.getCiudad(),

                cooperative.getProvincia(),

                cooperative.getDireccion(),

                cooperative.getTelefono(),

                cooperative.getPaginaWeb(),

                cooperative.getLogoUrl(),

                cooperative.getCalificacion(),

                cooperative.getMontoMaximoCredito()

        );

    }

    public Cooperative toEntity(CreateCooperativeRequest request) {

        Cooperative cooperative = new Cooperative();

        cooperative.setNombre(request.nombre());

        cooperative.setCiudad(request.ciudad());

        cooperative.setProvincia(request.provincia());

        cooperative.setDireccion(request.direccion());

        cooperative.setTelefono(request.telefono());

        cooperative.setPaginaWeb(request.paginaWeb());

        cooperative.setLogoUrl(request.logoUrl());

        cooperative.setCalificacion(request.calificacion());

        cooperative.setMontoMaximoCredito(
                request.montoMaximoCredito()
        );

        return cooperative;

    }

    public void updateEntity(

            Cooperative cooperative,

            UpdateCooperativeRequest request

    ) {

        cooperative.setNombre(request.nombre());

        cooperative.setCiudad(request.ciudad());

        cooperative.setProvincia(request.provincia());

        cooperative.setDireccion(request.direccion());

        cooperative.setTelefono(request.telefono());

        cooperative.setPaginaWeb(request.paginaWeb());

        cooperative.setLogoUrl(request.logoUrl());

        cooperative.setCalificacion(request.calificacion());

        cooperative.setMontoMaximoCredito(
                request.montoMaximoCredito()
        );

    }

    public Page<CooperativeListItemResponse> toPage(
            Page<Cooperative> cooperatives
    ) {

        return cooperatives.map(this::toListItem);

    }

}