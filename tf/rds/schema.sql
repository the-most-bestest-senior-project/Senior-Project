-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema senior_design
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema senior_design
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `senior_design` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `senior_design` ;

-- -----------------------------------------------------
-- Table `senior_design`.`ebs_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `senior_design`.`ebs_table` (
  `user_ID` INT(11) NOT NULL,
  `snapshot` VARCHAR(45) NULL DEFAULT NULL,
  `snapshot_time` TIMESTAMP NOT NULL,
  `AMI` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`user_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `senior_design`.`game_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `senior_design`.`game_table` (
  `AMI` VARCHAR(45) NOT NULL,
  `game_title` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AMI`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
