// src/components/Map.tsx
import React, { useEffect, useRef, useState } from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { MapPin, X, Search, Filter } from 'lucide-react';

// Icono personalizado rojo
const redIcon = new L.Icon({
    iconUrl: '/icons/marker.png',
    iconSize: [35, 35],
    iconAnchor: [12, 41],
    popupAnchor: [0, -41]
});

// Interfaz para las ubicaciones
interface Location {
    name: string;
    lat: number;
    lng: number;
    province: string;
    city: string;
}

// Coordenadas de cooperativas con provincia y ciudad
const locations: Location[] = [
    { name: 'Cooperativa Quito Centro', lat: -0.1807, lng: -78.4678, province: 'Pichincha', city: 'Quito' },
    { name: 'Cooperativa Quito Norte', lat: -0.1457, lng: -78.4878, province: 'Pichincha', city: 'Quito' },
    { name: 'Cooperativa Sangolquí', lat: -0.3074, lng: -78.4478, province: 'Pichincha', city: 'Sangolquí' },
    { name: 'Cooperativa Guayaquil Centro', lat: -2.1894, lng: -79.8891, province: 'Guayas', city: 'Guayaquil' },
    { name: 'Cooperativa Guayaquil Norte', lat: -2.1502, lng: -79.8891, province: 'Guayas', city: 'Guayaquil' },
    { name: 'Cooperativa Durán', lat: -2.1716, lng: -79.8333, province: 'Guayas', city: 'Durán' },
    { name: 'Cooperativa Cuenca Centro', lat: -2.9006, lng: -79.0045, province: 'Azuay', city: 'Cuenca' },
    { name: 'Cooperativa Gualaceo', lat: -2.8928, lng: -78.7799, province: 'Azuay', city: 'Gualaceo' },
    { name: 'Cooperativa Ambato', lat: -1.2541, lng: -78.6229, province: 'Tungurahua', city: 'Ambato' },
    { name: 'Cooperativa Baños', lat: -1.3928, lng: -78.4269, province: 'Tungurahua', city: 'Baños' },
    { name: 'Cooperativa Manta', lat: -0.9537, lng: -80.7089, province: 'Manabí', city: 'Manta' },
    { name: 'Cooperativa Portoviejo', lat: -1.0546, lng: -80.4535, province: 'Manabí', city: 'Portoviejo' },
];

// Obtener provincias únicas
const getUniqueProvinces = (): string[] => {
    const provinces = locations.map(loc => loc.province);
    return ['Todas', ...Array.from(new Set(provinces))];
};

// Obtener ciudades por provincia
const getCitiesByProvince = (province: string): string[] => {
    if (province === 'Todas') return [];
    const cities = locations
        .filter(loc => loc.province === province)
        .map(loc => loc.city);
    return ['Todas', ...Array.from(new Set(cities))];
};

// Componente para centrar el mapa automáticamente
const MapCenterUpdater: React.FC<{ filteredLocations: Location[] }> = ({ filteredLocations }) => {
    const map = useMap();
    
    useEffect(() => {
        if (filteredLocations.length > 0) {
            const bounds = L.latLngBounds(filteredLocations.map(loc => [loc.lat, loc.lng]));
            map.fitBounds(bounds, { padding: [50, 50], maxZoom: 12 });
        }
    }, [filteredLocations, map]);
    
    return null;
};

