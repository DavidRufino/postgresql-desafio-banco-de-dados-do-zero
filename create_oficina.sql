-- Execução deste script Via Linha de Comando (psql):
-- psql -U postgres -f create_oficina.sql

-- Desativar o pager para evitar o "-- Mais --"
-- Desativa o pager para que os resultados longos sejam exibidos de forma contínua.
\pset pager off

-- Verifica se o banco 'oficina' existe. Se não existir, cria o banco dinamicamente.
SELECT 'CREATE DATABASE oficina' 
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'oficina')\gexec

-- Conectar ao banco de dados recém-criado
\c oficina;

-- Criar as tabelas no banco de dados
CREATE TABLE IF NOT EXISTS client (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    minit CHAR(1),
    last_name VARCHAR(15) NOT NULL,
    
    address VARCHAR(255),
    phone VARCHAR(9),
    email VARCHAR(255),

    account_balance FLOAT
);

CREATE TYPE mechanic_specialty AS ENUM ('Eletricista automotivo', 'Mecânico de motores');

CREATE TYPE mechanic_status AS ENUM ('Ativo', 'Inativo');

CREATE TABLE IF NOT EXISTS mechanic (
    mechanic_id SERIAL PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    minit CHAR(1),
    last_name VARCHAR(15) NOT NULL,
    
    address VARCHAR(255),

    specialty MECHANIC_SPECIALTY NOT NULL,
    status MECHANIC_STATUS NOT NULL
);

-- Tipo ENUM para status dos "product_order"
CREATE TYPE vehicle_status AS ENUM ('Em Analise', 'Em Conserto', 'Aguardando Pecas', 'Pronto Para Retirada', 'Concluido');

CREATE TABLE IF NOT EXISTS vehicle (
    vehicle_id SERIAL PRIMARY KEY,
    client_id INT,

    license_plate VARCHAR(15) NOT NULL,
    model VARCHAR(25) NOT NULL,
    year VARCHAR(4) NOT NULL,

    brand VARCHAR(25) NOT NULL,
    status VEHICLE_STATUS DEFAULT 'Em Analise',
    
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE TYPE services_types AS ENUM ('Manutencao', 'Reparo', 'Inspecao');

CREATE TABLE IF NOT EXISTS services (
    service_id SERIAL PRIMARY KEY,
    description TEXT,

    labor_cost FLOAT,
    service_type SERVICES_TYPES NOT NULL,

    duration INT
);

CREATE TABLE IF NOT EXISTS parts (
    part_id SERIAL PRIMARY KEY,
    description TEXT,

    unit_price FLOAT,
    quantity INT
);

CREATE TYPE service_order_status AS ENUM ('Em andamento', 'Finalizado', 'Aguardando Pecas', 'Cancelado');
CREATE TYPE payment_status AS ENUM ('Pago', 'Pendente', 'Parcelado');

CREATE TABLE IF NOT EXISTS service_order (
    service_order_id SERIAL PRIMARY KEY,

    vehicle_id INT,
    mechanic_id INT,
    service_id INT,
    part_id INT,

    status SERVICE_ORDER_STATUS NOT NULL,
    issued_date DATE,
    completion_date DATE,

    total_value FLOAT,
    discout FLOAT,
    tax FLOAT,
    final_amount FLOAT,
    payment_status PAYMENT_STATUS,

    CONSTRAINT fk_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id), 
    CONSTRAINT fk_mechanic FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id),
    CONSTRAINT fk_services FOREIGN KEY (service_id) REFERENCES services(service_id)
);

CREATE TABLE IF NOT EXISTS service_order_parts (
    service_order_id INT,
    part_id INT,
    quantity INT,
    unit_price FLOAT,
    
    PRIMARY KEY (service_order_id, part_id),

    CONSTRAINT fk_service_order FOREIGN KEY (service_order_id) REFERENCES service_order(service_order_id),
    CONSTRAINT fk_part FOREIGN KEY (part_id) REFERENCES parts(part_id)
);
