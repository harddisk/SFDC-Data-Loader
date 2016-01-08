ALTER VIEW [dbo].[sf_Product] AS
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - PRODUCT2
	Vehicle Models
--- */
SELECT
	modelDisplay		[Name],
	modelId				[EDMS_Model_Id],
	modelNo				[ProductCode],
	modelDisplay		[EDMS_Model_Name],
	modelChassisPrefix	[Chassis_Prefix],
	modelEnginePrefix	[Engine_Prefix],
	--modelCreatedDate	[enterDate],
	--modelUpdate		[lastUpdate]
	enterDate,
	lastUpdate
FROM tb_model
/*
Name		-> Code (modelCode)
ProductCode	-> Model Number (modelNo)
Description		-> Model Description (modelDisplay)
ChassisPrefix__c ->	modelChassisPrefix
*/
