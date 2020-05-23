CREATE TABLE IF NOT EXISTS `roles` (
  `idrol` INT NOT NULL AUTO_INCREMENT,
  `role_type` VARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idrol`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `usuarios` (
    `idusuario` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `apellidoP` VARCHAR(50) NOT NULL,
    `apellidoM` VARCHAR(50) NOT NULL,
    `claveIdentificacion` VARCHAR(20) NOT NULL UNIQUE,
    `contraASR` VARCHAR(100) NOT NULL,
    `fdn` DATE NULL,
    `idrol` INT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idusuario`),
    FOREIGN KEY (`idrol`)
    REFERENCES `roles` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `areas` (
  `idarea` INT NOT NULL AUTO_INCREMENT,
  `area` VARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idarea`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `ubicaciones` (
  `idubicacion` INT NOT NULL AUTO_INCREMENT,
  `edificio` VARCHAR(45) NOT NULL,
  `salon` VARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idubicacion`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `productos` (
    `idproducto` INT NOT NULL AUTO_INCREMENT,
    `inventory_num` BIGINT NOT NULL,
    `serial_num` BIGINT NOT NULL,
    `color` VARCHAR(45) NULL,
    `descripcion` TEXT NULL,
    `date_modified` DATE NULL,
    `brand` VARCHAR(45) NULL,
    `model` VARCHAR(45) NULL,
    `idarea` INT NULL,
    `idubicacion` INT NULL,
    `idtipoEstado` INT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idproducto`),
    FOREIGN KEY (`idarea`)
    REFERENCES `areas` (`idarea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idubicacion`)
    REFERENCES `ubicaciones` (`idubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idtipoEstado`)
    REFERENCES `tipoEstados` (`idtipoEstado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `responsables` (
  `idresponsable` INT NOT NULL AUTO_INCREMENT,
  `docente_id` INT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellidoP` VARCHAR(50) NOT NULL,
  `apellidoM` VARCHAR(50) NOT NULL,
  `claveDocente` VARCHAR(20) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idresponsable`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `tipoEstados` (
  `idtipoEstado` INT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(45) NOT NULL,
  `estado` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idtipoEstado`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `estadosDeProductos` (
    `idestadosDeProductos` INT NOT NULL AUTO_INCREMENT,
    `idproducto` INT NULL,
    `idtipoEstado` INT NULL,
    `comentario` VARCHAR(45) NULL,
    `fecha` DATE NOT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idestadosDeProductos`),
    FOREIGN KEY (`idproducto`)
    REFERENCES `productos` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idtipoEstado`)
    REFERENCES `tipoEstados` (`idtipoEstado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `responsableDeProducto` (
    `idresponsableDeProducto` INT NOT NULL AUTO_INCREMENT,
    `idresponsable` INT NULL,
    `idproducto` INT NULL,
    `fechaInicio` DATE NOT NULL,
    `fechaFin` DATE NOT NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idresponsableDeProducto`),
    FOREIGN KEY (`idresponsable`)
    REFERENCES `responsables` (`idresponsable`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `idproducto`
    FOREIGN KEY (`idproducto`)
    REFERENCES `productos` (`idproducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `sesiones` (
    `idsesion` INT NOT NULL AUTO_INCREMENT,
    `idusuario` INT NOT NULL,
    `tiempoIni` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    `tiempoFin` TIMESTAMP NULL,
    `estado` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`idsesion`),
    FOREIGN KEY (`idusuario`)
    REFERENCES `usuarios` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

---------------------------------STORED PROCEDURES

-----FOR LOGIN
DELIMITER $$

CREATE PROCEDURE GetUserForLogin(
  userName VARCHAR(20)
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

CREATE PROCEDURE GetUserByUserName(
  userNameParam VARCHAR(20)
)
BEGIN
  START TRANSACTION;
  SELECT
    `idusuario`,
    `nombre`,
    `apellidoP`,
    `apellidoM`,
    `claveIdentificacion`,
    `fdn`,
    `role_type`
  FROM
    `usuarios` AS U LEFT JOIN `roles` AS R ON U.`idrol` = R.`idrol`
  WHERE
    `claveIdentificacion` = userNameParam AND 
    U.`estado` = 1;
  COMMIT;
END $$
DELIMITER ;


DELIMITER $$

CREATE PROCEDURE CreateSession(
  iduser INT,
  OUT idsession INT
)
BEGIN
  CALL LogOut(iduser);

  INSERT INTO `sesiones`(
    `idusuario`
  )
  VALUES(
    iduser
  );

  SET idsession = LAST_INSERT_ID();

  SELECT idsession AS idsession; 
  
  COMMIT;
END $$
DELIMITER ;

-----FOR LOGOUT
DELIMITER $$

CREATE PROCEDURE LogOut(
  iduserParam INT
)
BEGIN

  UPDATE `sesiones`
  SET 
    `estado` = 0,
    `tiempoFin`= CURRENT_TIMESTAMP()
  WHERE 
    `idusuario` = iduserParam AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

-----FOR VALIDATE USER
DELIMITER $$

CREATE PROCEDURE ValidatedSessionUser(
  idsesion INT,
  iduser INT
)
BEGIN
  START TRANSACTION;
  SELECT
    `idsesion`
  FROM
    `sesiones`
  WHERE
    `idsesion` = idsesion AND 
    `idusuario` = iduser AND 
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

-----FUNCTIONS
DELIMITER $$

CREATE PROCEDURE GetDashAdmin()
BEGIN
  START TRANSACTION;
  SELECT
    `idproducto`,
    `inventory_num`,
    `serial_num`,
    `color`,
    `descripcion`,
    `date_modified`,
    `brand`,
    `model`,
    P.`estado`,
    `area`,
    `edificio`,
    `salon`
  FROM
    `productos` AS P 
    LEFT JOIN `areas` AS A ON P.`idarea` = A.`idarea`
    LEFT JOIN `ubicaciones` AS U ON P.`idubicacion` = U.`idubicacion`
  WHERE
    P.`estado` = 1 AND
    A.`estado` = 1 AND
    U.`estado` = 1;
  COMMIT;
END $$
DELIMITER ;

-----CRUD "INVITADO"
DELIMITER $$

CREATE PROCEDURE CreateInvitado(
  nombreParam VARCHAR(50),
  apellidoPParam VARCHAR(50),
  apellidoMParam VARCHAR(50),
  claveIdentificacionParam VARCHAR(20),
  contraASRParam VARCHAR(100),
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

CREATE PROCEDURE UpdateInvitado(
  idusuarioParam INT,
  nombreParam VARCHAR(50),
  apellidoPParam VARCHAR(50),
  apellidoMParam VARCHAR(50),
  claveIdentificacionParam VARCHAR(20),
  contraASRParam VARCHAR(100),
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
    `fdn` = fdnParam
  WHERE `idusuario` = idusuarioParam AND
    `id_rol` = 2 AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$

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

CREATE PROCEDURE CreateProducto(
  inventory_numParam BIGINT,
  serial_numParam BIGINT,
  colorParam VARCHAR(45),
  descripcionParam TEXT,
  date_modifiedParam DATE,
  brandParam VARCHAR(45),
  modelParam VARCHAR(45),
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

CREATE PROCEDURE CreateProductoAux(
  inventory_numParam BIGINT,
  serial_numParam BIGINT,
  colorParam VARCHAR(45),
  brandParam VARCHAR(45)
)
BEGIN
  START TRANSACTION;
  INSERT INTO `productos`(
    `inventory_num`,
    `serial_num`,
    `color`,
    `date_modified`,
    `brand`,
    `idarea`,
    `idubicacion`
  )VALUES(
    inventory_numParam,
    serial_numParam,
    colorParam,
    CURRENT_TIMESTAMP(),
    brandParam,
    1,
    1
  );
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE UpdateProductoAux(
  idproductoParam INT,
  inventory_numParam BIGINT,
  serial_numParam BIGINT,
  colorParam VARCHAR(45),
  brandParam VARCHAR(45)
)
BEGIN
  START TRANSACTION;
  UPDATE `productos`
  SET
    `inventory_num` = inventory_numParam,
    `serial_num` = serial_numParam,
    `color` = colorParam,
    `date_modified` = CURRENT_TIMESTAMP(),
    `brand` = brandParam
  WHERE 
    `idproducto` = idproductoParam AND
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE UpdateProducto(
  idproductoParam INT,
  inventory_numParam BIGINT,
  serial_numParam BIGINT,
  colorParam VARCHAR(45),
  descripcionParam TEXT,
  date_modifiedParam DATE,
  brandParam VARCHAR(45),
  modelParam VARCHAR(45),
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
    `area`,
    `edificio`,
    `salon`
  FROM
    `productos` AS P 
    LEFT JOIN `areas` AS A ON P.`idubicacion` = A.`idarea`
    LEFT JOIN `ubicaciones` AS U ON P.`idarea` = U.`idubicacion`
  WHERE
    `idproducto` = idproductoParam AND
    P.`estado` = 1;
  COMMIT;
END $$
DELIMITER ;

DELIMITER $$

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

-----CRUD "AREAS"
DELIMITER $$

CREATE PROCEDURE GetAllAreas()
BEGIN
  START TRANSACTION;
  SELECT 
    `idarea`,
    `area`
  FROM
    `areas`
  WHERE
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;

-----CRUD "UBICACIONES"
DELIMITER $$

CREATE PROCEDURE GetAllUbicaciones()
BEGIN
  START TRANSACTION;
  SELECT 
    `idubicacion`,
    `edificio`,
    `salon`
  FROM
    `ubicaciones`
  WHERE
    `estado` = 1;
  COMMIT;
END $$
DELIMITER ;
---------------------------------LOAD ROLES
INSERT INTO `roles`(
    `role_type`
)
VALUES(
    "ADMINISTRADOR"
),
(
    "INVITADO"
);


INSERT INTO `usuarios`(
  `claveIdentificacion`,
  `contraASR`,
  `nombre`,
  `apellidoP`,
  `apellidoM`
)
VALUES(
  "patricia@gmail.com",
  "$2y$15$Mp00GUu/xBJpPKWPPJsVx.oWmOBl2H05/lTlC.EZbJ1FoqjQIxT1G",
  "patricia",
  "silva",
  "sanchez"
);


INSERT INTO areas(
  area
)VALUES(
  "AREA_1"
),(
  "AREA_2"
),(
  "AREA_3"
),(
  "AREA_4"
);

INSERT INTO ubicaciones(
  edificio,
  salon
)VALUES(
  "CCO1",
  "101"
),(
  "CCO1",
  "102"
),(
  "CCO2",
  "ASR"
),(
  "CCO2",
  "Bases de Datos"
),(
  "CCO2",
  "Aztli"
);

INSERT INTO tipoEstados(
  tipo
)VALUES(
  "BAJA"
),(
  "REPARACION"
),(
  "DISPONIBLE"
)



INSERT INTO productos(
  inventory_num,
  serial_num,
  color,
  descripcion,
  brand,
  model,
  idubicacion,
  idarea,
  idtipoEstado
)VALUES(
  "000100",
  "000050",
  "NEGRO",
  "CAÑON EN BUENAS CONDICIONES",
  "SAMSUNG",
  "DE LUJO",
  5,
  1,
  1
),(
  "000200",
  "000060",
  "BLANCO",
  "CABLE VGA",
  "DESCONOCIDO",
  "SENCILLO",
  3,
  3,
  2
),(
  "000400",
  "000070",
  "MARRON",
  "APUNTADOR LASER",
  "SAMSUNG",
  "DE LUJO",
  3,
  1,
  2
),(
  "000700",
  "000100",
  "NEGRO",
  "CAÑON DEFECTUOSO",
  "LG",
  "NORMAL",
  3,
  1,
  3
),(
  "000800",
  "000150",
  "NEGRO",
  "CABLE HDMI",
  "DESCONOCIDO",
  "NORMAL",
  4,
  2,
  3
);



