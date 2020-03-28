CREATE DATABASE IF NOT EXISTS `colaw` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `colaw`;

CREATE TABLE IF NOT EXISTS  rol(
    id_rol INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombreRol VARCHAR(20) NOT NULL,
    valuePermission INT NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS  usuario(
    id_usuario INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellidoP VARCHAR(20) NOT NULL,
    apellidoM VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    pass VARCHAR(100) NOT NULL,
    fechaNac DATE NOT NULL,
    rol_id INT(11),
    FOREIGN KEY (rol_id)
    REFERENCES rol(id_rol)
    ON DELETE SET NULL
	ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS  cliente(
    id_cliente INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    metodoPago VARCHAR(25) NOT NULL,
    usuario_id INT(11),
    FOREIGN KEY (usuario_id)
    REFERENCES usuario(id_usuario)
    ON DELETE SET NULL
	ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS  abogado(
    id_abogado INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cuentaBanco INT,
    costoBase DOUBLE,
    descripcion TEXT,
    cedulaPro INT,
    usuario_id INT(11),
    FOREIGN KEY (usuario_id)
    REFERENCES usuario(id_usuario)
    ON DELETE SET NULL
	ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO rol(
    nombreRol,
    valuePermission
)
VALUES(
    "ADMINISTRADOR",
    0
);
INSERT INTO rol(
    nombreRol,
    valuePermission
)
VALUES(
    "ABOGADO",
    1
);
INSERT INTO rol(
    nombreRol,
    valuePermission
)
VALUES(
    "CLIENTE",
    2
);


INSERT INTO usuario(
    nombre,
    apellidoP,
    apellidoM,
    email,
    pass,
    fechaNac,
    rol_id
)
VALUES(
    "BRYAN",
    "TLATELPA",
    "SILVA",
    "ejemplo@gmail.com",
    "123",
    "2000-01-01",
    1
)