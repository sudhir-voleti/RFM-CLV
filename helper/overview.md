#### Overview Example Datasets

**RFM** is a method used for analyzing customer value. It is commonly used in database marketing and direct marketing and has received particular attention in retail and professional services industries.[[1]](https://en.wikipedia.org/wiki/RFM_(market_research)#cite_note-1)

RFM stands for the three dimensions:

- **R**ecency – *How recently did the customer purchase?*
- **F**requency – *How often do they purchase?*
- **M**onetary Value – *How much do they spend?*

Whereas, In marketing, **customer lifetime value** (**CLV** or often **CLTV**), **lifetime customer value** (**LCV**), or **life-time value** (**LTV**) is a prognostication of the net profit contributed to the whole future relationship with a customer. The prediction model can have varying levels of sophistication and accuracy, ranging from a crude heuristic to the use of complex predictive analytics techniques.[[2]](https://en.wikipedia.org/wiki/Customer_lifetime_value)

#### Example Dataset

App requires transaction data as input and must contain atleast following variables

- a `customerID` column
- a `txn_ID` column such as Invoice number etc.
- a `txn_amount` column
- a `txn_date` column 



------

#### How to use this App

1. Upload transaction data from sidebar panel
2. Go to Data Summary tab and select relevant customer id, transaction id, transaction date and transaction amount column.
3. After selecting the correct columns click on calculate RFM button and it will generate RFM scores for all uniquely identified customers.
4. CLV tab offers you to calculate the clv value of the customers based on RFM scores that we generated from RFM tab.
5. After tuning desired thresholds, click on calculate CLV button and it will calculate CLV for all the customers.



Both RFM and CLV tab offers you to download the scores in CSV format.

------

