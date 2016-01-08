USE [db_ford1]
GO

/****** Object:  View [dbo].[sf_Model]    Script Date: 09/03/2015 16:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[sf_Model] AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - VEHICLE_MODEL__C
	Vehicle Models
--- */
SELECT
	modelDisplay		[Name],
	'088'				[EDMS_Company],
	'nc'				[EDMS_Type],
	modelId				[EDMS_Model_Id],
	modelNo				[EDMS_Model_No],
	modelDisplay		[Model_Desc],
	modelBodyType		[Body_Type],
	modelChassisPrefix	[Chassis_Prefix],
	modelEnginePrefix	[Engine_Prefix],
	CASE
		WHEN modelTransmission = 'A' THEN 'Automatic'	-- Automatic
		WHEN modelTransmission = 'M' THEN 'Manual' 		-- Manual
	END					[Transmission],
	modelEngineCapacity	[Engine_Capacity],
	CASE
		WHEN modelFuelType IN ('0') THEN 'Petrol'		-- Petrol
		WHEN modelFuelType IN ('1', '7') THEN 'Diesel'	-- Diesel
	END					[Fuel_Type],
	fueltypeDescription	[Fuel_Type_Long],
	modelMake			[EDMS_Make],
	--modelCreatedDate	[enterDate],
	--modelUpdate			[lastUpdate]
	enterDate,
	lastUpdate
FROM tb_model LEFT OUTER JOIN tb_fueltype
	ON modelFuelType = fueltypeCode





GO

