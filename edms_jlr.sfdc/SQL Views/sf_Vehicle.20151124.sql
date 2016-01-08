USE [db_landrover]
GO

/****** Object:  View [dbo].[sf_Vehicle]    Script Date: 11/24/2015 14:29:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[sf_Vehicle] AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - VEHICLE
--- */
SELECT
*
FROM (SELECT DISTINCT
	vehicleID			[EDMS_Vehicle_Id],	-- EDMS_Id__c
	vehicleChassisNo	[Name],				-- Name
	'068'				[EDMS_Company],		-- hardcoded to '088' for FORD
	'nc'				[EDMS_Type],		-- hardcoded to 'nc' for 'New Car'
	'lrv'				[EDMS_Make],		-- hardcoded to 'for' for 'FOR'
	coName				[Assembler_Name],	-- Assembler_Name__c
	(SELECT TOP 1 vehicleChassisNo
	 FROM tb_vehicle v1 INNER JOIN tb_salesorder s1
	 ON v1.vehicleID = s1.orderVehicleId AND s1.orderStatus = '6010'
	 WHERE v1.vehicleChassisNo = v.vehicleChassisNo
	 ORDER BY s1.lastUpdate DESC)
						[EDMS_Chassis_Number],
											-- EDMS_Chassis_Number__c (external id)
	ISNULL(REPLACE(CONVERT(VARCHAR, vehicleExOkDate, 102), '.', '-') + 'T08:00:00.000Z', '')
						[Production_Date],	-- Production_Date__c (was Intall Date)
	MONTH(vehicleExOkDate)
						[Production Month],
	YEAR(vehicleExOkDate)
						[Production Year],
	modelId				[EDMS_Model_Id],	-- EDMS_Model_Id__c
	ISNULL(REPLACE(CONVERT(VARCHAR, vehicleImportDate, 102), '.', '-') + 'T08:00:00.000Z', '')
						[Purchase_Date],	-- Purchase_Date__c
	statusDescription	[Status],			-- Status__c
	vehicleBodyType		[Body_Type],		-- Body_Type__c
	vehicleBrand		[Brand_Code],		-- Brand_Code__c
	(SELECT TOP 1 ISNULL(vehicleNo, '')
	 FROM tb_vehicle v1 INNER JOIN tb_salesorder s1
	 ON v1.vehicleID = s1.orderVehicleId AND s1.orderStatus = '6010'
	 WHERE v1.vehicleChassisNo = v.vehicleChassisNo
	 ORDER BY v1.lastUpdate DESC)
						[Registration_Number],
											-- Registration_Number__c
	ISNULL(REPLACE(CONVERT(VARCHAR, orderRegistrationDateTime, 102), '.', '-') + 'T08:00:00.000Z', '')
						[Registration_Date],
											-- Registration_Date__c
	vehicleColor		[Colour],			-- Colour__c
	orderCustomerIdentificationNo
						[Customer_Id],		-- Customer_Id__c
	vehicleEngineNo		[Engine_Number],	-- Engine_Number__c
	fueltypeDescription	[Fuel_Type],		-- Fuel_Type__c
	vehicleLotNo		[Lot_Number],		-- Lot_Number__c,
	vehicleNoOfSeats	[Number_of_Seats],	-- Number_of_Seats__c,
	vehiclePaintType	[Paint_Type],		-- Paint_Type__c,
	vehicleSequenceNo	[Sequence_Number],	-- SequenceNumber__c,
	vehicleTransmission	[Transmission],		-- Transmission__c,
	vehicleType			[Type],				-- Type__c,
	ISNULL(vehicleVariant, '')
						[Variant],			-- Variant__c,
	vehicleYearMade		[Year_Made],		-- YearMade__c
	(SELECT TOP 1 enterDate FROM tb_Vehicle v1
	 WHERE v1.vehicleChassisNo = v.vehicleChassisNo
	 ORDER BY enterDate DESC)
						[enterDate],
	(SELECT TOP 1 lastUpdate FROM tb_Vehicle v1
	 WHERE v1.vehicleChassisNo = v.vehicleChassisNo
	 ORDER BY lastUpdate DESC)
						[lastUpdate]
FROM tb_vehicle v
	LEFT OUTER JOIN (
		SELECT so1.* FROM tb_salesorder [so1] INNER JOIN (
			SELECT orderVehicleId, MAX(orderCreationDate) [orderCreationDate] FROM tb_salesorder
			WHERE orderStatus = '6010'
			GROUP BY orderVehicleId
		) [so2]
		ON so1.orderVehicleId = so2.orderVehicleId AND
		   so1.orderCreationDate = so2.orderCreationDate) [so] --tb_salesorder	ON orderVehicleId = vehicleId AND orderStatus = '6010' --AND SAP_IsSent = '1'
								ON vehicleID = orderVehicleId
	LEFT OUTER JOIN tb_status	ON vehicleStatus = statusId
	LEFT OUTER JOIN tb_model	ON vehicleModelId = modelId
	LEFT OUTER JOIN	tb_Company	ON vehicleCoID = coId
	LEFT OUTER JOIN tb_fueltype	ON vehicleFuelType = fueltypeCode
WHERE orderStatus = '6010') [sf_Vehicle]








GO

