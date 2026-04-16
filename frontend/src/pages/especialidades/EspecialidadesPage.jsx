import { useState, useEffect } from 'react';
import { getEspecialidades, createEspecialidad, updateEspecialidad, deleteEspecialidad } from '../../api';

export default function EspecialidadesPage() {
  const [lista, setLista]     = useState([]);
  const [nombre, setNombre]   = useState('');
  const [editId, setEditId]   = useState(null);
  const [error, setError]     = useState('');

  const cargar = () => getEspecialidades().then(r => setLista(r.data)).catch(() => {});

  useEffect(() => { cargar(); }, []);

  const guardar = async (e) => {
    e.preventDefault();
    setError('');
    try {
      if (editId) {
        await updateEspecialidad(editId, { nombre });
      } else {
        await createEspecialidad({ nombre });
      }
      setNombre(''); setEditId(null);
      cargar();
    } catch (err) {
      setError(err.response?.data?.error || 'Error al guardar');
    }
  };

  const editar = (esp) => { setEditId(esp.id); setNombre(esp.nombre); };

  const eliminar = async (id) => {
    if (window.confirm('¿Eliminar especialidad?')) {
      await deleteEspecialidad(id);
      cargar();
    }
  };

  return (
    <div>
      <h2>Especialidades</h2>

      <form onSubmit={guardar} style={{ marginBottom: 16 }}>
        <input
          value={nombre}
          onChange={e => setNombre(e.target.value)}
          placeholder="Nombre de la especialidad"
          required
          style={{ marginRight: 8, padding: '6px 10px' }}
        />
        <button type="submit" className="btn-primary">
          {editId ? 'Actualizar' : 'Agregar'}
        </button>
        {editId && (
          <button type="button" onClick={() => { setEditId(null); setNombre(''); }}
            style={{ marginLeft: 8 }}>
            Cancelar
          </button>
        )}
        {error && <span style={{ color: 'red', marginLeft: 12 }}>{error}</span>}
      </form>

      <table className="tabla">
        <thead><tr><th>#</th><th>Nombre</th><th>Acciones</th></tr></thead>
        <tbody>
          {lista.map(esp => (
            <tr key={esp.id}>
              <td>{esp.id}</td>
              <td>{esp.nombre}</td>
              <td>
                <button onClick={() => editar(esp)} className="btn-edit">Editar</button>
                <button onClick={() => eliminar(esp.id)} className="btn-delete">Eliminar</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

