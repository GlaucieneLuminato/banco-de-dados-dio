drop database if exists ecommerce;
create database ecommerce character set utf8mb4 collate utf8mb4_unicode_ci;
use ecommerce;

-- tabela de apoio: pessoa física e jurídica
create table person (
id int auto_increment primary key,
cpf varchar(14) not null unique,
first_name varchar(100) not null,
last_name varchar(100) not null,
email varchar(150),
phone varchar(30)
) engine=innodb;

create table company (
id int auto_increment primary key,
cnpj varchar(20) not null unique,
company_name varchar(200) not null,
contact_name varchar(120),
email varchar(150),
phone varchar(30)
) engine=InnoDB;

-- cada conta é  PF ou PJ
create table customer (
id int auto_increment primary key,
username varchar(80) not null unique,
password_hash varchar(255) null,
person_id int null,
company_id int null,
create_at datetime default current_timestamp,

constraint fk_custumer_person foreign key (person_id)
references person(id) on delete set null,
constraint fk_customer_company foreign key (company_id)
references company(id) on delete set null,
constraint chk_customer_pf_pj check ((person_id is null) <> (company_id is null)))
engine=innodb;

-- vendedores (seller): podem ser pessoa ou empresa também
create table seller (
id int auto_increment primary key,
nickname varchar(80) not null,
person_id int null,
company_id int null,
create_at datetime default current_timestamp,
constraint fk_seller_person foreign key (person_id)
references person(id) on delete set null,
constraint fk_seller_company foreign key (company_id)
references company(id) on delete set null,
constraint chk_seller_pf_pj check ((person_id is null)<> (company_id is null))
) engine=InnoDB;

-- fornecedores (suppliers): podem ser empresas
create table suppplier (
id int auto_increment primary key,
supplier_name varchar(200) not null,
contact varchar(120),
email varchar(150),
phone varchar(30),
unique (supplier_name)
)engine=innodb;

-- produtos
create table product (
id int auto_increment primary key,
sku varchar(80) not null unique,
name varchar(200) not null,
description text,
unit_price decimal(10,2) not null default 0.00,
create_at datetime default current_timestamp
) engine=InnoDB;

-- produto fornecedor N:N
create table product_supplier (
producit_id int not null,
supplier_id int not null,
supplier_sku varchar(80),
lead_time_days int default 0,
primary key(product_id, supplier_id),

constraint fk_ps_product foreign key (product_id)
references product(id) on delete cascade,
constraint fk_ps_supplier foreign key (supplier_id)
references supplier(id) on delete cascade
) engine=innodb;

-- stock por produto
create table stock (
product_id int primary key,
quantity int not null default 0,

constraint fk_stock_product foreign key (product_id)
references product(id) on delete cascade
) engine=InnoDB;

-- método de pagamento
create table payment_method (
id int auto_increment primary key,
customer_id int not null,
method_type enum('cartão_crédito','boleto','pix','cartão_débito','outros') not null,
provider varchar(100),
last_digits varchar(10),
create_at datetime default current_timestamp,

constraint fk_payment_costumer foreign key(custumer_id)
references customer(id) on delete cascade
) engine=InnoDB;

-- pedido + entrega
create table `order` (
id bigint auto_increment primary key,
customer_id int not null,
seller_id int null,
payment_method_id int null,
order_date datetime default current_timestamp,
status enum('pendente','pago','processando','enviado','enregue','cancelado') not null default 'pendente',
total_amont decimal(12,2) not null default 0.00,

constraint fk_order_customer foreign key (customer_id)
references customer(id) on delete restrict,
constraint fk_order_seller foreign key (seller_id)references seller(id) on delete set null,
constraint fk_order_payment foreign key (payment_method_id) references payment_method(id) on delete set null
) engine=InnoDB;

create table delivery (
id int auto_increment primary key,
order_id bigint not null,
shipping_provider varchar(150),
tracking_code varchar(150) unique,
status enum('pendente','em trânsito','entregue','retornado','perdido') default 'pendente',
shipped_at datetime null,
delivered_at datetime null,

constraint fk_delivery_order foreign key(order_id)
references `order` (id) on delete cascade 
) engine=InnoDB;

-- order items
create table order_item (
id bigint auto_increment primary key,
order_id bigint not null,
product_id int not null,
quantity int not null default 1,
unit_price decimal(10,2) not null,
discount decimal(10,2) default 0.00,

constraint fk_item_order foreign key (order_id) references `order` (id) on delete cascade,
constraint fk_item_product foreign key (product_id) references product(id) on delete restrict 
) engine=InnoDB;

create table activity_log (
id int auto_increment primary key,
entity varchar(60),
entity_id varchar(60),
action varchar(60),
create_at datetime default current_timestamp
) engine=InnoDB;

-- pessoas e empresas
insert into person (cpf,first_name,last_name,email,phone)
values
('123.456.789-10','Ana','Silva','ana.sila@exemplo.com','(11)99999-0001'),
('234.567.890-11','Carlos','Souza','carlos.souza@exemplo.com','(11)99999-0002');

insert into company (cnpj,company_name,contact_name,email,phone)
values
('12.345.678/00001-90','Loja da Esquina LTDA','Mariana','contato@lojaesquina.com','(11)3333-4444');

