package com.mediturnos.service;

import com.mediturnos.model.Especialidad;
import com.mediturnos.repository.EspecialidadRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EspecialidadService {

    private final EspecialidadRepository repo;

    public List<Especialidad> listar() {
        return repo.findAll();
    }

    public Especialidad obtener(Long id) {
        return repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Especialidad no encontrada: " + id));
    }

    public Especialidad crear(Especialidad e) {
        if (repo.existsByNombre(e.getNombre())) {
            throw new RuntimeException("Ya existe una especialidad con ese nombre");
        }
        return repo.save(e);
    }

    public Especialidad actualizar(Long id, Especialidad datos) {
        Especialidad e = obtener(id);
        e.setNombre(datos.getNombre());
        return repo.save(e);
    }

    public void eliminar(Long id) {
        repo.deleteById(id);
    }
}