const Map: React.FC = () => {
    const mapRef = useRef<any>(null);
    const [selectedProvince, setSelectedProvince] = useState<string>('Todas');
    const [selectedCity, setSelectedCity] = useState<string>('Todas');
    const [searchTerm, setSearchTerm] = useState<string>('');
    const [showFilters, setShowFilters] = useState<boolean>(true);

    // Filtrar ubicaciones
    const filteredLocations = locations.filter(location => {
        const matchesProvince = selectedProvince === 'Todas' || location.province === selectedProvince;
        const matchesCity = selectedCity === 'Todas' || location.city === selectedCity;
        const matchesSearch = location.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                            location.province.toLowerCase().includes(searchTerm.toLowerCase()) ||
                            location.city.toLowerCase().includes(searchTerm.toLowerCase());
        return matchesProvince && matchesCity && matchesSearch;
    });

    const provinces = getUniqueProvinces();
    const cities = getCitiesByProvince(selectedProvince);

    const handleProvinceChange = (province: string) => {
        setSelectedProvince(province);
        setSelectedCity('Todas');
    };

    const handleClearFilters = () => {
        setSelectedProvince('Todas');
        setSelectedCity('Todas');
        setSearchTerm('');
    };

    const filteredProvinces = provinces.filter(province =>
        province.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const hasActiveFilters = selectedProvince !== 'Todas' || selectedCity !== 'Todas' || searchTerm !== '';

    const handleWheel = (event: React.WheelEvent) => {
        if (event.ctrlKey && mapRef.current) {
            const map = mapRef.current;
            if (event.deltaY < 0) {
                map.setZoom(map.getZoom() + 1);
            } else {
                map.setZoom(map.getZoom() - 1);
            }
        }
    };

    return (
        <div className="space-y-4">
            {/* Panel de Filtros */}
            <div className="bg-white rounded-2xl shadow-lg border border-gray-200 overflow-hidden">
                {/* Header */}
                <div className="flex items-center justify-between p-4 bg-gradient-to-r from-blue-50 to-indigo-50 border-b border-gray-200">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center shadow-md">
                            <Filter className="w-5 h-5 text-white" />
                        </div>
                        <div>
                            <h3 className="text-lg font-bold text-gray-900">Filtrar Ubicaciones</h3>
                            <p className="text-xs text-gray-600">
                                {hasActiveFilters 
                                    ? `Mostrando: ${filteredLocations.length} cooperativas`
                                    : `Total: ${locations.length} cooperativas`
                                }
                            </p>
                        </div>
                    </div>
                    
                    <button
                        onClick={() => setShowFilters(!showFilters)}
                        className="px-4 py-2 text-sm font-medium text-blue-600 hover:bg-blue-100 rounded-lg transition-colors"
                    >
                        {showFilters ? 'Ocultar' : 'Mostrar'}
                    </button>
                </div>

                {/* Contenido de filtros */}
                {showFilters && (
                    <div className="p-5 space-y-5">
                        {/* Barra de búsqueda */}
                        <div className="relative">
                            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                            <input
                                type="text"
                                placeholder="Buscar cooperativa, provincia o ciudad..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="w-full pl-10 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                            />
                        </div>

                        {/* Provincias */}
                        <div>
                            <div className="flex items-center justify-between mb-3">
                                <label className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                                    <MapPin className="w-4 h-4 text-blue-600" />
                                    Provincias
                                </label>
                                <span className="text-xs text-gray-500">
                                    {filteredProvinces.length} disponibles
                                </span>
                            </div>
                            
                            <div className="flex gap-2 overflow-x-auto pb-2 custom-scrollbar-horizontal">
                                {filteredProvinces.map((province) => (
                                    <button
                                        key={province}
                                        onClick={() => handleProvinceChange(province)}
                                        className={`flex-shrink-0 px-4 py-2 rounded-full font-medium text-sm transition-all duration-200 ${
                                            selectedProvince === province
                                                ? 'bg-gradient-to-r from-blue-500 to-indigo-600 text-white shadow-lg scale-105'
                                                : 'bg-gray-100 text-gray-700 hover:bg-gray-200 hover:scale-105'
                                        }`}
                                    >
                                        {province}
                                        {selectedProvince === province && (
                                            <span className="ml-2 inline-flex items-center justify-center w-5 h-5 bg-white/20 rounded-full">
                                                ✓
                                            </span>
                                        )}
                                    </button>
                                ))}
                            </div>
                        </div>

                        {/* Ciudades */}
                        {selectedProvince && selectedProvince !== 'Todas' && cities.length > 0 && (
                            <div className="pt-2 border-t border-gray-100">
                                <label className="text-sm font-semibold text-gray-700 mb-3 flex items-center gap-2">
                                    <MapPin className="w-4 h-4 text-emerald-600" />
                                    Ciudades de {selectedProvince}
                                </label>
                                
                                <div className="flex gap-2 flex-wrap">
                                    {cities.map((city) => (
                                        <button
                                            key={city}
                                            onClick={() => setSelectedCity(city)}
                                            className={`px-4 py-2 rounded-full font-medium text-sm transition-all duration-200 ${
                                                selectedCity === city
                                                    ? 'bg-gradient-to-r from-emerald-500 to-teal-600 text-white shadow-lg scale-105'
                                                    : 'bg-gray-100 text-gray-700 hover:bg-gray-200 hover:scale-105'
                                            }`}
                                        >
                                            {city}
                                        </button>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* Botón de limpiar */}
                        {hasActiveFilters && (
                            <div className="pt-3 border-t border-gray-100">
                                <button
                                    onClick={handleClearFilters}
                                    className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-red-500 to-pink-600 text-white rounded-xl font-medium hover:from-red-600 hover:to-pink-700 transition-all shadow-md hover:shadow-lg hover:scale-105"
                                >
                                    <X className="w-5 h-5" />
                                    Limpiar Filtros
                                </button>
                            </div>
                        )}
                    </div>
                )}
            </div>

            {/* Mapa */}
            <div
                className="relative z-0 h-[500px] w-full rounded-2xl overflow-hidden shadow-2xl border border-gray-200"
                onWheel={handleWheel}
            >
                <MapContainer
                    center={[-1.8312, -78.1834]}
                    zoom={6}
                    scrollWheelZoom={false}
                    className="h-full w-full"
                    ref={mapRef}
                >
                    <TileLayer
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    />
                    <MapCenterUpdater filteredLocations={filteredLocations} />
                    {filteredLocations.map((location, index) => (
                        <Marker
                            key={index}
                            position={[location.lat, location.lng]}
                            icon={redIcon}
                        >
                            <Popup>
                                <div className="text-center">
                                    <strong className="text-blue-600">{location.name}</strong>
                                    <p className="text-xs text-gray-600 mt-1">
                                        📍 {location.city}, {location.province}
                                    </p>
                                </div>
                            </Popup>
                        </Marker>
                    ))}
                </MapContainer>

                {/* Badge flotante con contador */}
                {hasActiveFilters && (
                    <div className="absolute top-4 right-4 z-[1000] bg-white/95 backdrop-blur-sm px-4 py-2 rounded-full shadow-lg border border-gray-200 animate-fadeIn">
                        <p className="text-sm font-semibold text-gray-700">
                            🎯 {filteredLocations.length} resultados
                        </p>
                    </div>
                )}
            </div>

            <style>{`
                .custom-scrollbar-horizontal::-webkit-scrollbar {
                    height: 6px;
                }
                .custom-scrollbar-horizontal::-webkit-scrollbar-track {
                    background: #f1f5f9;
                    border-radius: 10px;
                }
                .custom-scrollbar-horizontal::-webkit-scrollbar-thumb {
                    background: linear-gradient(to right, #3b82f6, #6366f1);
                    border-radius: 10px;
                }
                .custom-scrollbar-horizontal::-webkit-scrollbar-thumb:hover {
                    background: linear-gradient(to right, #2563eb, #4f46e5);
                }
                @keyframes fadeIn {
                    from { opacity: 0; transform: translateY(-10px); }
                    to { opacity: 1; transform: translateY(0); }
                }
                .animate-fadeIn {
                    animation: fadeIn 0.3s ease-out;
                }
            `}</style>
        </div>
    );
};

export default Map;