-- pf e pj
insert into customer (username,password_hash,person_id,cpmpany_id)
values
('ana.s','<hash>',1,null),
('lojadaesquina','<hash>',null,1);

-- sellers
insert into seller (nickname,person_id,company_id)
values
('ana-vendedora',1,null),
('loja-vendedor',null,1);

-- suppliers
insert into supplier (supplier_name,contact,email,phone)
values
('Distribuidora ABC','João','joao@abc.com','(11)2222-3333'),
('Fornecedor XYZ','Luiza','luiza@xyz.com','(11)2222-4444');

-- products
insert into product (sku,name,description,unit_price)
values
('SKU-001','Coxinha Tradicional','Salgado assado',5.50),
('SKU-002','Hamburguer simples','Pão,carne,queijo',12.00),
('SKU-003','refrigerante 350ml','Bebida lata',4.00);

-- product-supplier
insert into product_supplier (product_id,supplier_id,supplier_sku,lead_time_days)
values
(1,1,'DABC-001',2),
(2,1,'DABC-002',4),
(3,2,'DABC-003',3);

-- stock
insert into stock (product_id,quantity,min_quantity)
values
(1,100,10),
(2,50,5),
(3,200,20);

-- payment method
insert into payment_method (customer_id,method_type,provider,last_digits)
values
(1,'pix','ana-pix',null),
(1,'credit-card','visa',1234),
(2,'boleto','banco x',null);

-- order + items + delivery
insert into `order` (customer_id,seller_id,payment_method_id,status,total_amount)
values
(1,1,1,'paid',27.50),
(2,2,3,'shipped',48.00);

insert into order_item (order_id,product_id,quantity,unint_price,discount)
values
(1,1,2,5.50,0.00),
(1,3,4,4.00,0.00),
(2,2,4,12.00,0.00);

insert into delivery (order_id,shipping_provider,tracking_code,status,shipped_at)
values
(1,'Transportadora A','TRK-001','DELIVERED','2025-10-15 10:00:00'),
(2,'Transportadora B','TRK-002','IN-TRANSIT','2025-10-20 14:30:00');

update `order` o
set total_amount = (
select ifnull(sum(oi.quantity*oi.unit_price - oi.discount),0)
from order_item oi where oi.order_id = o.id
)

where exists (select 1 from order_item oi where oi.order_id = o.id);

insert into activity_log (entity,entity_id,action)
values ('order','1','created'),('order','2','created');

select c.id as customer_id, coalesce(p.first_name,cmp.company_name) as cusotmer_name, count(o.id) as total_orders
from customer c
left join `order` o on o.customer_id = c.id
left join person p on c.person_id = p.id
left join company cmp on c.company_id = cmp.id
group by c.id
order by total_orders desc;

select o.id, o.order_date, o.total_amount, coalesce(p.first_name,cmp.company_name) as customer_name
from `order` o
join customer c on o.customer_id = c.id
left join person p on c.person_id = p.id
left join company cmp on c.company_id = cmp.id
where o.total_amount > 30
order by o.total_amount desc;

select oi.id, oi.order_id, pr.name as product_name, oi.quantity,oi.unit_price,
(oi.quantity * oi.unit_price - oio.discount) as total_item
from order_item oi
join product pr on oi.product_id = pr.id
where (oi.quantity * oi.unit_price - oi.discount) > 20
order by total_item desc;

select pr.id as product_id, pr.name as product_name, s.id as supplier_id, s.suppleir_name
from product pr
join product_supplier ps on ps.product_id = pr.id
join supplier s on s.id = ps.supplier_id
order by pr.name, s.supplier_name;

select se.id as seller_id, coalesce(p.first_name, cmp.company_name) as seller_name, sup.id as supplier_id, sup.supplier_name
from seller se
left join person p on se.person_id = p.id
left join company cmp on se.company_id = cmp.id
left join supplier sup on (sup.supplier_name = coalesce(p.first_name,cmp.company_name))
where sup.id is not null;

select pr.sku, pr.name as product_name, s.supplier_name, st.quantity as stock_quantity
from product pr
left join product_supplier ps on ps.product_id = pr.id
left join supplier s on s.id = ps.supplier_id
left join stock st on st.product_id = pr.id
order by pr.name;

select c.id as customer_id, coalesce(p.first_name,cmp.company_name) as customer_name, count(o.id) as orders_count, sum(o.total_amount) as total_spend
from customer c 
left join `order` o on o.customer_id = c.id
left join person p on c.person_id = p.id
left join company cmp on c.company_id = cmp.id
group by c.id
having count(o.id) > 0
order by total_spend desc;

select o.id as order_id, coalesce(p.first_name,cmp.company_name) as customer, o.status as order_status, d.tracking_code, d.status as delivery_status
from `order` o
left join delivery d on d.order_id = o.id
left join customer c on o.customer_id = c.id
left join company cmp on c.company_id = cmp.id
order by o.order_date desc;

select pr.id as porduct_id, pr.name, sum(oi.quantity) as total_sold, sum(oi.quamtity * oi.unit_price - oi.discount) as revenue
from order_item oi
join product pr on pr.id = oi.product_id
group by pr.id
order by total_sold desc;