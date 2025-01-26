-- Execução deste script Via Linha de Comando (psql):
-- psql -U postgres -f query_oficina.sql

-- Desativar o pager para evitar o "-- Mais --"
-- Desativa o pager para que os resultados longos sejam exibidos de forma contínua.
\pset pager off

-- Conectar ao banco de dados recém-criado
\c oficina;

----
-- Recuperações simples com SELECT Statement

-- Seleciona todos os dados da tabela de clientes
SELECT * 
FROM client;

-- Seleciona informações específicas dos veículos
SELECT vehicle_id, license_plate, model, brand, status 
FROM vehicle;

----
-- Filtros com WHERE Statement

-- Clientes com saldo de conta maior que 200
SELECT first_name, last_name, account_balance 
FROM client 
WHERE account_balance > 200;

-- Veículos da marca 'Honda'
SELECT license_plate, model, year, brand 
FROM vehicle 
WHERE brand = 'Honda';

-- Serviços com custo de mão de obra acima de 100
SELECT service_id, description, labor_cost 
FROM services 
WHERE labor_cost > 100;

----
-- Crie expressões para gerar atributos derivados

-- Calcula o valor final de cada cliente com um desconto fictício de 10%
SELECT first_name, last_name, account_balance, 
       account_balance * 0.9 AS discounted_balance
FROM client;

-- Calcula o custo total de cada serviço considerando mão de obra e um imposto de 10%
SELECT description, labor_cost, 
       labor_cost * 1.1 AS total_cost_with_tax
FROM services;

-- Gera o nome completo dos mecânicos
SELECT mechanic_id, 
       first_name || ' ' || COALESCE(minit || ' ', '') || last_name AS full_name
FROM mechanic;

----
-- Defina ordenações dos dados com ORDER BY

-- Ordena os clientes pelo saldo da conta em ordem decrescente
SELECT first_name, last_name, account_balance 
FROM client 
ORDER BY account_balance DESC;

-- Ordena os serviços pelo custo de mão de obra em ordem crescente
SELECT description, labor_cost 
FROM services 
ORDER BY labor_cost ASC;

-- Ordena as ordens de serviço pela data de emissão mais recente
SELECT service_order_id, issued_date, status 
FROM service_order 
ORDER BY issued_date DESC;

----
-- Condições de filtros aos grupos – HAVING Statement

-- Soma os valores totais de ordens de serviço por status e exibe apenas os que têm total acima de 100
SELECT status, SUM(total_value) AS total_service_value
FROM service_order
GROUP BY status
HAVING SUM(total_value) > 100;

-- Mostra mecânicos com mais de uma ordem de serviço associada
SELECT mechanic_id, COUNT(service_order_id) AS service_count
FROM service_order
GROUP BY mechanic_id
HAVING COUNT(service_order_id) > 1;

-- Lista peças que foram usadas em pelo menos 2 ordens de serviço
SELECT part_id, COUNT(service_order_id) AS usage_count
FROM service_order_parts
GROUP BY part_id
HAVING COUNT(service_order_id) >= 2;

----
-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados

-- Exibe informações de veículos junto com os dados dos clientes proprietários
SELECT v.vehicle_id, v.license_plate, v.model, v.brand, c.first_name, c.last_name
FROM vehicle v
INNER JOIN client c ON v.client_id = c.client_id;

-- Mostra todas as ordens de serviço junto com informações de mecânicos e veículos
SELECT so.service_order_id, so.status, so.issued_date, 
       m.first_name || ' ' || m.last_name AS mechanic_name, 
       v.license_plate AS vehicle
FROM service_order so
INNER JOIN mechanic m ON so.mechanic_id = m.mechanic_id
INNER JOIN vehicle v ON so.vehicle_id = v.vehicle_id;

-- Lista os serviços realizados em cada ordem de serviço junto com os custos
SELECT so.service_order_id, s.description AS service, s.labor_cost AS cost, so.issued_date
FROM service_order so
INNER JOIN services s ON so.service_id = s.service_id;

-- Mostra quais peças foram usadas em cada ordem de serviço, com suas quantidades e preços
SELECT sop.service_order_id, p.description AS part_name, sop.quantity, sop.unit_price
FROM service_order_parts sop
INNER JOIN parts p ON sop.part_id = p.part_id;
