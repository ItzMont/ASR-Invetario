drop database inv;
create database inv;
use inv;

CREATE TABLE `products` (
  `product_id` int not null PRIMARY KEY auto_increment,
  `inventory_num` bigint not null,
  `serial_num` bigint,
  `color` varchar(45),
  `description` text,
  `date_modified` date,
  `brand` varchar(45),
  `model` varchar(45)
);

CREATE TABLE `area` (
  `area_id` int not null PRIMARY KEY auto_increment,
  `area` varchar(45),
  `product_id` int
);

CREATE TABLE `status` (
  `status_id` int not null PRIMARY KEY auto_increment,
  `state` varchar(45),
  `product_id` int
);

CREATE TABLE `responsable` (
  `responsable_id` int not null PRIMARY KEY auto_increment,
  `docente_id` int,
  `docente_name` varchar(45),
  `product_id` int
);

CREATE TABLE `user` (
  `user_id` int not null PRIMARY KEY auto_increment,
  `name` varchar(45),
  `user_name` varchar(45),
  `passwd` varchar(45),
  `fdn` date,
  `product_id` int
);

CREATE TABLE `roles` (
  `id_role` int not null PRIMARY KEY auto_increment,
  `role_type` varchar(45),
  `user_id` int
);

ALTER TABLE `area` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) on delete cascade;

ALTER TABLE `responsable` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) on delete cascade;

ALTER TABLE `status` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) on delete cascade;

ALTER TABLE `roles` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) on delete cascade;

ALTER TABLE `user` ADD FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) on delete cascade;


insert into products(inventory_num, serial_num,color,description, date_modified, brand, model) 
  values (123456,43434,'negro',"mesa de salon", "2020-02-03",'oficina','QWERTY');
  
insert into area(area,product_id) values ("laboratorio",'1');

SELECT * FROM products INNER JOIN area ON products.product_id=area.product_id;
