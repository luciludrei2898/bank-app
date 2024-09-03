-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-04-2024 a las 08:27:02
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_banco`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_borrar` (IN `_id` INT)  begin
	delete from cuentas where c_num_cta = _id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_insertar` (IN `_nif` VARCHAR(9), IN `_titular` VARCHAR(50))  begin
	insert into cuentas values (null, _nif, _titular, current_date(), 0);
        SELECT last_insert_id() as ID_INSERTADO;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_modificar` (IN `_id` INT, IN `_nif` VARCHAR(9), IN `_titular` VARCHAR(50))  begin
	update cuentas set 
		c_nif = _nif,
        c_titular = _titular
    where c_num_cta = _id;
		
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_por_id` (IN `_id` INT)  begin
	select * from cuentas where c_num_cta = _id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_saldos_mayor` (IN `_saldo` INT)  begin
	select * from cuentas where c_saldo >= _saldo;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_saldos_menor` (IN `_saldo` INT)  begin
	select * from cuentas where c_saldo <= _saldo;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cta_todas_filtrado` (IN `_filtro` VARCHAR(50))  begin
	select * from cuentas
    where 
		c_num_cta LIKE concat('%', _filtro, '%') OR
		c_nif LIKE concat('%', _filtro, '%') OR
		c_titular LIKE concat('%', _filtro, '%') OR
		c_fecha_creacion LIKE concat('%', _filtro, '%') OR
		c_saldo LIKE concat('%', _filtro, '%');
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_borrar` (IN `_id` INT)  begin
	delete from movimientos where m_id = _id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_insertar` (IN `_idcuenta` INT, IN `_importe` DECIMAL, IN `_concepto` VARCHAR(50))  begin
	insert into movimientos values (null, _idcuenta, current_date(), _importe, _concepto);
	SELECT last_insert_id() as ID_INSERTADO;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_mayor` (IN `_importe` INT)  begin
	select * from movimientos where m_importe >= _importe;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_modificar` (IN `_id` INT, IN `_importe` DECIMAL, IN `_concepto` VARCHAR(50))  begin
	update movimientos set 
		m_importe = _importe,
        m_concepto = _concepto
    where m_id = _id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_mvtos_entre_fechas` (IN `_cuenta` INT, IN `_fecha1` DATE, IN `_fecha2` DATE)  begin
    if _cuenta is not null then select * from movimientos where m_c_num_cta = _cuenta AND m_fecha >= _fecha1 AND m_fecha <= _fecha2;
	else select * from movimientos;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_todos_filtrado` (IN `_filtro` VARCHAR(50))  begin
	select * from movimientos
    where 
		m_id LIKE concat('%', _filtro, '%') OR
		m_c_num_cta LIKE concat('%', _filtro, '%') OR
		m_fecha LIKE concat('%', _filtro, '%') OR
		m_importe LIKE concat('%', _filtro, '%') OR
		m_concepto LIKE concat('%', _filtro, '%');
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `m_todos_por_cuenta` (IN `_id` INT)  begin
	select * from movimientos where m_c_num_cta = _id;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas`
--

CREATE TABLE `cuentas` (
  `c_num_cta` int(10) UNSIGNED ZEROFILL NOT NULL,
  `c_nif` varchar(9) NOT NULL,
  `c_titular` varchar(50) NOT NULL,
  `c_fecha_creacion` date NOT NULL,
  `c_saldo` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cuentas`
--

