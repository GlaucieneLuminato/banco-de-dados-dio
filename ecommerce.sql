CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabela de clientes 
CREATE TABLE client (
id_client INT auto_increment PRIMARY KEY,
Fname VARCHAR (50) NOT NULL,
Lname VARCHAR (50),
CPF char (11) UNIQUE NOT NULL,
email varchar (100) UNIQUE,
Phone VARCHAR (20),
Adress VARCHAR (255)
);

-- Tabela de Produtos
CREATE TABLE product (
id_product INT AUTO_INCREMENT PRIMARY KEY,
Pname VARCHAR(100) NOT NULL,
Category ENUM('Eletrônicos','Vestuário','Brinquedos','Alimentos','Beleza','Outros') NOT NULL,
Price DECIMAL(10,2) NOT NULL,
Stock INT DEFAULT 0
);

-- Tabela de pedidos
CREATE TABLE `order`(
id_order INT AUTO_INCREMENT PRIMARY KEY,
id_client INT NOT NULL,
order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
Status ENUM('pendente','pago','enviado','entregue','cancelado') DEFAULT 'pendente',
FOREIGN KEY (id_client) REFERENCES client(id_client)
);

-- Tabela itens de pedido
CREATE TABLE order_item (
id_item INT AUTO_INCREMENT PRIMARY KEY,
id_order INT NOT NULL,
id_product INT NOT NULL,
Quantity INT NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL,
FOREIGN KEY (id_order) REFERENCES `order` (id_order),
FOREIGN KEY (id_product) REFERENCES  product(id_product)
);

-- Tabela de Pagamento
CREATE TABLE payment (
id_payment INT AUTO_INCREMENT PRIMARY KEY,
id_order INT NOT NULL,
paymentMethod ENUM('Cartão','Pix','Boleto','Dinheiro') NOT NULL,
PaymentValue DECIMAL(10,2) NOT NULL,
PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_order) REFERENCES `order` (id_order)
);

-- Inserindo clientes
INSERT INTO client (Fname,Pname,CPF,email,Phone,Adress)
VALUES ('Maria','Silva','12345678901','maria@gmail.com','11999999999','Rua das Flores,100'),
('João','Souza','98765432100','joao@gmail.com','11988888888','Av.Paulista,200'),
('Ana Maria','anamaria@gmail.com','219999998888'),
('Marcos Felipe','marcosfelipe@gmail.com','21988887777');

-- Inserindo Produtos
INSERT INTO product (Pname,Category,Price,Stock)
VALUES ('Smartphone','Eletrônicos',2500.00, 10),
('Camiseta','Vestuário',50.00,30),
('Perfume','Beleza',120.00,15),
('Camiseta Básica',49.90,100),
('Calça jeans',120.00,50);

-- Inserindo um pedido
INSERT INTO `order` (id_client,Status)
VALUES (1,'Pendente');

-- Inserindo itens do pedido
INSERT INTO order_item (id_order,id_product,Quantity,UnitPrice)
VALUES (1,1,1,2500.00),
(1,3,2,120.00),
(1,now(),169.90),
(2,now(),120.00);

-- Inserindo pagamento
INSERT INTO payment (id_order,PaymentMethod,PaymentValue)
VALUES (1,'Pix',2740.00);

SELECT
c.Fname AS cliente,
o.id_order AS pedido,
p.Pname AS produto,
i.Quantity,
pay.PaymentMethod,
pay.PaymentValue,
o.Status
FROM client c
JOIN `order` o ON c.id_client = o.id_client
JOIN order_item i ON o.id_order = i.id_order
JOIN product p ON i.id_product = p.id_product
JOIN payment pay ON o.id_order = pay.id_order



