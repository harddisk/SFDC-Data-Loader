USE [db_landrover]
GO

/****** Object:  View [dbo].[sf_SalesOrder]    Script Date: 09/09/2015 09:30:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[sf_SalesOrder] AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - SALES ORDER
--- */
SELECT distinct
*
FROM (SELECT
	salesOrderId					[EDMS_Sales_Order_Id],
	orderDealerId					[EDMS_Dealer_Id],
	'068'							[EDMS_Company],
	'lrv'							[EDMS_Make],
	dealerName						[Dealer_Name],
	orderSalesPersonId				[EDMS_Sales_Person_Id],
	ISNULL(ordersalesPerson, 
		   ISNULL(REPLACE(REPLACE(LTRIM(RTRIM(salesPersonName1))+' '+
		   REPLACE(LTRIM(RTRIM(salesPersonName2)), '-', ''), '.', ''), '  ', ' '), ''))
									[Sales_Person_Name],
	ISNULL(orderColour, '')			[Colour],
	ISNULL(orderVehicleRemark, '')	[Vehicle_Remark],
	ISNULL(orderRemark, '')			[Remark],
	-- Vehicle info
	orderVehicleId					[EDMS_Vehicle_Id],
	ISNULL(vehicleNo, '')			[Registration_Number],
	ISNULL(REPLACE(CONVERT(VARCHAR, orderRegistrationDateTime, 102), '.', '-') + 'T08:00:00.000Z', '')
									[Registration_Date],
	vehicleChassisNo				[Chassis_Number],
	-- Customer info
	orderCustomerIdentificationNo	[EDMS_Customer_Id],
	LOWER(CASE
		WHEN (orderCustomerEmail LIKE 'aaaaa@%' OR orderCustomerEmail LIKE '%@.%' OR
			  orderCustomerEmail LIKE 'non@non%' OR orderCustomerEmail LIKE 'aa@%' OR 
			  orderCustomerEmail LIKE 'nil@eon%' OR orderCustomerEmail LIKE 'aaa@%' OR
			  orderCustomerEmail LIKE 'aaaaaa@%' OR orderCustomerEmail LIKE 'abc@%' OR 
			  orderCustomerEmail LIKE 'aaaaas@%' OR orderCustomerEmail LIKE 'aaaa@%' OR 
			  orderCustomerEmail LIKE 'non@tm.net' OR orderCustomerEmail LIKE 'nil@com.my' OR
			  orderCustomerEmail LIKE 'non@com.my' OR orderCustomerEmail LIKE 'NIL@eon.com' OR
			  orderCustomerEmail LIKE 'non@non.net' OR orderCustomerEmail LIKE 'company@com.my' OR
			  orderCustomerEmail LIKE 'aaa@aaaa.com.my' OR orderCustomerEmail LIKE 'customer@company.com') THEN ''
		ELSE ISNULL(REPLACE(REPLACE(REPLACE(CASE
				WHEN orderCustomerEmail LIKE '%.' THEN LEFT(orderCustomerEmail, LEN(orderCustomerEmail) - 1)
				WHEN orderCustomerEmail LIKE '.%' THEN RIGHT(orderCustomerEmail, LEN(orderCustomerEmail) - 1)
				ELSE orderCustomerEmail END, ' ', ''), ',', ''), 'http://', ''), '')
	END)							[Customer_Email],
	REPLACE(REPLACE(REPLACE(REPLACE(
		CASE
			WHEN orderCustomerPhone LIKE '60%' THEN RIGHT(orderCustomerPhone, LEN(orderCustomerPhone) - 1)
			ELSE ISNULL(orderCustomerPhone, '')
		END
	, '''', ''), '-', ''), ' ', ''), 'N/A', '')
									[Customer_Phone],
	CASE
		WHEN LTRIM(RTRIM(orderCustomerAddress1)) <> '' AND
			 LTRIM(RTRIM(orderCustomerAddress2)) <> '' THEN
			LTRIM(RTRIM(orderCustomerAddress1)) + ', ' +
			LTRIM(RTRIM(orderCustomerAddress2))
		WHEN LTRIM(RTRIM(orderCustomerAddress1)) <> '' THEN
			LTRIM(RTRIM(orderCustomerAddress1))
	END								[Delivery_Address],
	orderCustomerPostcode			[Delivery_Postcode],
	cityName						[Delivery_City],
	cityStateName					[Delivery_State],
	--orderCreationDate				[enterDate],
	--orderCreationDate				[lastUpdate]
	tb_SalesOrder.enterDate,
	tb_SalesOrder.lastUpdate
FROM tb_salesOrder LEFT OUTER JOIN tb_vehicle	-- get vehicle registratrion no
ON orderVehicleId = vehicleId
				LEFT OUTER JOIN tb_dealer		-- get Dealer info
ON orderDealerId = dealerID
				LEFT OUTER JOIN tb_city 		-- get City, State description
ON orderCustomerCity = cityCode
				LEFT OUTER JOIN tb_salesPerson
ON ordersalesPersonId = salesPersonId
WHERE NOT orderVehicleId IS NULL
AND orderStatus = '6010') [sf_SalesOrder]




GO

