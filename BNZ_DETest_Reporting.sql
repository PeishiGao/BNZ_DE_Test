-- https://github.com/PeishiGao/BNZ_DE_Test

--Question 1. 
--1.	A list of all accounts to be included in the investigation with appropriate opening date
Use Database BNZ_DETEST;

Create Or Replace schema Reporting; --create a new schema for reporting, analystics, visualisation etc

Create Or Replace View BNZ_DETEST.Reporting.Question1
as
Select 
    acc.customer_no
    ,acc.account_no
    ,acc.product_type_code
    ,acc.account_status
    ,Coalesce(to_timestamp(ccd.open_date::varchar,'yyyymmdd'),acc.open_date) as OPEN_DATE --CC Open date is from Credict Card account
    ,ccd.bill_acct
From BNZ_DETEST.SYSTEM1.ACCOUNT acc
Left Join BNZ_DETEST.SYSTEM2.CREDIT_CARD_ACCOUNT ccd
    On lower(RIGHT(acc.account_no,16))=lower(ccd.CARD_NO) --data was masked differently, upper vs lower
Where acc.PRODUCT_TYPE_CODE<>'BUSS' --exclude BUSS product type
    and acc.account_status='O' --open account only    
;



;

--question 2
-- 2.	A list of customers that opened an account since the 1 July 2018 that have not made any transactions in the last 3 months on any account.

Create Or Replace View BNZ_DETEST.REPORTING.Question2
As
Select distinct qn1.CUSTOMER_NO
From bnz_detest.reporting.Question1 qn1
Where 1=1
    and qn1.OPEN_DATE>='2018-07-01'; --date an account opened since
    and not exists (Select 1
                  From BNZ_DETEST.SYSTEM1.TRANSACTION tra
                  Where tra.account_no=qn1.account_no
                    and tra.trans_date>=DateAdd(month,-3, Getdate()::date) --Date transactions in last 3 month.dynamic filed. timestamp is removed, so date type only
                  )
;

--Question3
-- 3.	The proportion of customers that have opened a credit card since the 1 July 2018 for each of the following age ranges: 18 – 29, 30 – 44, 45 – 59, 60+. Credit card accounts have a product type of ‘CCRD’ or ‘BUSS’.


Create Or Replace View BNZ_DETEST.REPORTING.QUESTION3
AS
With CTE_CredictCardCustomer --customer who has CC account
as
    (Select distinct
        CUSTOMER_NO
    From BNZ_DETEST.REPORTING.QUESTION1
    Where PRODUCT_TYPE_CODE='CCRD' --UBSS is excluded based on user requirements
        and open_date>='2018-07-01' --date an credit card account opened since
    )
Select 
    Case When cus.age between 18 and 29 then '18-29'
        When cus.age between 30 and 44 then '30-44'
        When cus.age between 45 and 59 then '45-59'
        When cus.age >=60 then '60+'
        else 'Unknown' --customer under 18 is not likely to have CC account, but it is good practice to have 'unknown' just in case
    End as AgeBand
    ,SUM(IFF(ccc.CUSTOMER_NO is not null,1,0))*1.0/(Count(*)*1.0) as Proportion_CustomerWithCC
From BNZ_DETEST.SYSTEM1.CUSTOMER cus
Left Join CTE_CredictCardCustomer ccc
    On cus.CUSTOMER_NO=ccc.CUSTOMER_NO
Group By Case When cus.age between 18 and 29 then '18-29'
        When cus.age between 30 and 44 then '30-44'
        When cus.age between 45 and 59 then '45-59'
        When cus.age >=60 then '60+'
        else 'Unknown' --customer under 18 is not likely to have CC account, but it is good practive to have 'unknown' just in case
    End
Order By 1
;
--------------------------------------
Select *
From question1;

Select *
From question2;

Select *
From question3;

