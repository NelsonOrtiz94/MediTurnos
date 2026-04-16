package com.mediturnos.repository;

import com.mediturnos.model.Medico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MedicoRepository extends JpaRepository<Medico, Long> {
    boolean existsByDocumento(String documento);
    List<Medico> findByNombreContainingIgnoreCaseOrDocumentoContainingIgnoreCase(String nombre, String documento);
    List<Medico> findByEspecialidadId(Long especialidadId);
}

