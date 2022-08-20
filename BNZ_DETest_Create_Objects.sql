-- https://github.com/PeishiGao/BNZ_DE_Test

-- This is used to crate objects (Database, Schema and tables etc)
-- Consider this is only an excrise, no ETL tool is used, but this is recommend in production system
-- hard corded insert into is used to load data, but Wherescape RED, Kafla, DBT and other ETL tool should be used for production

Use Role accountadmin;


Alter account set timezone = 'Pacific/Auckland';
Show parameters like 'TIMEZONE%' in account;


Create or Replace Database BNZ_DEtest;
Create or Replace Schema System1; --store source data
Create or Replace Schema System2; --store source data
Create or Replace Schema Reporting; --used for reporting/analytics

--Creat Customer Table
Create or Replace Table BNZ_DETEST.SYSTEM1.Customer
    (Customer_No int,
    Age int,
    Start_Date DateTime,
    CommitDateTime datetime default getdate()  --record when the data is loaded to the table
    )
;

Insert Into BNZ_DETEST.SYSTEM1.Customer
    (Customer_No
    ,Age
    ,Start_Date)
Values
    (1232,19,'2005-01-20 00:00:00.00'),
    (1249,76,'2002-05-23 00:00:00.00'),
    (1255,45,'1999-04-03 00:00:00.00'),
    (1268,32,'2008-07-16 00:00:00.00')
;

--Create Account
Create Or Replace Table BNZ_DETEST.SYSTEM1.Account
    (Customer_No int
    ,Account_No string
    ,Product_Type_Code string
    ,Account_Status string
    ,Open_Date datetime
    ,CommitDateTime datetime default getdate())  --record when the data is loaded to the table)
 ;
 
Insert Into BNZ_DETEST.SYSTEM1.Account
    (Customer_No
    ,Account_No
    ,Product_Type_Code
    ,Account_Status
    ,Open_Date)
Values
    (1232,'000650023XXXXXX1234','CCRD','O','2016-05-23 00:00:00.00'),
    (1232,'000650023XXXXXX9876','CCRD','O','2018-06-20 00:00:00.00'),
    (1232,'0002000004567899812','TRAN','O','2016-05-23 00:00:00.00'),
    (1249,'0001000001234567801','TRAN','C','2005-08-12 00:00:00.00'),
    (1249,'0001000001234567802','SAVG','O','2011-05-06 00:00:00.00'),
    (1255,'000650010XXXXXX4569','BUSS','O','2014-02-20 00:00:00.00'),
    (1255,'000650055XXXXXX2358','BUSS','O','2014-03-19 00:00:00.00'),
    (1255,'0050000000012345600','HMLN','O','2017-02-02 00:00:00.00'),
    (1268,'0050000000098765411','HMLN','O','2010-09-20 00:00:00.00');

Create Or Replace Table BNZ_DETEST.SYSTEM2.Credit_Card_Account
    (Customer_No int
    ,Card_No string
    ,Open_Date int
    ,Bill_Acct string
    ,CommitDateTime datetime default getdate())  --record when the data is loaded to the table)
 ;
 
Insert Into BNZ_DETEST.SYSTEM2.Credit_Card_Account
    (Customer_No
    ,Card_No
    ,Open_Date
    ,Bill_Acct)
Values
    (1232,'650023xxxxxx1234',20011017,'N'),
    (1232,'650023xxxxxx9876',20050105,'N'),
    (1255,'650010xxxxxx4569',20001216,'N'),
    (1255,'650055xxxxxx2358',20001207,'Y')
;

Create Or Replace Table BNZ_DETEST.SYSTEM1.Transaction
     (Customer_No int
     ,Account_No string
     ,Trans_Date Datetime
     ,Trans_Type string
     ,amount decimal(20,2)
     ,CommitDateTime datetime default getdate())  --record when the data is loaded to the table)
 ;
 
Insert Into BNZ_DETEST.SYSTEM1.Transaction
    (Customer_No
     ,Account_No
     ,Trans_Date
     ,Trans_Type
     ,amount
    )
Values
    (1232,'000650023XXXXXX1234','2018-12-20 00:00:00.00','D',25.56),
    (1232,'000650023XXXXXX1234','2019-01-03 00:00:00.00','C',510.00),
    (1232,'000650023XXXXXX9876','2018-05-12 00:00:00.00','D',1250.00),
    (1232,'000650023XXXXXX9876','2019-03-19 00:00:00.00','D',49.45),
    (1255,'0050000000012345600','2018-09-12 00:00:00.00','D',1520.00),
    (1255,'0050000000012345600','2018-11-05 00:00:00.00','D',96.55),
    (1255,'0050000000012345600','2018-05-04 00:00:00.00','D',205.12)
;

