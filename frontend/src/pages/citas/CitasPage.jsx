import { useState, useEffect } from 'react';
import {
  getCitas, createCita, cancelarCita, completarCita, reprogramarCita,
  getPacientes, getMedicos, getAgenda, getHistorial, getReporte
} from '../../api';

const TABS = ['Agendar', 'Todas las citas', 'Agenda diaria', 'Historial paciente', 'Reporte'];

export default function CitasPage() {
  const [tab, setTab]             = useState(0);
  const [pacientes, setPacientes] = useState([]);
  const [medicos, setMedicos]     = useState([]);
  const [citas, setCitas]         = useState([]);
  const [error, setError]         = useState('');

  // Agendar
  const [form, setForm] = useState({ paciente: { id: '' }, medico: { id: '' }, fechaHora: '' });

  // Agenda diaria
  const [fechaAgenda, setFechaAgenda] = useState('');
  const [agenda, setAgenda]           = useState([]);

  // Historial
  const [pacHistorial, setPacHistorial] = useState('');
  const [histDesde, setHistDesde]       = useState('');
  const [histHasta, setHistHasta]       = useState('');
  const [historial, setHistorial]       = useState([]);

  // Reporte
  const [repDesde, setRepDesde]   = useState('');
  const [repHasta, setRepHasta]   = useState('');
  const [reporte, setReporte]     = useState(null);

  // Reprogramar
  const [reprogId, setReprogId]   = useState('');
  const [reprogFecha, setReprogFecha] = useState('');

  useEffect(() => {
    getPacientes().then(r => setPacientes(r.data));
    getMedicos().then(r => setMedicos(r.data));
    getCitas().then(r => setCitas(r.data));
  }, []);

  const recargar = () => getCitas().then(r => setCitas(r.data));

  const agendar = async (e) => {
    e.preventDefault(); setError('');
    try {
      await createCita({ ...form, estado: 'PROGRAMADA' });
      setForm({ paciente: { id: '' }, medico: { id: '' }, fechaHora: '' });
      recargar();
      alert('Cita agendada exitosamente');
    } catch (err) {
      setError(err.response?.data?.error || 'Error al agendar');
    }
  };

  const cancelar = async (id) => {
    const motivo = prompt('Motivo de cancelación (opcional):');
    await cancelarCita(id, motivo || '');
    recargar();
  };

  const completar = async (id) => { await completarCita(id); recargar(); };

  const reprogramar = async (e) => {
    e.preventDefault(); setError('');
    try {
      await reprogramarCita(reprogId, reprogFecha);
      setReprogId(''); setReprogFecha('');
      recargar(); alert('Cita reprogramada');
    } catch (err) {
      setError(err.response?.data?.error || 'Error al reprogramar');
    }
  };

  const buscarAgenda = (e) => {
    e.preventDefault();
    getAgenda(fechaAgenda).then(r => setAgenda(r.data));
  };

  const buscarHistorial = (e) => {
    e.preventDefault();
    getHistorial(pacHistorial, histDesde || undefined, histHasta || undefined)
      .then(r => setHistorial(r.data));
  };

  const buscarReporte = (e) => {
    e.preventDefault();
    getReporte(repDesde, repHasta).then(r => setReporte(r.data));
  };

  const estadoBadge = (e) => {
    const colors = { PROGRAMADA: '#1976d2', CANCELADA: '#d32f2f', COMPLETADA: '#388e3c' };
    return <span style={{ color: '#fff', background: colors[e] || '#555',
      padding: '2px 8px', borderRadius: 4, fontSize: 12 }}>{e}</span>;
  };

  return (
    <div>
      <h2>Citas</h2>

      {/* Tabs */}
      <div style={{ display: 'flex', gap: 8, marginBottom: 20 }}>
        {TABS.map((t, i) => (
          <button key={i} onClick={() => setTab(i)}
            style={{ padding: '6px 14px', borderRadius: 4, border: 'none', cursor: 'pointer',
              background: tab === i ? '#1976d2' : '#e0e0e0',
              color: tab === i ? '#fff' : '#333' }}>
            {t}
          </button>
        ))}
      </div>

      {error && <p style={{ color: 'red' }}>{error}</p>}

      {/* ── Tab 0: Agendar ── */}
      {tab === 0 && (
        <form onSubmit={agendar} className="form-grid">
          <select value={form.paciente.id} onChange={e => setForm(f => ({ ...f, paciente: { id: Number(e.target.value) } }))} required>
            <option value="">-- Paciente * --</option>
            {pacientes.map(p => <option key={p.id} value={p.id}>{p.nombre} ({p.documento})</option>)}
          </select>
          <select value={form.medico.id} onChange={e => setForm(f => ({ ...f, medico: { id: Number(e.target.value) } }))} required>
            <option value="">-- Médico * --</option>
            {medicos.map(m => <option key={m.id} value={m.id}>{m.nombre} — {m.especialidad?.nombre}</option>)}
          </select>
          <input type="datetime-local" value={form.fechaHora}
            onChange={e => setForm(f => ({ ...f, fechaHora: e.target.value }))} required />
          <button type="submit" className="btn-primary">Agendar cita</button>
        </form>
      )}

      {/* ── Tab 1: Todas las citas + Reprogramar ── */}
      {tab === 1 && (
        <>
          <form onSubmit={reprogramar} style={{ marginBottom: 16, display: 'flex', gap: 8, alignItems: 'center' }}>
            <select value={reprogId} onChange={e => setReprogId(e.target.value)} required>
              <option value="">-- Cita a reprogramar --</option>
              {citas.filter(c => c.estado === 'PROGRAMADA').map(c => (
                <option key={c.id} value={c.id}>
                  #{c.id} — {c.paciente?.nombre} / {c.medico?.nombre} — {new Date(c.fechaHora).toLocaleString()}
                </option>
              ))}
            </select>
            <input type="datetime-local" value={reprogFecha}
              onChange={e => setReprogFecha(e.target.value)} required />
            <button type="submit" className="btn-primary">Reprogramar</button>
          </form>

          <table className="tabla">
            <thead>
              <tr><th>#</th><th>Paciente</th><th>Médico</th><th>Fecha/Hora</th><th>Estado</th><th>Acciones</th></tr>
            </thead>
            <tbody>
              {citas.map(c => (
                <tr key={c.id}>
                  <td>{c.id}</td>
                  <td>{c.paciente?.nombre}</td>
                  <td>{c.medico?.nombre}</td>
                  <td>{new Date(c.fechaHora).toLocaleString()}</td>
                  <td>{estadoBadge(c.estado)}</td>
                  <td>
                    {c.estado === 'PROGRAMADA' && (
                      <>
                        <button onClick={() => completar(c.id)} className="btn-edit">Completar</button>
                        <button onClick={() => cancelar(c.id)} className="btn-delete">Cancelar</button>
                      </>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}

      {/* ── Tab 2: Agenda diaria ── */}
      {tab === 2 && (
        <>
          <form onSubmit={buscarAgenda} style={{ marginBottom: 12, display: 'flex', gap: 8 }}>
            <input type="date" value={fechaAgenda} onChange={e => setFechaAgenda(e.target.value)} required />
            <button type="submit" className="btn-primary">Ver agenda</button>
          </form>
          <table className="tabla">
            <thead><tr><th>Hora</th><th>Paciente</th><th>Médico</th><th>Estado</th></tr></thead>
            <tbody>
              {agenda.map(c => (
                <tr key={c.id}>
                  <td>{new Date(c.fechaHora).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</td>
                  <td>{c.paciente?.nombre}</td>
                  <td>{c.medico?.nombre}</td>
                  <td>{estadoBadge(c.estado)}</td>
                </tr>
              ))}
              {agenda.length === 0 && <tr><td colSpan={4} style={{ textAlign: 'center' }}>Sin citas para esta fecha</td></tr>}
            </tbody>
          </table>
        </>
      )}

      {/* ── Tab 3: Historial ── */}
      {tab === 3 && (
        <>
          <form onSubmit={buscarHistorial} style={{ marginBottom: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            <select value={pacHistorial} onChange={e => setPacHistorial(e.target.value)} required>
              <option value="">-- Selecciona paciente --</option>
              {pacientes.map(p => <option key={p.id} value={p.id}>{p.nombre}</option>)}
            </select>
            <input type="date" value={histDesde} onChange={e => setHistDesde(e.target.value)} placeholder="Desde" />
            <input type="date" value={histHasta} onChange={e => setHistHasta(e.target.value)} placeholder="Hasta" />
            <button type="submit" className="btn-primary">Buscar</button>
          </form>
          <table className="tabla">
            <thead><tr><th>Fecha</th><th>Médico</th><th>Estado</th></tr></thead>
            <tbody>
              {historial.map(c => (
                <tr key={c.id}>
                  <td>{new Date(c.fechaHora).toLocaleString()}</td>
                  <td>{c.medico?.nombre}</td>
                  <td>{estadoBadge(c.estado)}</td>
                </tr>
              ))}
              {historial.length === 0 && <tr><td colSpan={3} style={{ textAlign: 'center' }}>Sin resultados</td></tr>}
            </tbody>
          </table>
        </>
      )}

      {/* ── Tab 4: Reporte ── */}
      {tab === 4 && (
        <>
          <form onSubmit={buscarReporte} style={{ marginBottom: 16, display: 'flex', gap: 8 }}>
            <input type="date" value={repDesde} onChange={e => setRepDesde(e.target.value)} required />
            <input type="date" value={repHasta} onChange={e => setRepHasta(e.target.value)} required />
            <button type="submit" className="btn-primary">Generar reporte</button>
          </form>
          {reporte && (
            <table className="tabla" style={{ maxWidth: 400 }}>
              <thead><tr><th>Estado</th><th>Total</th></tr></thead>
              <tbody>
                {Object.entries(reporte).map(([estado, total]) => (
                  <tr key={estado}>
                    <td>{estadoBadge(estado)}</td>
                    <td><strong>{total}</strong></td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </div>
  );
}

