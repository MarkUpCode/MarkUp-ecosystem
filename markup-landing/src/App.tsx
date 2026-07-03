import { BrowserRouter, Routes, Route } from "react-router-dom";

import Header from './components/layout/Header';
import Footer from './components/layout/Footer';
import Popup from "./components/ui/Popup";

import Home from "./pages/Home";
import Terms from "./pages/Terms";

function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-white font-sans">
        <Popup />

        <Routes>
          {/* HOME */}
          <Route 
            path="/" 
            element={
              <>
                <Header />
                <Home />
                <Footer />
              </>
            } 
          />

          {/* TÉRMINOS (sin header y sin footer) */}
          <Route 
            path="/terminos" 
            element={
              <>
                <Terms />
              </>
            } 
          />
        </Routes>

      </div>
    </BrowserRouter>
  );
}

export default App;
