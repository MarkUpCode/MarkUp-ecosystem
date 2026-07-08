package com.markup.dinerop.admin.cooperative.service;

import com.markup.dinerop.admin.cooperative.dto.response.CooperativeDetailResponse;
import com.markup.dinerop.admin.cooperative.dto.response.CooperativeListItemResponse;
import com.markup.dinerop.admin.cooperative.dto.response.PagedCooperativesResponse;
import com.markup.dinerop.admin.cooperative.mapper.CooperativeAdminMapper;
import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import com.markup.dinerop.admin.cooperative.dto.request.CreateCooperativeRequest;
import com.markup.dinerop.admin.cooperative.exception.CooperativeNotFoundException;
import com.markup.dinerop.admin.cooperative.dto.request.UpdateCooperativeRequest;
import com.markup.dinerop.admin.cooperative.specification.CooperativeSpecification;
import org.springframework.data.jpa.domain.Specification;

@Service
@RequiredArgsConstructor
public class CooperativeAdminService {

    private final CooperativeRepository cooperativeRepository;

    private final CooperativeAdminMapper mapper;

    public PagedCooperativesResponse getCooperatives(

            int page,

            int size,

            String search,

            String city,

            String province

    ) {

        Specification<Cooperative> specification =

                Specification
                        .where(CooperativeSpecification.hasSearch(search))
                        .and(CooperativeSpecification.hasCity(city))
                        .and(CooperativeSpecification.hasProvince(province));

        Page<Cooperative> cooperatives =

                cooperativeRepository.findAll(

                        specification,

                        PageRequest.of(page, size)
                );

        Page<CooperativeListItemResponse> mapped =
                mapper.toPage(cooperatives);

        return new PagedCooperativesResponse(

                mapped.getContent(),

                mapped.getNumber(),

                mapped.getSize(),

                mapped.getTotalElements(),

                mapped.getTotalPages(),

                mapped.isFirst(),

                mapped.isLast()

        );

    }

    public CooperativeDetailResponse getCooperative(
            Long id
    ) {

        Cooperative cooperative =
            cooperativeRepository.findById(id)
                    .orElseThrow(() ->
                            new CooperativeNotFoundException(id)
                    );

        return mapper.toDetail(cooperative);

    }

    public CooperativeDetailResponse createCooperative(
        CreateCooperativeRequest request
    ) {

        Cooperative cooperative = mapper.toEntity(request);

        cooperative = cooperativeRepository.save(cooperative);

        return mapper.toDetail(cooperative);

    }

    public CooperativeDetailResponse updateCooperative(

            Long id,

            UpdateCooperativeRequest request

    ) {

        Cooperative cooperative = cooperativeRepository
                .findById(id)
                .orElseThrow(() -> new CooperativeNotFoundException(id));

        mapper.updateEntity(cooperative, request);

        cooperative = cooperativeRepository.save(cooperative);

        return mapper.toDetail(cooperative);

    }

    public void deleteCooperative(Long id) {

        Cooperative cooperative = cooperativeRepository
                .findById(id)
                .orElseThrow(() -> new CooperativeNotFoundException(id));

        cooperativeRepository.delete(cooperative);

    }

}