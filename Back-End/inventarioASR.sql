DROP SCHEMA IF EXISTS `inventarioASR`;
CREATE SCHEMA IF NOT EXISTS `inventarioASR` DEFAULT CHARACTER SET utf8 ;
USE `inventarioASR` ;

DROP TABLE IF EXISTS `inventarioASR`.`roles` ;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`roles` (
  `idrol` INT NOT NULL AUTO_INCREMENT,
  `role_type` NVARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idrol`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`usuarios`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`usuarios` (
    `idusuario` INT NOT NULL AUTO_INCREMENT,
    `nombre` NVARCHAR(50) NOT NULL,
    `apellidoP` NVARCHAR(50) NOT NULL,
    `apellidoM` NVARCHAR(50) NOT NULL,
    `claveIdentificacion` NVARCHAR(20) NOT NULL UNIQUE,
    `contraASR` NVARCHAR(100) NOT NULL,
    `fdn` DATE NULL,
    `idrol` INT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idusuario`),
    FOREIGN KEY (`idrol`)
    REFERENCES `inventarioASR`.`roles` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`areas`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`areas` (
  `idarea` INT NOT NULL AUTO_INCREMENT,
  `area` NVARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idarea`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`ubicaciones`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`ubicaciones` (
  `idubicacion` INT NOT NULL AUTO_INCREMENT,
  `edificio` NVARCHAR(45) NOT NULL,
  `salon` NVARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idubicacion`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`productos`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`productos` (
    `idproducto` INT NOT NULL AUTO_INCREMENT,
    `inventory_num` BIGINT NOT NULL,
    `serial_num` BIGINT NOT NULL,
    `color` NVARCHAR(45) NULL,
    `descripcion` TEXT NULL,
    `date_modified` DATE NULL,
    `brand` NVARCHAR(45) NULL,
    `model` NVARCHAR(45) NULL,
    `idarea` INT NULL,
    `idubicacion` INT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idproducto`),
    FOREIGN KEY (`idarea`)
    REFERENCES `inventarioASR`.`areas` (`idarea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idubicacion`)
    REFERENCES `inventarioASR`.`ubicaciones` (`idubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`responsables`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`responsables` (
  `idresponsable` INT NOT NULL AUTO_INCREMENT,
  `docente_id` INT NULL,
  `nombre` NVARCHAR(50) NOT NULL,
  `apellidoP` NVARCHAR(50) NOT NULL,
  `apellidoM` NVARCHAR(50) NOT NULL,
  `claveDocente` VARCHAR(20) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idresponsable`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`tipoEstados`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`tipoEstados` (
  `idtipoEstado` INT NOT NULL AUTO_INCREMENT,
  `tipo` NVARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idtipoEstado`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`estadosDeProductos`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`estadosDeProductos` (
    `idestadosDeProductos` INT NOT NULL AUTO_INCREMENT,
    `idproducto` INT NULL,
    `idtipoEstado` INT NULL,
    `comentario` VARCHAR(45) NULL,
    `fecha` DATE NOT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idestadosDeProductos`),
    FOREIGN KEY (`idproducto`)
    REFERENCES `inventarioASR`.`productos` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idtipoEstado`)
    REFERENCES `inventarioASR`.`tipoEstados` (`idtipoEstado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`responsableDeProducto`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`responsableDeProducto` (
    `idresponsableDeProducto` INT NOT NULL AUTO_INCREMENT,
    `idresponsable` INT NULL,
    `idproducto` INT NULL,
    `fechaInicio` DATE NOT NULL,
    `fechaFin` DATE NOT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idresponsableDeProducto`),
    FOREIGN KEY (`idresponsable`)
    REFERENCES `inventarioASR`.`responsables` (`idresponsable`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `idproducto`
    FOREIGN KEY (`idproducto`)
    REFERENCES `inventarioASR`.`productos` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `inventarioASR`.`sesiones`;
CREATE TABLE IF NOT EXISTS `inventarioASR`.`sesiones` (
    `idsesion` INT NOT NULL AUTO_INCREMENT,
    `idusuario` INT NOT NULL,
    `token` NVARCHAR(150) NOT NULL,
    `tiempoIni` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    `tiempoFin` TIMESTAMP NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idsesion`),
    FOREIGN KEY (`idusuario`)
    REFERENCES `inventarioASR`.`usuarios` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

---------------------------------LOAD ROLES
INSERT INTO `inventarioASR`.`roles`(
    `role_type`
)
VALUES(
    "ADMINISTRADOR"
),
(
    "INVITADO"
);

---------------------------------STORED PROCEDURES

-----FOR LOGIN
DELIMITER $$
DROP PROCEDURE IF EXISTS GetUserForLogin $$
CREATE PROCEDURE GetUserForLogin(
  userName NVARCHAR(20)
)
BEGIN
  START TRANSACTION;
  SELECT
    `contraASR`
  FROM
    `usuarios`
  WHERE
    `claveIdentificacion` = userName AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS InitSession $$
CREATE PROCEDURE InitSession(
  userName NVARCHAR(20)
)
BEGIN
  DECLARE idsession INT DEFAULT -1;
  DECLARE iduser INT DEFAULT -1;

  START TRANSACTION;

  SELECT
    `idusuario`
  INTO iduser
  FROM
    `usuarios`
  WHERE
    `claveIdentificacion` = userName AND
    `estado` = 1;

  INSERT INTO `sesiones`(
    `idusuario`
  )
  VALUES(
    iduser
  );

  SELECT LAST_INSERT_ID() INTO idsession;
  
  SELECT
    *,
    idsession
  FROM
    (
      SELECT
        `idusuario`,
        `nombre`,
        `apellidoP`,
        `apellidoM`,
        `claveIdentificacion`,
        `fdn`,
        `role_type`
      FROM
        `usuarios` AS u LEFT JOIN `roles` AS r ON u.`idrol` = r.`idrol`
      WHERE
        `claveIdentificacion` = userName AND
        `estado` = 1
  )AS myResultQuery;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS CreateSession $$
CREATE PROCEDURE CreateSession(
  idsessionParam INT,
  idusuarioParam INT,
  tokenParam NVARCHAR(150)
)
BEGIN
  START TRANSACTION;
  UPDATE `sesiones`
  SET `token` = tokenParam
  WHERE
    `idsesion` = idsessionParam;
  COMMIT;
END $$
DELIMITER ;

-----CRUD "INVITADO"
DELIMITER $$
DROP PROCEDURE IF EXISTS CreateInvitado $$
CREATE PROCEDURE CreateInvitado(
  nombreParam NVARCHAR(50),
  apellidoPParam NVARCHAR(50),
  apellidoMParam NVARCHAR(50),
  claveIdentificacionParam NVARCHAR(20),
  contraASRParam NVARCHAR(100),
  fdnParam DATE
)
BEGIN
  START TRANSACTION;
  INSERT INTO `usuarios`(
    `nombre`,
    `apellidoP`,
    `apellidoM`,
    `claveIdentificacion`,
    `contraASR`,
    `fdn`,
    `idrol`
  )VALUES(
    nombreParam,
    apellidoPParam,
    apellidoMParam,
    claveIdentificacionParam,
    contraASRParam,
    fdnParam,
    2
  );
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS UpdateInvitado $$
CREATE PROCEDURE UpdateInvitado(
  idusuarioParam INT,
  nombreParam NVARCHAR(50),
  apellidoPParam NVARCHAR(50),
  apellidoMParam NVARCHAR(50),
  claveIdentificacionParam NVARCHAR(20),
  contraASRParam NVARCHAR(100),
  fdnParam DATE
)
BEGIN
  START TRANSACTION;
  UPDATE `usuarios`
  SET
    `nombre` = nombreParam,
    `apellidoP` = apellidoPParam,
    `apellidoM` = apellidoMParam,
    `claveIdentificacion` = claveIdentificacionParam,
    `contraASR` = contraASRParam,
    `fdn` = fdnParam
  WHERE `idusuario` = idusuarioParam AND
    `id_rol` = 2 AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS GetInvitadoByID $$
CREATE PROCEDURE GetInvitadoByID(
  idusuarioParam INT
)
BEGIN
  START TRANSACTION;
  SELECT
    `nombre`,
    `apellidoP`,
    `apellidoM`,
    `claveIdentificacion`,
    `contraASR`,
    `fdn`
  FROM
    `usuarios`
  WHERE
    `idusuario` = idusuarioParam AND
    `id_rol` = 2 AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS GetAllInvitados $$
CREATE PROCEDURE GetAllInvitados()
BEGIN
  START TRANSACTION;
  SELECT
    `nombre`,
    `apellidoP`,
    `apellidoM`,
    `claveIdentificacion`,
    `contraASR`,
    `fdn`
  FROM
    `usuarios`
  WHERE
    `id_rol` = 2 AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS DeactivateInvitado $$
CREATE PROCEDURE DeactivateInvitado(
  idusuarioParam INT
)
BEGIN
  START TRANSACTION;
  UPDATE `usuarios`
  SET
    `estado` = 0
  WHERE 
    `idusuario` = idusuarioParam AND
    `id_rol` = 2 AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

-----CRUD "PRODUCTOS"
DELIMITER $$
DROP PROCEDURE IF EXISTS CreateProducto $$
CREATE PROCEDURE CreateProducto(
  inventory_numParam BIGINT,
  serial_numParam BIGINT,
  colorParam NVARCHAR(45),
  descripcionParam TEXT,
  date_modifiedParam DATE,
  brandParam NVARCHAR(45),
  modelParam NVARCHAR(45),
  idareaParam INT,
  idubicacionParam INT
)
BEGIN
  START TRANSACTION;
  INSERT INTO `productos`(
    `inventory_num`,
    `serial_num`,
    `color`,
    `descripcion`,
    `date_modified`,
    `brand`,
    `model`,
    `idarea`,
    `idubicacion`
  )VALUES(
    inventory_numParam,
    serial_numParam,
    colorParam,
    descripcionParam,
    date_modifiedParam,
    brandParam,
    modelParam,
    idareaParam,
    idubicacionParam
  );
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS UpdateProducto $$
CREATE PROCEDURE UpdateProducto(
  idproductoParam INT,
  inventory_numParam BIGINT,
  serial_numParam BIGINT,
  colorParam NVARCHAR(45),
  descripcionParam TEXT,
  date_modifiedParam DATE,
  brandParam NVARCHAR(45),
  modelParam NVARCHAR(45),
  idareaParam INT,
  idubicacionParam INT
)
BEGIN
  START TRANSACTION;
  UPDATE `productos`
  SET
    `inventory_num` = inventory_numParam,
    `serial_num` = serial_numParam,
    `color` = colorParam,
    `descripcion` = descripcionParam,
    `date_modified` = date_modifiedParam,
    `brand` = brandParam,
    `model` = modelParam,
    `idarea` = idareaParam,
    `idubicacion` = idubicacionParam
  WHERE 
    `idproducto` = idproductoParam AND
    `estado` = 1
  ;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS GetProductoByID $$
CREATE PROCEDURE GetProductoByID(
  idproductoParam INT
)
BEGIN
  START TRANSACTION;
  SELECT
    `inventory_num`,
    `serial_num`,
    `color`,
    `descripcion`,
    `date_modified`,
    `brand`,
    `model`,
    `idarea`,
    `idubicacion`
  FROM
    `productos`
  WHERE
    `idproducto` = idproductoParam AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS GetAllProductos $$
CREATE PROCEDURE GetAllProductos()
BEGIN
  START TRANSACTION;
  SELECT
    `inventory_num`,
    `serial_num`,
    `color`,
    `descripcion`,
    `date_modified`,
    `brand`,
    `model`,
    `idarea`,
    `idubicacion`
  FROM
    `productos`
  WHERE
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS DeactivateProducto $$
CREATE PROCEDURE DeactivateProducto(
  idproductoParam INT
)
BEGIN
  START TRANSACTION;
  UPDATE `productos`
  SET
    `estado` = 0
  WHERE `idproducto` = idproductoParam AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;