INSERT INTO `cuentas` (`c_num_cta`, `c_nif`, `c_titular`, `c_fecha_creacion`, `c_saldo`) VALUES
(0000000001, '02302713E', 'Marta Sánchez Rosado', '2024-04-24', '1845.00'),
(0000000002, '02302713T', 'Lucía Sánchez Rosado', '2024-04-24', '1482.00'),
(0000000003, '02302487F', 'Javier Sancho García', '2024-04-24', '45.00'),
(0000000004, '32147854R', 'Carlos Ruíz Gomez', '2024-04-24', '15.00'),
(0000000005, '14521769C', 'Gloria Fuertes', '2024-04-24', '200.00'),
(0000000006, '02302584V', 'David Pires Manzanares', '2024-04-24', '2400.00'),
(0000000008, '11122247B', 'Vadym Batsula Bilenka', '2024-04-24', '200.00'),
(0000000010, '06534871B', 'Alex Sugimoto', '2024-04-24', '2100.00'),
(0000000013, '36514789G', 'Pedro Matute', '2024-04-24', '1790.00'),
(0000000014, '69874125F', 'Andrea Villajos Garrido', '2024-04-24', '1750.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos`
--

CREATE TABLE `movimientos` (
  `m_id` int(11) NOT NULL,
  `m_c_num_cta` int(10) UNSIGNED ZEROFILL NOT NULL,
  `m_fecha` datetime NOT NULL,
  `m_importe` decimal(10,2) DEFAULT NULL,
  `m_concepto` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `movimientos`
--

INSERT INTO `movimientos` (`m_id`, `m_c_num_cta`, `m_fecha`, `m_importe`, `m_concepto`) VALUES
(34, 0000000010, '2024-04-24 00:00:00', '2100.00', 'Sueldo Aeropuerto'),
(35, 0000000006, '2024-04-24 00:00:00', '2400.00', 'cryptos'),
(36, 0000000004, '2024-04-24 00:00:00', '15.00', 'cumpleaños mamá'),
(37, 0000000002, '2024-04-24 00:00:00', '487.00', 'pagas extra'),
(39, 0000000001, '2024-04-24 00:00:00', '1845.00', 'sueldo multiópticas abril'),
(40, 0000000003, '2024-04-24 00:00:00', '45.00', 'Devolución camiseta Zara'),
(42, 0000000013, '2024-04-24 00:00:00', '1750.00', 'NTT DATA - Sueldo Abril'),
(43, 0000000013, '2024-04-24 00:00:00', '40.00', 'Descambios regalos'),
(44, 0000000005, '2024-04-24 00:00:00', '200.00', 'Libros Casa Del Libro'),
(46, 0000000002, '2024-04-24 00:00:00', '-5.00', 'Pincho de tortilla'),
(47, 0000000002, '2024-04-24 00:00:00', '1000.00', 'Nómina'),
(48, 0000000008, '2024-04-25 00:00:00', '200.00', 'Regalo cumpleaños mamá y papá'),
(49, 0000000014, '2024-04-25 00:00:00', '1750.00', 'Sueldo HogarSi ONG');

--
-- Disparadores `movimientos`
--
DELIMITER $$
CREATE TRIGGER `trigger_mvto_aI` AFTER INSERT ON `movimientos` FOR EACH ROW UPDATE cuentas SET 
	c_saldo = NEW.m_importe + c_saldo
WHERE c_num_cta = NEW.m_c_num_cta
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_mvto_bd` BEFORE DELETE ON `movimientos` FOR EACH ROW UPDATE cuentas SET 
	c_saldo = c_saldo - OLD.m_importe
WHERE c_num_cta = OLD.m_c_num_cta
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_mvto_bu` BEFORE UPDATE ON `movimientos` FOR EACH ROW UPDATE cuentas SET 
	c_saldo = (c_saldo - OLD.m_importe + NEW.m_importe)
WHERE c_num_cta = OLD.m_c_num_cta
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  ADD PRIMARY KEY (`c_num_cta`);

--
-- Indices de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD PRIMARY KEY (`m_id`),
  ADD KEY `m_c_num_cta` (`m_c_num_cta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  MODIFY `c_num_cta` int(10) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  MODIFY `m_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD CONSTRAINT `movimientos_ibfk_1` FOREIGN KEY (`m_c_num_cta`) REFERENCES `cuentas` (`c_num_cta`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
