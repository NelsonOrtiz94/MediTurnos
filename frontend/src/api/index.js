import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: { 'Content-Type': 'application/json' },
});

// ── Especialidades ────────────────────────────────────────────────────────────
export const getEspecialidades    = ()        => api.get('/especialidades');
export const createEspecialidad   = (data)    => api.post('/especialidades', data);
export const updateEspecialidad   = (id, data)=> api.put(`/especialidades/${id}`, data);
export const deleteEspecialidad   = (id)      => api.delete(`/especialidades/${id}`);

// ── Médicos ───────────────────────────────────────────────────────────────────
export const getMedicos     = (q = '')   => api.get('/medicos', { params: q ? { q } : {} });
export const createMedico   = (data)     => api.post('/medicos', data);
export const updateMedico   = (id, data) => api.put(`/medicos/${id}`, data);
export const deleteMedico   = (id)       => api.delete(`/medicos/${id}`);

// ── Pacientes ─────────────────────────────────────────────────────────────────
export const getPacientes    = (q = '')   => api.get('/pacientes', { params: q ? { q } : {} });
export const createPaciente  = (data)     => api.post('/pacientes', data);
export const updatePaciente  = (id, data) => api.put(`/pacientes/${id}`, data);
export const deletePaciente  = (id)       => api.delete(`/pacientes/${id}`);

// ── Citas ─────────────────────────────────────────────────────────────────────
export const getCitas        = ()          => api.get('/citas');
export const createCita      = (data)      => api.post('/citas', data);
export const reprogramarCita = (id, fecha) => api.put(`/citas/${id}/reprogramar`, null, { params: { fechaHora: fecha } });
export const cancelarCita    = (id, motivo)=> api.put(`/citas/${id}/cancelar`, null, { params: { motivo } });
export const completarCita   = (id)        => api.put(`/citas/${id}/completar`);
export const getAgenda       = (fecha)     => api.get('/citas/agenda', { params: { fecha } });
export const getHistorial    = (pacienteId, desde, hasta) =>
  api.get(`/citas/historial/${pacienteId}`, { params: { desde, hasta } });
export const getReporte      = (desde, hasta) =>
  api.get('/citas/reporte', { params: { desde, hasta } });

