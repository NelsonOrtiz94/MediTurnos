import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import HomePage from './pages/HomePage';
import EspecialidadesPage from './pages/especialidades/EspecialidadesPage';
import MedicosPage from './pages/medicos/MedicosPage';
import PacientesPage from './pages/pacientes/PacientesPage';
import CitasPage from './pages/citas/CitasPage';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<HomePage />} />
          <Route path="especialidades" element={<EspecialidadesPage />} />
          <Route path="medicos" element={<MedicosPage />} />
          <Route path="pacientes" element={<PacientesPage />} />
          <Route path="citas" element={<CitasPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
