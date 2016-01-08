ALTER VIEW [dbo].[sf_Vehicle] AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - VEHICLE
--- */
SELECT
*
FROM (SELECT DISTINCT
	vehicleID			[EDMS_Vehicle_Id],	-- EDMS_Id__C
	ISNULL(vehicleNo, '') + '|' + vehicleChassisNo
						[Name],				-- Name
	coName				[Assembler_Name],	-- Assembler_Name__c
	vehicleChassisNo	[EDMS_Chassis_Number],
											-- EDMS_Chassis_Number__c (external id)
	ISNULL(REPLACE(CONVERT(VARCHAR, vehicleExOkDate, 102), '.', '-') + 'T08:00:00.000Z', '')
						[Production_Date],	-- Production_Date__c (was Intall Date)
	modelId				[EDMS_Model_Id],	-- EDMS_Model_Id__c
	ISNULL(REPLACE(CONVERT(VARCHAR, vehicleImportDate, 102), '.', '-') + 'T08:00:00.000Z', '')
						[Purchase_Date],	-- Purchase_Date__c
	statusDescription	[Status],			-- Status__c
	vehicleBodyType		[Body_Type],		-- Body_Type__c
	vehicleBrand		[Brand_Code],		-- Brand_Code__c
	ISNULL(vehicleNo, '')
						[Registration_Number],
											-- Registration_Number__c
	ISNULL(REPLACE(CONVERT(VARCHAR, orderRegistrationDateTime, 103), '.', '/'), '')
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
	tb_vehicle.enterDate,					-- <unused>
	tb_vehicle.lastUpdate					-- <unused>
FROM tb_vehicle
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
