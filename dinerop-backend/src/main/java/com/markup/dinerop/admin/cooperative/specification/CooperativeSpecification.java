package com.markup.dinerop.admin.cooperative.specification;

import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import org.springframework.data.jpa.domain.Specification;

public class CooperativeSpecification {

    private CooperativeSpecification() {
    }

    public static Specification<Cooperative> hasSearch(String search) {

        return (root, query, cb) -> {

            if (search == null || search.isBlank()) {
                return cb.conjunction();
            }

            String value = "%" + search.toLowerCase() + "%";

            return cb.or(

                    cb.like(
                            cb.lower(root.get("nombre")),
                            value
                    ),

                    cb.like(
                            cb.lower(root.get("ciudad")),
                            value
                    ),

                    cb.like(
                            cb.lower(root.get("provincia")),
                            value
                    )

            );

        };

    }

    public static Specification<Cooperative> hasCity(String city) {

        return (root, query, cb) -> {

            if (city == null || city.isBlank()) {
                return cb.conjunction();
            }

            return cb.equal(

                    cb.lower(root.get("ciudad")),

                    city.toLowerCase()

            );

        };

    }


    public static Specification<Cooperative> hasProvince(String province) {

        return (root, query, cb) -> {

            if (province == null || province.isBlank()) {
                return cb.conjunction();
            }

            return cb.equal(

                    cb.lower(root.get("provincia")),

                    province.toLowerCase()

            );

        };

    }

}