-- -----------------------------------------------------
-- Schema hidroponia
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `hidroponia` ;

-- -----------------------------------------------------
-- Schema hidroponia
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hidroponia` DEFAULT CHARACTER SET utf8 ;
USE `hidroponia` ;

-- -----------------------------------------------------
-- Table `hidroponia`.`Person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Person` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Person` (
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `first_name` VARCHAR(70) NULL,
  `last_name` VARCHAR(45) NULL,
  `telephone` INT NULL,
  `address` VARCHAR(50) NULL,
  `email` VARCHAR(50) NULL,
  `username` VARCHAR(50) NULL,
  `password` VARCHAR(50) NULL,
  `image` LONGBLOB NULL,
  `role` VARCHAR(10) NULL COMMENT 'Consumidor o Cultivador',
  PRIMARY KEY (`id_person`, `type_ID`))
ENGINE = InnoDB
COMMENT = 'Tabla maestra de personas';


-- -----------------------------------------------------
-- Table `hidroponia`.`Category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Category` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Category` (
  `id_category` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  `description` VARCHAR(500) NULL,
  PRIMARY KEY (`id_category`))
ENGINE = InnoDB
COMMENT = 'Se indican las categorias de los productos hidroponicos';


-- -----------------------------------------------------
-- Table `hidroponia`.`Product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Product` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Product` (
  `id_product` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  `description` VARCHAR(500) NULL,
  `price` DECIMAL(10) NULL,
  `image` LONGBLOB NULL,
  `id_category` INT NOT NULL,
  PRIMARY KEY (`id_product`, `id_category`),
  INDEX `fk_Producto_Categoria1_idx` (`id_category` ASC),
  CONSTRAINT `fk_Producto_Categoria1`
    FOREIGN KEY (`id_category`)
    REFERENCES `hidroponia`.`Category` (`id_category`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tabla maestra para los productos existentes en el sistema';


-- -----------------------------------------------------
-- Table `hidroponia`.`Client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Client` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Client` (
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `kind_person` VARCHAR(15) NULL COMMENT 'Juridica o Natrual',
  `nit` VARCHAR(20) NULL,
  `description` VARCHAR(45) NULL,
  `url` VARCHAR(45) NULL,
  INDEX `fk_Client_Person1_idx` (`id_person` ASC, `type_ID` ASC),
  PRIMARY KEY (`id_person`, `type_ID`),
  CONSTRAINT `fk_Client_Person1`
    FOREIGN KEY (`id_person` , `type_ID`)
    REFERENCES `hidroponia`.`Person` (`id_person` , `type_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'En esta tabla se registran las personas como clientes';


-- -----------------------------------------------------
-- Table `hidroponia`.`Order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Order` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Order` (
  `id_order` INT NOT NULL,
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `total` DECIMAL(20) NULL,
  `application_date` DATE NULL,
  PRIMARY KEY (`id_order`, `id_person`, `type_ID`),
  INDEX `fk_Order_Client1_idx` (`id_person` ASC, `type_ID` ASC),
  CONSTRAINT `fk_Order_Client1`
    FOREIGN KEY (`id_person` , `type_ID`)
    REFERENCES `hidroponia`.`Client` (`id_person` , `type_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tabla donde se guarda la solicitud de compra por parte del cliente';


-- -----------------------------------------------------
-- Table `hidroponia`.`Order_has_Product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Order_has_Product` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Order_has_Product` (
  `id_product` INT NOT NULL,
  `id_order` INT NOT NULL,
  `quantity` INT NULL,
  `unitPrice` DECIMAL(20) NULL,
  PRIMARY KEY (`id_product`, `id_order`),
  INDEX `fk_LineaCompra_Producto1_idx` (`id_product` ASC),
  INDEX `fk_LineaCompra_Pedido1_idx` (`id_order` ASC),
  CONSTRAINT `fk_LineaCompra_Producto1`
    FOREIGN KEY (`id_product`)
    REFERENCES `hidroponia`.`Product` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LineaCompra_Pedido1`
    FOREIGN KEY (`id_order`)
    REFERENCES `hidroponia`.`Order` (`id_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Permite relacionar que productos solicito el usuario al momento de realizar su cotizacion';


-- -----------------------------------------------------
-- Table `hidroponia`.`Cultivator`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Cultivator` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Cultivator` (
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `birth_day` DATE NULL,
  `gender` VARCHAR(1) NULL,
  PRIMARY KEY (`id_person`, `type_ID`),
  CONSTRAINT `fk_Cultivator_Person1`
    FOREIGN KEY (`id_person` , `type_ID`)
    REFERENCES `hidroponia`.`Person` (`id_person` , `type_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'En esta tabla se registran las personas como cultivadores';


-- -----------------------------------------------------
-- Table `hidroponia`.`Calification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Calification` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Calification` (
  `id_calification` INT NOT NULL,
  `id_order` INT NOT NULL,
  `score` INT NULL,
  `comment` VARCHAR(200) NULL,
  PRIMARY KEY (`id_calification`, `id_order`),
  INDEX `fk_Calificacion_Pedido1_idx` (`id_order` ASC),
  CONSTRAINT `fk_Calificacion_Pedido1`
    FOREIGN KEY (`id_order`)
    REFERENCES `hidroponia`.`Order` (`id_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Se registra el puntaje de cada compra hecha por el cliente';


-- -----------------------------------------------------
-- Table `hidroponia`.`Cultivator_has_Product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Cultivator_has_Product` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Cultivator_has_Product` (
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `id_product` INT NOT NULL,
  `availability` INT NULL,
  `update_date` DATE NULL COMMENT 'Tabla para actualizar la disponibilidad de cada producto',
  PRIMARY KEY (`id_person`, `type_ID`, `id_product`),
  INDEX `fk_Cultivator_has_Product_Cultivator1_idx` (`id_person` ASC, `type_ID` ASC),
  INDEX `fk_Cultivator_has_Product_Product1_idx` (`id_product` ASC),
  CONSTRAINT `fk_Cultivator_has_Product_Cultivator1`
    FOREIGN KEY (`id_person` , `type_ID`)
    REFERENCES `hidroponia`.`Cultivator` (`id_person` , `type_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cultivator_has_Product_Product1`
    FOREIGN KEY (`id_product`)
    REFERENCES `hidroponia`.`Product` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Esta tabla permite conocer cuales productos estan cultivando los cultivadores, ademas de saber su disponibilidad';


-- -----------------------------------------------------
-- Table `hidroponia`.`Dispatch`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Dispatch` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Dispatch` (
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `id_order` INT NOT NULL,
  `dispatch_date` DATE NULL,
  PRIMARY KEY (`id_person`, `type_ID`, `id_order`),
  INDEX `fk_Despacho_Pedido1_idx` (`id_order` ASC),
  INDEX `fk_Dispatch_Cultivator1_idx` (`id_person` ASC, `type_ID` ASC),
  CONSTRAINT `fk_Despacho_Pedido1`
    FOREIGN KEY (`id_order`)
    REFERENCES `hidroponia`.`Order` (`id_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dispatch_Cultivator1`
    FOREIGN KEY (`id_person` , `type_ID`)
    REFERENCES `hidroponia`.`Cultivator` (`id_person` , `type_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'se guardan los datos de quien fue el encargado de atender la orden de compra';


-- -----------------------------------------------------
-- Table `hidroponia`.`Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hidroponia`.`Account` ;

CREATE TABLE IF NOT EXISTS `hidroponia`.`Account` (
  `id_account` INT NOT NULL,
  `id_person` INT NOT NULL,
  `type_ID` VARCHAR(3) NOT NULL,
  `type_account` VARCHAR(45) NULL COMMENT 'Ahorro, Corriente, Credito',
  `number` INT NULL,
  `name_bank` VARCHAR(45) NULL,
  PRIMARY KEY (`id_account`, `id_person`, `type_ID`),
  INDEX `fk_Account_Person1_idx` (`id_person` ASC, `type_ID` ASC),
  CONSTRAINT `fk_Account_Person1`
    FOREIGN KEY (`id_person` , `type_ID`)
    REFERENCES `hidroponia`.`Person` (`id_person` , `type_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Guarda informacion bancaria para recibir/pagar las ordenes de compra';