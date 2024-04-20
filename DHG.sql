--                BOOKING PATTERNS

-- Trend in Booking patterns

Select LTrim(Booking_Date) BookingDate
, Count(Booking_Date) BD_Count
From DHG
Where Booking_Date Like '%2015%'
And Booking_Date Like '%Jul%'
Group by Booking_Date
Order by Booking_Date



--How Lead_time differ across Booking_channels (After 31 days Lead_time )

With CTE_LTdifferacrossBC as
(
 Select Lead_Time, Distribution_Channel, Count(Distribution_Channel) Count_of_DC
--Over (Partition by Lead_Time) Count_of_DC
From DHG
Where Booking_Date Like '%2015%'
Group by Distribution_Channel, Lead_Time
--Having Lead_Time Between 0 and 31
)
Select Distribution_Channel, Sum(Count_of_DC) Total_DC
From CTE_LTdifferacrossBC
Group by Distribution_Channel
Order by Total_DC Desc

--Correlation btwn Lead_time and Customer_Types (in a month, 6-months and a year)

With CTE_CorrelationBtwnLTandCT as
(
Select Lead_Time, Customer_Type, Count(Customer_Type) Count_CT
From DHG
Where Booking_Date Like '%2015%'
Group by Lead_Time, Customer_Type
--Having Lead_Time Between 32 and 182
)
Select Customer_Type, Sum(Count_CT) Total_CT
From CTE_CorrelationBtwnLTandCT
Group by Customer_Type
Order by Total_CT Desc

--               CUSTOMER_BEHAVIOR ANALYSIS

--How Distribution_Channels contribute to Bookings, and how ADR differ across these channels

With CTE_ContributionDCtoBookings as
(
Select Distinct Distribution_Channel, Count(Distribution_Channel) Count_of_DC, Sum(Avg_Daily_Rate) Total_ADR
From DHG
Where Booking_Date Like '%2015%' 
Group by Distribution_Channel
)
Select Distribution_Channel, Sum(Count_of_DC) Total_Bookings, Total_ADR
 From CTE_ContributionDCtoBookings
 Group by Distribution_Channel, Total_ADR
 Order by Total_Bookings Desc

 --Patterns in the distribution of Guests based on their Country, and how it impact Revenue

Select Country, Count(Guests) Total_Guests, Sum(Revenue) Total_Revenue
From DHG
Where Booking_Date Like '%2015%'
Group by Country
Order by Total_Revenue Desc

 --               CANCELLATION ANALYSIS

 --Factors that correlate with Cancellations

 Select Distinct Status, Count(Cancelled) Over (Partition by Status) Total_Cancelled
 From DHG
 Where Cancelled = 1 
 --And Booking_Date Like '%2015%'

 --Prediction of cancellation based on Deposit_Type

 Select Distinct Deposit_Type, Count(Cancelled) Over (Partition by Deposit_Type) Total_Cancelled
 From DHG
 --Where Cancelled = 1
 --And Booking_Date Like '%2015%'
 Order by Total_Cancelled Desc


 --How Revenue_loss from cancellation compare across Customer segment

 Select Distinct Customer_Type, Sum(Revenue_Loss) Total_Revenue_Loss
 From DHG
 Where Cancelled = 1
 --And Booking_Date Like '%2015%'
 Group by Customer_Type
 Order by Total_Revenue_Loss 

 --across Distribution channels

 Select Distinct Distribution_Channel, Sum(Revenue) Total_Revenue_Loss
 From DHG
 Where Cancelled = 1
 --And Booking_Date Like '%2015%'
 Group by Distribution_Channel
 Order by Total_Revenue_Loss Desc

 
 --         REVENUE OPTIMIZATION

 --Overall Revenue trend

 Select Sum(Revenue) Overall_Revenue
 From DHG
 --Where Booking_Date Like '%2015%'

 --How Customer segments contribute to Revenue

 Select Customer_Type, Sum(Revenue) Total_Revenue
 From DHG
 --Where Booking_Date Like '%2015%'
 Group by Customer_Type
 Order by Total_Revenue Desc

 --And how Countries contribute to Revenue

 Select Country, Sum(Revenue) Total_Revenue
 From DHG
 --Where Booking_Date Like '%2015%'
 Group by Country
 Order by Total_Revenue Desc

 --Optimal pricing based on ADR for Customer_types

 Select Customer_Type, Avg(Avg_Daily_Rate) as ADR_Avg
 From DHG
 --Where Booking_Date Like '%2015%'
 Group by Customer_Type

 --for Distribution_Channel

 Select Distribution_Channel, Avg(Avg_Daily_Rate) as ADR_Avg
 From DHG
  --Where Booking_Date Like '%2015%'
 Group by Distribution_Channel

 --               GEOGRAPHICAL ANALYSIS

 --How distribution of Guests differ across Countries

Select Country, Count(Guests) Total_Guests
From DHG
Group by Country
Order by Total_Guests Desc

--Correlation btwn Countries and likelihood of cancellations

Select Country, Count(Cancelled) Total_Cancellations
From DHG
Where Cancelled = 1
--And Booking_Date Like '%2015%'
Group by Country
Order by Total_Cancellations Desc


--           OPERATIONAL EFFICIENCY

--Avg length of stay of Guests

