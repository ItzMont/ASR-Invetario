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
    `tiempoIni` TIMESTAMP NOT NULL,
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
)