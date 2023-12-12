/***********************************************
** DATA ENGINEERING
** File:   Final_Project_DDL
** Desc:   Creating the Chicago Food Inspections Dimensional model
** Auth:   Stephanie Smithson
** Date:   11/26/2023
************************************************/

# CREATE SCHEMA
CREATE SCHEMA final_project;
USE final_project;

# CREATE CONTAINER FOR RAW DATA
CREATE TABLE raw_data (
    `inspection_id` VARCHAR(10) NOT NULL,
    `business_name` VARCHAR(255) NOT NULL,
    `familiar_name` VARCHAR(255) NOT NULL,
    `license` VARCHAR(10) NOT NULL,
    `facility_type_name` VARCHAR(100) NOT NULL,
    `risk_desc` VARCHAR(50) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(50),
    `state` VARCHAR(2) NOT NULL,
    `zip_code` VARCHAR(5),
    `inspection_date` VARCHAR(20) NOT NULL,
    `inspection_type` VARCHAR(50) NOT NULL,
    `result` VARCHAR(50) NOT NULL,
    `violations` VARCHAR(20000),
    `latitude` VARCHAR(20),
    `longitude` VARCHAR(20),
    `coordinates` VARCHAR(100) NULL,
    PRIMARY KEY (`inspection_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

# CREATE RISK TABLE
CREATE TABLE risk (
    `risk_code` INT NOT NULL AUTO_INCREMENT,
    `risk_desc` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`risk_code`)
);

# CREATE FACILITY TYPE TABLE
CREATE TABLE facility_type (
    `facility_type_code` INT NOT NULL AUTO_INCREMENT,
    `facility_type_name` VARCHAR(100) NOT NULL,
    PRIMARY KEY(`facility_type_code`)
);

# CREATE ADDRESS TABLE
CREATE TABLE address (
    `address_id` INT NOT NULL AUTO_INCREMENT,
    `address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(50) NOT NULL,
    `state` VARCHAR(2) NOT NULL,
    `zip_code` INT(5) NULL,
    `longitude` DECIMAL(16,14) NULL,
    `latitude` DECIMAL(16,14) NULL,
    PRIMARY KEY(`address_id`)
);

# CREATE FACILITY TABLE
CREATE TABLE facility (
    `facility_id` INT NOT NULL AUTO_INCREMENT,
    `business_name` VARCHAR(255) NOT NULL,
    `familiar_name` VARCHAR(255) NOT NULL,
    `facility_type_code` INT(6) NOT NULL,
    `address_id` INT(6) NOT NULL,
    PRIMARY KEY(`facility_id`),
    FOREIGN KEY(`facility_type_code`) 
		REFERENCES `final_project`.`facility_type` (`facility_type_code`)
        ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	FOREIGN KEY(`address_id`) 
		REFERENCES `final_project`.`address` (`address_id`)
        ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

# CREATE INSPECTION TYPE TABLE
CREATE TABLE inspection_type (
    `inspection_type_code` INT(2) NOT NULL AUTO_INCREMENT,
    `inspection_type_desc` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`inspection_type_code`)
);

# CREATE INSPECTION TABLE
CREATE TABLE inspection (
    `inspection_id` INT(10) NOT NULL AUTO_INCREMENT,
    `facility_id` INT(6) NOT NULL,
    `license` INT NULL,
    `risk_code` INT NOT NULL,
    `inspection_date` DATE NOT NULL,
    `inspection_type_code` INT(2) NOT NULL,
    `result` VARCHAR(50) NOT NULL,
    `violations` TEXT(20000),
    PRIMARY KEY(`inspection_id`),
    FOREIGN KEY(`facility_id`) 
		REFERENCES `final_project`.`facility` (`facility_id`)
        ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	FOREIGN KEY(`risk_code`) 
		REFERENCES `final_project`.`risk` (`risk_code`)
        ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	FOREIGN KEY(`inspection_type_code`) 
		REFERENCES `final_project`.`inspection_type` (`inspection_type_code`)
        ON DELETE NO ACTION
		ON UPDATE NO ACTION
);