import { useCallback, useEffect, useState } from "react";
import { useToast } from "@/hooks/useToast";

import {
  getCooperatives,
  createCooperative,
  updateCooperative,
  deleteCooperative,
} from "../api/cooperatives.api";

import type {
  CooperativeListItem,
  CooperativesPageResponse,
  CreateCooperativeRequest,
  UpdateCooperativeRequest,
} from "../types/cooperative";

export function useCooperatives() {

  const toast = useToast();

  const [cooperatives, setCooperatives] = useState<CooperativeListItem[]>([]);

  const [loading, setLoading] = useState(false);

  const [page, setPage] = useState(0);

  const [size] = useState(10);

  const [search, setSearch] = useState("");

  const [city, setCity] = useState("");

  const [province, setProvince] = useState("");

  const [totalPages, setTotalPages] = useState(0);

  const [totalElements, setTotalElements] = useState(0);

  const loadCooperatives = useCallback(async () => {

    try {

      setLoading(true);

      const response: CooperativesPageResponse =
        await getCooperatives(
          page,
          size,
          search,
          city,
          province
        );

      setCooperatives(response.content);

      setTotalPages(response.totalPages);

      setTotalElements(response.totalElements);

    } finally {

      setLoading(false);

    }

  }, [page, size, search, city, province]);

  useEffect(() => {

    loadCooperatives();

  }, [loadCooperatives]);

  const create = async (
    request: CreateCooperativeRequest
  ) => {

    try {

      await createCooperative(request);

      toast.success(
        "Cooperativa creada",
        "La cooperativa se registró correctamente."
      );

      await loadCooperatives();

    } catch (error: any) {

      toast.error(
        "No se pudo crear la cooperativa",
        error?.response?.data?.message ??
          "Ha ocurrido un error."
      );

      throw error;

    }

  };

  const update = async (
    id: number,
    request: UpdateCooperativeRequest
  ) => {

    try {

      await updateCooperative(id, request);

      toast.success(
        "Cooperativa actualizada",
        "Los cambios fueron guardados correctamente."
      );

      await loadCooperatives();

    } catch (error: any) {

      toast.error(
        "No se pudo actualizar",
        error?.response?.data?.message ??
          "Ha ocurrido un error."
      );

      throw error;

    }

  };

  const remove = async (
    id: number
  ) => {

    try {

      await deleteCooperative(id);

      toast.success(
        "Cooperativa eliminada",
        "La cooperativa fue eliminada correctamente."
      );

      await loadCooperatives();

    } catch (error: any) {

      toast.error(
        "No se pudo eliminar",
        error?.response?.data?.message ??
          "Ha ocurrido un error."
      );

      throw error;

    }

  };

  return {

    cooperatives,

    loading,

    page,

    size,

    totalPages,

    totalElements,

    setPage,

    reload: loadCooperatives,

    create,

    update,

    remove,

    search,

    city,

    province,

    setSearch,

    setCity,

    setProvince,

};

}