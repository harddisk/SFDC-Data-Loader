ALTER   view [dbo].[sf_Dealer] as
/* ---
PREPARING SQL SELECTION FOR SALESFORCE - DEALER
--- */
SELECT DISTINCT
	dealerID					[EDMS_Dealer_Id],
	dealerName					[EDMS_Dealer_Name], 
	dealerStatus				[Status], 
	ISNULL(CONVERT(VARCHAR,dealerParentID), '')
								[EDMS_Parent_Id], 
	dealerCreatedDate			[Created_Date],
	REPLACE(LTRIM(RTRIM(dealerBusinessRegNo)), '-', '')
								[Business_Registration_Number], 
	REPLACE(LTRIM(RTRIM(dealerContactPerson)), '-', '')
								[Contact_Person], 
	REPLACE(REPLACE(LTRIM(RTRIM(dealerAddress1)), ', ', ' '), ',', ' ')
								[Dealer_Address1], 
	REPLACE(REPLACE(LTRIM(RTRIM(dealerAddress2)), ', ', ' '), ',', ' ')
								[Dealer_Address2], 
	REPLACE(REPLACE(LTRIM(RTRIM(dealerAddress3)), ', ', ' '), ',', ' ')
								[Dealer_Address3], 
	REPLACE(REPLACE(LTRIM(RTRIM(dealerCity)), ',', ''), '-', '')
								[Dealer_City], 
	dealerState					[Dealer_State], 
	dealerPostcode				[Dealer_Postcode], 
	dealerCountry				[Dealer_Country], 
	REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(dealerPhone)), '-', ''), '''', ''), ' ', '')
								[Dealer_Phone],
	REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(dealerFax)), '-', ''), '''', ''), ' ', '')
								[Dealer_Fax],
	REPLACE(dealerEmail, ' ', '')
								[Dealer_Email],
	ISNULL(dealerNotes, '')		[Dealer_Notes], 
	dealerType					[Dealer_Type], 
	REPLACE(LTRIM(RTRIM(dealerCode)), '-', '')
								[SAP_Code]
FROM tb_dealer

GO


