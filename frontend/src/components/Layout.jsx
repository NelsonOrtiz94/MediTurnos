import { NavLink, Outlet } from 'react-router-dom';
import './Layout.css';

export default function Layout() {
  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="sidebar-logo">🏥 MediTurnos</div>
        <nav>
          <NavLink to="/" end>🏠 Inicio</NavLink>
          <NavLink to="/especialidades">🔬 Especialidades</NavLink>
          <NavLink to="/medicos">👨‍⚕️ Médicos</NavLink>
          <NavLink to="/pacientes">🧑 Pacientes</NavLink>
          <NavLink to="/citas">📅 Citas</NavLink>
        </nav>
      </aside>
      <main className="main-content">
        <Outlet />
      </main>
    </div>
  );
}

