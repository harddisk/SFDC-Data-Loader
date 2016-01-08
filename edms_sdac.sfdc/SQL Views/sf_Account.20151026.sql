USE [db_ford]
GO

/****** Object:  View [dbo].[sf_Account]    Script Date: 10/26/2015 18:33:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  VIEW [dbo].[sf_Account]
AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - ACCOUNT TABLE
--- */
SELECT
*
FROM (
SELECT
	CASE 
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN 'Corporate Customer' -- Corporate A/C
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN 'End Customer' -- Person A/C
		ELSE ''
	END						[EDMS_Account_Type],
	CASE 
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN '01290000000SHqMAAW' -- Corporate A/C
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN '01290000000SI78AAG' -- Person A/C
		ELSE ''
	END						[RecordTypeId],
	CASE
		WHEN customerIdentificationNo = '-' THEN CONVERT(VARCHAR, C.customerID)
		ELSE customerIdentificationNo
	END						[Corporate_CustomerId],
	-- Corporate Account Info --
	CASE 
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN
			LTRIM(RTRIM(ISNULL(customerName1, ''))) + LTRIM(RTRIM(ISNULL(customerName2, '')))
		ELSE ''
	END						[Corporate_Name],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN LTRIM(RTRIM(ISNULL(cityName, '')))
		ELSE ''
	END						[Corporate_BillingCity],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN 'Malaysia'
		ELSE ''
	END						[Corporate_BillingCountry],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN LTRIM(RTRIM(ISNULL(customerPostcode, '')))
		ELSE ''
	END						[Corporate_BillingPostalCode],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN LTRIM(RTRIM(ISNULL(cityStateName, '')))
		ELSE ''
	END						[Corporate_BillingState],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN
			CASE
				WHEN LTRIM(RTRIM(ISNULL(customerAddress1, ''))) <> '' AND
					 LTRIM(RTRIM(ISNULL(customerAddress2, ''))) <> '' AND
					 LTRIM(RTRIM(ISNULL(customerAddress3, ''))) <> '' THEN
					LTRIM(RTRIM(ISNULL(customerAddress1, ''))) + ', ' +
					LTRIM(RTRIM(ISNULL(customerAddress2, ''))) + ', ' +
					LTRIM(RTRIM(ISNULL(customerAddress3, '')))
				WHEN LTRIM(RTRIM(ISNULL(customerAddress1, ''))) <> '' AND
					 LTRIM(RTRIM(ISNULL(customerAddress2, ''))) <> '' THEN
					LTRIM(RTRIM(ISNULL(customerAddress1, ''))) + ', ' +
					LTRIM(RTRIM(ISNULL(customerAddress2, '')))
				WHEN LTRIM(RTRIM(ISNULL(customerAddress1, ''))) <> '' THEN
					LTRIM(RTRIM(ISNULL(customerAddress1, '')))
				ELSE ''
			END
		ELSE ''
	END						[Corporate_BillingStreet],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')
			AND	NOT (customerEmail LIKE 'aa@%' OR customerEmail LIKE 'aaa@%' OR
					 customerEmail LIKE 'abc@%' OR customerEmail LIKE 'aaaaa@%' OR
					 customerEmail LIKE 'aaaa@%' OR customerEmail LIKE 'aaaaas@%' OR
					 customerEmail LIKE 'aaaaaa@%' OR customerEmail LIKE 'nil@eon%' OR
					 customerEmail LIKE 'non@non%' OR customerEmail LIKE 'customer@company.com') THEN
			LOWER(REPLACE(REPLACE(REPLACE(CASE
				WHEN customerEmail LIKE '%.' THEN LEFT(customerEmail, LEN(customerEmail) - 1)
				WHEN customerEmail LIKE '.%' THEN RIGHT(customerEmail, LEN(customerEmail) - 1)
				ELSE customerEmail END, ' ', ''), ',', ''), 'http://', ''))
		ELSE ''
	END					[Corporate_Email],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8') THEN
			REPLACE(REPLACE(REPLACE(REPLACE(
				CASE
					WHEN customerPhone LIKE '600%' THEN RIGHT(customerPhone, LEN(customerPhone) - 2)
					WHEN customerPhone LIKE '60%' THEN RIGHT(customerPhone, LEN(customerPhone) - 1)
					ELSE ISNULL(customerPhone, '')
				END
			, '''', ''), '-', ''), ' ', ''), 'N/A', '')
		ELSE ''
	END						[Account_Phone],	

-- Person Account Info
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN
			CASE
				WHEN customerIdentificationNo = '-' THEN CONVERT(VARCHAR, C.customerID)
				ELSE customerIdentificationNo
			END
		ELSE ''
	END						[Contact_CustomerId],
	CASE	-- Options: Mr. Ms. Mrs. Dr. Prof.
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			AND (ISNULL(customerName1, '') LIKE 'DR%' OR 
				 ISNULL(customerName1, '') LIKE 'Mrs%' OR ISNULL(customerName1, '') LIKE 'Mrs.%' OR
				 ISNULL(customerName1, '') LIKE 'Mr%' OR ISNULL(customerName1, '') LIKE 'Mr.%' OR
				 ISNULL(customerName1, '') LIKE 'Ms%' OR ISNULL(customerName1, '') LIKE 'Ms.%') THEN
			CASE
				WHEN ISNULL(customerName1, '') LIKE 'DR%' THEN 'Dr.'
				WHEN ISNULL(customerName1, '') LIKE 'Mrs%' OR ISNULL(customerName1, '') LIKE 'Mrs.%' THEN 'Mrs.'
				WHEN ISNULL(customerName1, '') LIKE 'Mr%' OR ISNULL(customerName1, '') LIKE 'Mr.%' THEN 'Mr.'
				WHEN ISNULL(customerName1, '') LIKE 'Ms%' OR ISNULL(customerName1, '') LIKE 'Ms.%' THEN 'Ms.'
				ELSE ''		-- presumably no title in name
			END
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '8') AND LEN(customerIdentificationNo) = 12 THEN
			CASE
				WHEN RIGHT(ISNULL(customerIdentificationNo, ''), 1) % 2 = 0 THEN 'Ms.'
				WHEN RIGHT(ISNULL(customeridentificationNo, ''), 1) % 1 = 0 THEN 'Mr.'
				ELSE ''		-- indeterminate IC number
			END
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '8', '9') AND NOT (ISNULL(customerGender, '') = '') THEN
			CASE
				WHEN customerGender = 'P' THEN 'Ms.'
				WHEN customerGender = 'L' THEN 'Mr.'
				ELSE ''		-- no gender value
			END
		ELSE ''				-- this denotes company
	END						[Salutation],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND customerGender = 'P' THEN 'Female'
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND customerGender = 'L' THEN 'Male'
		ELSE ''
	END						[Person_Gender],
	CASE 
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN LTRIM(RTRIM(ISNULL(customerName2, '')))
		ELSE ''
	END						[Person_FirstName],
	CASE 
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN LTRIM(RTRIM(ISNULL(customerName1, '')))
		ELSE ''
	END						[Person_LastName],
	CASE 
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN
			ISNULL(REPLACE(CONVERT(VARCHAR, customerDOB, 102), '.', '-') + 'T08:00:00.000Z', '')
		ELSE ''
	END						[Person_Birthdate],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN LTRIM(RTRIM(cityName))
		ELSE ''
	END						[Person_MailingCity],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN 'Malaysia'
		ELSE ''
	END						[Person_MailingCountry],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN LTRIM(RTRIM(ISNULL(customerPostcode, '')))
		ELSE ''
	END						[Person_MailingPostalCode],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN LTRIM(RTRIM(ISNULL(cityStateName, '')))
		ELSE ''
	END						[Person_MailingState],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN
			CASE
				WHEN LTRIM(RTRIM(ISNULL(customerAddress1, ''))) <> '' AND
					 LTRIM(RTRIM(ISNULL(customerAddress2, ''))) <> '' AND
					 LTRIM(RTRIM(ISNULL(customerAddress3, ''))) <> '' THEN
					LTRIM(RTRIM(ISNULL(customerAddress1, ''))) + ', ' +
					LTRIM(RTRIM(ISNULL(customerAddress2, ''))) + ', ' +
					LTRIM(RTRIM(ISNULL(customerAddress3, '')))
				WHEN LTRIM(RTRIM(ISNULL(customerAddress1, ''))) <> '' AND
					 LTRIM(RTRIM(ISNULL(customerAddress2, ''))) <> '' THEN
					LTRIM(RTRIM(ISNULL(customerAddress1, ''))) + ', ' +
					LTRIM(RTRIM(ISNULL(customerAddress2, '')))
				WHEN LTRIM(RTRIM(ISNULL(customerAddress1, ''))) <> '' THEN
					LTRIM(RTRIM(ISNULL(customerAddress1, '')))
				ELSE ''
			END
		ELSE ''
	END						[Person_MailingStreet],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') 
			AND NOT (customerEmail LIKE 'aa@%' OR customerEmail LIKE 'aaa@%' OR
					 customerEmail LIKE 'abc@%' OR customerEmail LIKE 'aaaaa@%' OR
					 customerEmail LIKE 'aaaa@%' OR customerEmail LIKE 'aaaaas@%' OR
					 customerEmail LIKE 'aaaaaa@%' OR customerEmail LIKE 'nil@eon%' OR
					 customerEmail LIKE 'non@non%' OR customerEmail LIKE 'customer@company.com') THEN
			LOWER(REPLACE(REPLACE(REPLACE(CASE
				WHEN customerEmail LIKE '%.' THEN LEFT(customerEmail, LEN(customerEmail) - 1)
				WHEN customerEmail LIKE '.%' THEN RIGHT(customerEmail, LEN(customerEmail) - 1)
				ELSE customerEmail END, ' ', ''), ',', ''), 'http://', ''))
		ELSE ''
	END						[Person_Email],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			AND NOT (customerPhone LIKE '01%' OR
					 customerPhone LIKE '601%' OR
					 customerPhone LIKE '00%') THEN
			REPLACE(REPLACE(REPLACE(REPLACE(
				CASE
					WHEN customerPhone LIKE '600%' THEN RIGHT(customerPhone, LEN(customerPhone) - 2)
					WHEN customerPhone LIKE '60%' THEN RIGHT(customerPhone, LEN(customerPhone) - 1)
					ELSE ISNULL(customerPhone, '')
				END
			, '''', ''), '-', ''), ' ', ''), 'N/A', '')
		ELSE ''
	END						[Person_HomePhone],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			AND (customerPhone LIKE '01%' OR
				 customerPhone LIKE '601%') THEN
			REPLACE(REPLACE(REPLACE(REPLACE(
				CASE
					WHEN customerPhone LIKE '600%' THEN RIGHT(customerPhone, LEN(customerPhone) - 2)
					WHEN customerPhone LIKE '60%' THEN RIGHT(customerPhone, LEN(customerPhone) - 1)
					ELSE ISNULL(customerPhone, '')
				END
			, '''', ''), '-', ''), ' ', ''), 'N/A', '')
		ELSE ''
	END						[Person_MobilePhone],
	
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') THEN ISNULL(orderRaceDesc, '')
		ELSE ''
	END						[Race],
	C.enterDate,
	C.lastUpdate
FROM tb_customer C INNER JOIN (
	SELECT MAX(customerID) [customerID] FROM tb_Customer
	GROUP BY customerIdentificationNo) C1
ON C.customerID = C1.customerID
	LEFT OUTER JOIN tb_orderRace	-- get Race description
ON customerRace = orderRaceId
	LEFT OUTER JOIN tb_city 		-- get City, State description
ON customerCity = cityCode
	LEFT OUTER JOIN tb_salesOrder	-- get Sales Order info
ON customerSalesOrderId = salesOrderId AND orderStatus = '6010'
	LEFT OUTER JOIN tb_cusCategory	-- get Customer Category description
ON orderCustomerCategory = cusCatId
WHERE orderStatus = '6010') [sf_Account]


GO