Select Avg(Nights) Avg_length_of_stay
From DHG
--And Booking_Date Like '%2015%'

--how it differ across Booking channels

Select Distinct Distribution_Channel, Avg(Nights) Avg_length_of_stay
From DHG
--And Booking_Date Like '%2015%'
Group by Distribution_Channel

--across Customer types

Select Distinct Customer_Type, Avg(Nights) Over (Partition by Customer_Type) Avg_length_of_stay
From DHG
--And Booking_Date Like '%2015%'

--Patterns in checkout dates

Select RTrim(Status_Update) Checkout_Date, Count(Status_Update) Total_Checkouts
From DHG
Where Status_Update Like '%2015%' And Cancelled = 0
Group by Status_Update
Order by Status_Update

--               IMPACT OF DEPOSIT TYPES

--How the presence and absence of a deposit impact the likelihood of cancellations

Select Deposit_Type, Count(Cancelled) Total_Cancellation
From DHG
Where Cancelled = 1
Group by Deposit_Type

--impact on Revenue generation

Select Deposit_Type, Sum(Revenue) Total_Revenue
From DHG
--Where Booking_Date Like '%2015%'
Group by Deposit_Type

--Patterns in the use of Deposit types across Customer segments

Select Customer_Type, Count(Deposit_Type) Total_DepositType
From DHG
--Where Booking_Date Like '%2015%'
Group by Customer_Type


--             CORPORATE BOOKINGS ANALYSIS

--Proportion of Corporate bookings

Select Distinct Distribution_Channel, Count(Distribution_Channel) Over (Partition by Distribution_Channel) Total_DC
From DHG
Where Distribution_Channel Like '%Corpo%'
And Booking_Date Like '%2015%'

-- and how their(CB) ADR compare across Customer_Types

Select Customer_Type, Distribution_Channel, Sum(Avg_Daily_Rate) Total_CB_ADR
From DHG
Where Distribution_Channel Like '%Corpo%'
--And Booking_Date Like '%2015%'
Group by Customer_Type, Distribution_Channel

--Trends/Patterns related to Corporate Bookings

--Bookings
With CTE_CorporateBookings as
(
Select Distinct RTrim(Booking_Date) Booking_date, Distribution_Channel, Count(Booking_Date) Bookings 
From DHG
Where Booking_Date Like '%2015%' 
And Booking_Date Like '%Jul%'
Group by Booking_Date, Distribution_Channel
Having Distribution_Channel Like '%Corpo%'
)
Select Distribution_Channel, Sum(Bookings) Total_Bookings
From CTE_CorporateBookings
Group by Distribution_Channel

--Arrivals

With CTE_CorporateBookingsA as
(
Select Distinct RTrim(Arrival_Date) Arrival_date, Distribution_Channel, Count(Arrival_Date) Arrivals 
From DHG
Where Arrival_Date Like '%2015%' 
And Arrival_Date Like '%Jul%'
Group by Arrival_Date, Distribution_Channel
Having Distribution_Channel Like '%Corpo%'
)
Select Distribution_Channel, Sum(Arrivals) Total_Arrivals
From CTE_CorporateBookingsA
Group by Distribution_Channel


--             TIME-EVENT ANALYSIS

--How Lead_time affect Revenue (in a month, 6 months and a  year)

Select Distinct Lead_Time, Sum(Revenue) Over (Partition by Lead_Time) Revenues
From DHG
Where Booking_Date Like '%2015%'
And Lead_Time Between 0 and 31
Order by Lead_Time

--how it affect likelihood of cancellation (in a month, 6 months and a  year)

Select Distinct Status, Count(Status) Total_Cancellations
--Over (Partition by Cancelled) Total_Cancellations
From DHG
Where Booking_Date Like '%2015%'
And Cancelled = 1
And Lead_Time Between 0 and 182
Group by Status


--Specific Lead_time ranges associated with higher Revenue(after 93 days Lead_time from each range)

Select Lead_Time, Sum(Revenue) Revenue
From DHG
Where Booking_Date Like '%2015%'
And Lead_Time Between 0 and 93
Group by Lead_Time
Order by Lead_Time


--               ONLINE AND OFFLINE TRAVEL AGENTS COMPARISON

--Revenue contribution of Online TA compare to Offline TA

--Online travel agents
Select Distribution_Channel, Sum(Revenue) Revenue
From DHG
--Where Booking_Date Like '%2017%'
Group by Distribution_Channel
Having Distribution_Channel Like '%Online%'

--Offline travel agents
Select Distribution_Channel, Sum(Revenue) Revenue
From DHG
--Where Booking_Date Like '%2017%'
Group by Distribution_Channel
Having Distribution_Channel Like '%Offline%'


--How cancellation rates and Revenue vary between Bookings made through Online & Offline travel agents

--for Omline travel agents
Select Distribution_Channel, Count(Status) Cancellations, Sum(Revenue) Revenue
From DHG
Where Cancelled = 1
--And Booking_Date Like '%2015%'
Group by Distribution_Channel
Having Distribution_Channel Like '%Online%'


--for Offline travel agents
Select Distribution_Channel, Count(Status) Cancellations, Sum(Revenue) Revenue
From DHG
Where Cancelled = 1
--And Booking_Date Like '%2015%'
Group by Distribution_Channel
Having Distribution_Channel Like '%Offline%'