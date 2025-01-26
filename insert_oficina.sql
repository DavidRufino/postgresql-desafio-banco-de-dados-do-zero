-- Execução deste script Via Linha de Comando (psql):
-- psql -U postgres -f insert_oficina.sql

-- Desativar o pager para evitar o "-- Mais --"
-- Desativa o pager para que os resultados longos sejam exibidos de forma contínua.
\pset pager off

-- Conectar ao banco de dados recém-criado
\c oficina;

-- Adicionando dados na client
INSERT INTO client (first_name, minit, last_name, address, phone, email, account_balance) 
VALUES
('John', 'D', 'Doe', '123 Main St', '123456789', 'john.doe@gmail.com', 200.00),
('Jane', 'E', 'Smith', '456 Oak St', '987654321', 'jane.smith@gmail.com', 150.50),
('Alice', 'M', 'Johnson', '789 Pine St', '112233445', 'alice.johnson@gmail.com', 350.75);

-- Adicionando dados na mechanic
INSERT INTO mechanic (first_name, minit, last_name, address, specialty, status) 
VALUES
('Carlos', 'R', 'Martinez', '321 Maple St', 'Mecanico de motores', 'Ativo'),
('Lucas', 'J', 'Santos', '654 Birch St', 'Eletricista automotivo', 'Ativo'),
('Fernanda', 'G', 'Lima', '987 Cedar St', 'Mecanico de motores', 'Inativo');

-- Adicionando dados na vehicle
INSERT INTO vehicle (client_id, license_plate, model, year, brand, status) 
VALUES
(1, 'ABC1234', 'Fusca', '1990', 'Volkswagen', 'Em Analise'),
(2, 'XYZ9876', 'Civic', '2019', 'Honda', 'Em Conserto'),
(3, 'LMN4567', 'Corsa', '2007', 'Chevrolet', 'Aguardando Pecas');

-- Adicionando dados na services
INSERT INTO services (description, labor_cost, service_type, duration) 
VALUES
('Troca de oleo', 50.00, 'Manutencao', 30),
('Reparo de motor', 150.00, 'Reparo', 120),
('Inspecao de sistema eletrico', 80.00, 'Inspecao', 45);

-- Adicionando dados na Parts
INSERT INTO parts (description, unit_price, quantity) 
VALUES
('Filtro de oleo', 10.00, 100),
('Pastilha de freio', 25.00, 50),
('Bateria', 150.00, 20);

-- Adicionando dados na service_order
INSERT INTO service_order (vehicle_id, mechanic_id, service_id, status, issued_date, completion_date, total_value, discout, tax, final_amount, payment_status)
VALUES
(1, 1, 1, 'Em andamento', '2025-01-25', NULL, 60.00, 0.00, 12.00, 72.00, 'Pendente'),
(2, 2, 2, 'Em andamento', '2025-01-24', NULL, 300.00, 30.00, 60.00, 330.00, 'Parcelado'),
(3, 3, 3, 'Aguardando Pecas', '2025-01-20', NULL, 130.00, 10.00, 26.00, 146.00, 'Pendente');

-- Adicionando dados na service_order_parts
INSERT INTO service_order_parts (service_order_id, part_id, quantity, unit_price)
VALUES
(1, 1, 1, 10.00),
(2, 2, 2, 25.00),
(3, 3, 1, 150.00);