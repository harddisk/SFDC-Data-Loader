USE [db_landrover]
GO

/****** Object:  View [dbo].[sf_Account]    Script Date: 09/09/2015 11:10:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE  VIEW [dbo].[sf_Account]
AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - ACCOUNT TABLE
--- */
SELECT DISTINCT
	CASE 
		WHEN orderCustomerCategory			-- Corporate A/C
			IN ('4', '5', '6', '8')
			THEN 'Corporate Customer'
		WHEN orderCustomerCategory			-- Person A/C
			IN ('0', '1', '2', '3', '7', '9')
			THEN 'End Customer'
		ELSE ''
	END						[EDMS_Account_Type],
	CASE 
		WHEN orderCustomerCategory			-- Corporate A/C
			IN ('4', '5', '6', '8')
			THEN '01290000000SHqMAAW'
		WHEN orderCustomerCategory			-- Person A/C
			IN ('0', '1', '2', '3', '7', '9')
			THEN '01290000000SI78AAG'
		ELSE ''
	END						[RecordTypeId],
	customerIdentificationNo
							[Corporate_CustomerId],
	-- Corporate Account Info --
/*	CASE 
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')
			THEN customerIdentificationNo
		ELSE customerIdentificationNo
	END						[Corporate_CustomerId__c],
*/
	CASE 
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')				-- Corporate A/C
			THEN (SELECT TOP 1 LTRIM(RTRIM(ISNULL(S.customerName1, '')))+LTRIM(RTRIM(ISNULL(S.customerName2, '')))
				  FROM tb_Customer S 
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Corporate_Name],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')				-- Corporate A/C
			THEN (SELECT TOP 1 LTRIM(RTRIM(Ct.cityName))
				  FROM tb_Customer S LEFT OUTER JOIN tb_city Ct		-- get City, State description
				  ON customerCity = cityCode
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Corporate_BillingCity],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')				-- Corporate A/C
			THEN 'Malaysia'
		ELSE ''
	END						[Corporate_BillingCountry],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')				-- Corporate A/C
			THEN (SELECT TOP 1 LTRIM(RTRIM(customerPostcode))
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Corporate_BillingPostalCode],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')				-- Corporate A/C
			THEN (SELECT TOP 1 LTRIM(RTRIM(Ct.cityStateName))
				  FROM tb_Customer S LEFT OUTER JOIN tb_city Ct		-- get City, State description
				  ON S.customerCity = Ct.cityCode
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Corporate_BillingState],
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')
			THEN (SELECT TOP 1 LTRIM(RTRIM(S.customerAddress1)) + CHAR(13) +
							   LTRIM(RTRIM(S.customerAddress2)) + CHAR(13) +
							   LTRIM(RTRIM(S.customerAddress3))
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Corporate_BillingStreet],			-- Corporate A/C
	CASE
		WHEN orderCustomerCategory IN ('4', '5', '6', '8')
			THEN (SELECT TOP 1 REPLACE(REPLACE(ISNULL(S.customerEmail, ''), ' ', ''), ',', '')
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo AND
					NOT (customerEmail LIKE 'non@non%' OR customerEmail LIKE 'nil@eon%' OR
						 customerEmail LIKE 'aa@%' OR customerEmail LIKE 'aaa@%' OR
						 customerEmail LIKE 'aaaa@%' OR customerEmail LIKE 'aaaaa@%' OR
						 customerEmail LIKE 'aaaaaa@%' OR customerEmail LIKE 'aaaaas@%' OR
						 customerEmail LIKE 'abc@%' OR customerEmail LIKE 'customer@company.com')
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END					[Corporate_Email],
	CASE 
		WHEN orderCustomerCategory			-- Corporate A/C
			IN ('4', '5', '6', '8')
			THEN (SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(customerPhone, '-', ''), ' ', ''), '+', ''), '60', '0')
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Account_Phone],	
-- Person Account Info --where (customerName1 like 'Mr%' or customername1 like 'Mr.%')
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			THEN customerIdentificationNo
		ELSE ''
	END						[Contact_CustomerId],
	CASE	-- Options: Mr. Ms. Mrs. Dr. Prof.
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND
			 customerName1 LIKE 'DR %'
			THEN 'Dr.'
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND
			 LEN(C.customerIdentificationNo) = 12 AND
			 RIGHT(C.customerIdentificationNo, 1) IN ('1','3','5','7','9') AND
			 (customerName1 LIKE 'Mr%' OR customerName1 LIKE 'Mr.%')
			THEN 'Mr.'		-- when title is included in name
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND
			 LEN(C.customerIdentificationNo) = 12 AND
			 RIGHT(C.customerIdentificationNo, 1) IN ('2','4','6','8','0') AND
			 customerName1 LIKE 'Mrs%'
			THEN 'Mrs.'		-- when title is included in name
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND
			 LEN(C.customerIdentificationNo) = 12 AND
			 RIGHT(C.customerIdentificationNo, 1) IN ('1','3','5','7','9')
			THEN 'Mr.'		-- when title is not included in name
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND
			 LEN(C.customerIdentificationNo) = 12 AND
			 RIGHT(C.customerIdentificationNo, 1) IN ('2','4','6','8','0')
			THEN 'Ms.'		-- when title is not included in name
		ELSE ''				-- this should not be selected
	END						[Salutation],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND 
			 LEN(customerIdentificationNo) = 12 AND RIGHT(customerIdentificationNo, 1) IN ('0', '2', '4', '6', '8')
			THEN 'Female'
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND 
			 LEN(customerIdentificationNo) = 12 AND RIGHT(customerIdentificationNo, 1) IN ('1', '3', '5', '7', '9')
			THEN 'Male'
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND customerGender = 'P' THEN 'Female'
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') AND customerGender = 'L' THEN 'Male'
		ELSE ''
	END						[Person_Gender],
	CASE 
		WHEN orderCustomerCategory			-- Person A/C
			IN ('0', '1', '2', '3', '7', '9')
			THEN (SELECT TOP 1 LTRIM(RTRIM(customerName2))
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_FirstName],
	CASE 
		WHEN orderCustomerCategory			-- Person A/C
			IN ('0', '1', '2', '3', '7', '9')
			THEN (SELECT TOP 1 LTRIM(RTRIM(customerName1))
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_LastName],
	CASE 
		WHEN orderCustomerCategory			-- Person A/C
			IN ('0', '1', '2', '3', '7', '9')
			THEN (SELECT TOP 1 REPLACE(CONVERT(VARCHAR, customerDOB, 102), '.', '-') + 'T08:00:00.000Z'
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
					--AND S.customerDOB <> '')
		ELSE ''
	END						[Person_Birthdate],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') 
			THEN (SELECT TOP 1 LTRIM(RTRIM(Ct.cityName))
				  FROM tb_Customer S LEFT OUTER JOIN tb_city Ct		-- get City, State description
				  ON customerCity = cityCode
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_MailingCity],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') 
		THEN 'Malaysia'
		ELSE ''
	END						[Person_MailingCountry],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') 
			THEN (SELECT TOP 1 LTRIM(RTRIM(customerPostcode))
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_MailingPostalCode],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') 
			THEN (SELECT TOP 1 LTRIM(RTRIM(Ct.cityStateName))
				  FROM tb_Customer S LEFT OUTER JOIN tb_city Ct		-- get City, State description
				  ON S.customerCity = Ct.cityCode
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_MailingState],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			THEN (SELECT TOP 1 LTRIM(RTRIM(S.customerAddress1)) + CHAR(13) +
							   LTRIM(RTRIM(S.customerAddress2)) + CHAR(13) +
							   LTRIM(RTRIM(S.customerAddress3))
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_MailingStreet],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9') 
			THEN (SELECT TOP 1 REPLACE(REPLACE(ISNULL(S.customerEmail, ''), ' ', ''), ',', '')
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo AND
					NOT (customerEmail LIKE 'non@non%' OR customerEmail LIKE 'nil@eon%' OR
						 customerEmail LIKE 'aa@%' OR customerEmail LIKE 'aaa@%' OR
						 customerEmail LIKE 'aaaa@%' OR customerEmail LIKE 'aaaaa@%' OR
						 customerEmail LIKE 'aaaaaa@%' OR customerEmail LIKE 'aaaaas@%' OR
						 customerEmail LIKE 'abc@%' OR customerEmail LIKE 'customer@company.com')
				  ORDER BY lastUpdate DESC)
		ELSE ''
	END						[Person_Email],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			THEN ISNULL((SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(customerPhone, '-', ''), ' ', ''), '+', ''), '60', '0')
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  AND NOT (S.customerPhone LIKE '01%' OR
						   S.customerPhone LIKE '601%' OR
						   S.customerPhone LIKE '00%')
				  ORDER BY lastUpdate DESC), '')
		ELSE ''
	END						[Person_HomePhone],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			THEN ISNULL((SELECT TOP 1 REPLACE(REPLACE(REPLACE(REPLACE(customerPhone, '-', ''), ' ', ''), '+', ''), '60', '0')
				  FROM tb_Customer S
				  WHERE S.customerIdentificationNo = C.customerIdentificationNo
				  AND (customerPhone LIKE '01%' OR customerPhone LIKE '601%')
				  ORDER BY lastUpdate DESC), '')
		ELSE ''
	END						[Person_MobilePhone],
	CASE
		WHEN orderCustomerCategory IN ('0', '1', '2', '3', '7', '9')
			THEN ISNULL((SELECT orderRaceDesc FROM tb_orderRace
				 WHERE orderRaceId = (SELECT TOP 1 S.customerRace 
									   FROM tb_customer S
									   WHERE S.customerIdentificationNo = C.customerIdentificationNo
									   ORDER BY lastUpdate DESC)), '')
		ELSE ''
	END						[Race],

-- Record Date
	(SELECT TOP 1 enterDate FROM tb_Customer S
	 WHERE S.customerIdentificationNo = C.customerIdentificationNo
	 ORDER BY enterDate DESC)
							[enterDate],
	(SELECT TOP 1 lastUpdate FROM tb_Customer S
	 WHERE S.customerIdentificationNo = C.customerIdentificationNo
	 ORDER BY lastUpdate DESC)
							[lastUpdate]
FROM tb_customer C 
--LEFT OUTER JOIN tb_orderRace	-- get Race description
--ON customerRace = orderRaceId
	LEFT OUTER JOIN tb_city 		-- get City, State description
ON customerCity = cityCode
	LEFT OUTER JOIN tb_salesOrder		-- get Sales Order info
ON customerSalesOrderId = salesOrderId
WHERE (
	orderCustomerCategory IN ('4','5','6','8') OR		-- Corporate A/C
	orderCustomerCategory IN ('0','1','2','3','7','9')	-- Person A/C
)
AND orderStatus = '6010'
--LEN(C.customerIdentificationNo) > 1








GO

