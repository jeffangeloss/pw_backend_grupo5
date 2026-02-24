INSERT INTO category (name) VALUES
('Alimentacion'),
('Transporte'),
('Servicios'),
('Salud'),
('Educacion'),
('Otros')
ON CONFLICT (name) DO NOTHING;
