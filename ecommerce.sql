-- Criação do banco de dados para o cenário de E-commerce 
create database ecommerce;
use ecommerce;
drop database ecommerce;

-- Criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(15),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(60),
    constraint unique_cpf_client unique(CPF)
);

alter table clients auto_increment=1;
-- desc clients;
-- Criar tabela produto
-- Size equivale a dimensão do produto
-- Assessment é avaliação em Inglês
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(30),
    Classification_kids bool default false,
    Category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    Assessment float default 0,
    Size varchar(10)
);

alter table product auto_increment=1;
-- desc product;

-- Criar tabela pagamentos
create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois Cartões','PIX'),
	limitAvailable float,
	primary key(idClient, idPayment)
);

-- Criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
	orderDescription varchar(255),
    Shipping float default 10,
    paymentCash boolean default false,
    constraint fk_orders_client foreign key (idOrderClient) 
    references clients (idClient)
);

alter table orders auto_increment=1;
-- drop table orders;
-- desc orders;

-- Criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
	storageLocation varchar(255),
    Quantity int default 0
);

alter table productStorage auto_increment=1;
-- desc productStorage;

-- Criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    Contact char(11) not null,
    constraint unique_supplier unique(CNPJ)
);

alter table supplier auto_increment=1;
-- desc supplier;

-- Criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not null,
    abstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    Location varchar(255),
    Contact char(11) not null,
    constraint unique_cnpj_seller unique(CNPJ),
    constraint unique_cpf_seller unique(CPF)
);

alter table seller auto_increment=1;
-- desc seller;

-- Criar tabela produto por vendedor
create table productSeller(
	idPseller int,
    idProduct int,
	prodQuantity int default 1,
	primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller)
    references seller(idSeller),
    constraint fk_product_product foreign key (idProduct)
    references product(idProduct)
);

-- desc productSeller;

-- Criar tabela puduto venda
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuatity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key(idPOproduct) references product(idProduct),
	constraint fk_productorder_product foreign key(idPOorder) references orders(idOrder)
);

-- desc productOrder;

create table storageLocation(
	idLproduct int,
    idLstorage int,
    Location varchar(255) not null,
    primary key(idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct)
    references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage)
    references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;

-- desc storageLocation;

-- show databases;
-- show tables;

-- use information_schema;
-- show tables;
-- desc referential_constraints;
-- select * from referential_constraints where constraint_schema = 'ecommerce';

-- Inserção de dados e queries

show tables;
-- idClient, Fname, Minit, Lname, Address
insert into clients (Fname, Minit, Lname, CPF, Address)
	values ('Maria', 'M', 'Silva', 12346789, 'Rua Silva da prata 29, Carangola - Cidade das Flores'),
		   ('Matheus', 'O', 'Pimentel', 987654321, 'Rua alameda 289, Centro - Cidade das Flores'),
		   ('Ricardo', 'F', 'Silva', 45678913, 'Avenida Alameda Vinha 1009, Centro - Cidade das Flores'),
           ('Julia', 'S', 'França', 789123456, 'Rua Laranjeiras 861, Centro - Cidade das Flores'),
		   ('Roberta', 'G', 'Assis', 98745631, 'Avenida Koller 19, Centro - Cidade das Flores'),
		   ('Isabela', 'M', 'Cruz', 954789123, 'Rua Alameda das Flores 28, Centro - Cidade das Flores');

-- idProduct, Pname, classification_kids boolean, category('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'), avaliação
-- size
insert into product(Pname, Classification_kids, Category, Assessment, Size) values
				   ('Fone de ouvido', false, 'Eletrônico', '4', null),
				   ('Barbie Elsa', true, 'Brinquedos', '3', null),
				   ('Body Carters', true, 'Vestimenta', '5', null),
                   ('Microfone Vedo - Youtuber', False, 'Eletrônico', '4', null),
                   ('Sofá retrátil', False, 'Móveis', '3', '3x57x80'),
                   ('Farinha de arroz', False, 'Alimentos', '2', null),
                   ('Fire Stick Amazon', False, 'Eletrônico', '3', null);

-- idOrder, idOrderClient, orderStatus, orderDescription, Shipping, paymentCash
insert into orders(idOrderClient, orderStatus, orderDescription, Shipping, paymentCash) values
				  (1, default, 'compra via aplicativo', null,1),	
			      (2, default, 'compra via aplicativo', 50, 0),
                  (3, 'Confirmado', null, null, 1),
                  (4, default, 'compra via web site', 150, 0);

delete from orders where idOrderClient in (1,2,3,4);
select * from orders;
-- idPOproduct, idPOorder, poQuatity, poStatus
insert into productOrder (idPOproduct, idPOorder, poQuatity, poStatus) values
						 (1,5,2,null),
                         (2,5,1,null),
                         (3,6,1,null);

-- storageLocation,quantity
insert into productStorage (storageLocation,quantity) values 
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);

-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
						 (1,2,'RJ'),
                         (2,6,'GO');

-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values 
							('Almeida e filhos', 123456789123456,'21985474'),
                            ('Eletrônicos Silva',854519649143457,'21985484'),
                            ('Eletrônicos Valma', 934567893934695,'21975474');
                            
-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
						 (1,1,500),
                         (1,2,400),
                         (2,4,633),
                         (3,3,5),
                         (2,5,10);

-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values 
						('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
					    ('Botique Durgas',null,null,123456783,'Rio de Janeiro', 219567895),
						('Kids World',null,456789123654485,null,'São Paulo', 1198657484);

-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idProduct, prodQuantity) values 
						 (1,6,80),
                         (2,7,10);

select * from productSeller;

select count(*) from clients;
select * from clients as c, orders as o where c.idClient = idOrderClient;

select concat(Lname, ' ',idOrder) as Client, idOrder as Request, orderStatus as Order_Status from clients as c, orders as o where c.idClient = idOrderClient;

insert into orders(idOrderClient, orderStatus, orderDescription, Shipping, paymentCash) values
				  (2, default, 'compra via aplicativo', null,1);	

select * from clients as c, orders as o 
	where c.idClient = idOrderClient
    group by idOrder;

-- Recuperação de pedido com produto associado
select * from clients as c
	inner join orders as o on c.idClient = o.idOrderClient
    inner join productOrder as p on p.idPOorder = o.idOrder;

-- Recuperação quantso pedidos foram realizados pelos clientes
select c.idClient, Fname, count(*) as Number_Orders from clients as c
	inner join orders as o on c.idClient = o.idOrderClient
    group by idClient; 


















