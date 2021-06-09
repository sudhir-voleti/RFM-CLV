## RFM builder func
get_rfm_df <- function(custID_ui=custID_ui, txnID_ui = txnID_ui,
                       txn_amount_ui=txn_amount_ui, txn_date_ui = txn_date_ui,
                       rfm_bins_num=rfm_bins_num){
  
  df1 = data.frame(custID_ui=custID_ui, txnID_ui = txnID_ui,
                   txn_amount_ui=txn_amount_ui, txn_date_ui = txn_date_ui)
  
  ## RFM calc
  df_RFM <- df1 %>% 
    group_by(custID_ui) %>% # all stuff below is by cust_ID
    
    summarise(
      recency = as.numeric(max(df1$txn_date_ui) - max(txn_date_ui)),
      freq = n_distinct(txnID_ui), 
      monetary= sum(txn_amount_ui)/n_distinct(txnID_ui)) %>% # 12.5s 
    # summary(df_RFM)
    rfm_table_customer(.,
                       customer_id = custID_ui,
                       n_transactions = freq, 
                       recency_days = recency,
                       total_revenue = monetary, 
                       recency_bins=rfm_bins_num, 
                       frequency_bins = rfm_bins_num, 
                       monetary_bins = rfm_bins_num)
  
  #df0_rfm = df_RFM$rfm
  return(df_RFM)
} # func ends


## CLV calc func
calc_clv <- function(data,
                     churn_thresh_ui = churn_thresh_ui,
                     discount_rate_ui=discount_rate_ui, 
                     profit_margin_ui=profit_margin_ui){
  
  y = rep(0, nrow(data)); y[1:4]
  a0 = data$recency_days %>% quantile(., probs = churn_thresh_ui); #a0
  a1 = (data$recency_days >= a0); #a1[1:4]
  y[a1] = 1; #y[1:8]
  
  df0 = data.frame(y=y, 
                   customer_id = data$customer_id,
                   R_value = data$recency_days,
                   F_value = data$transaction_count,
                   M_value = data$amount,
                   R_Score = data$recency_score,
                   F_Score = data$frequency_score,
                   M_Score = data$monetary_score)
  
  mylogit <- glm(y ~ F_value + M_value + factor(F_Score) + factor(M_Score), 
                 data = df0, family = "binomial")  # 0.2s!
  
  summary(mylogit) # can display if needed
  
  a2 = mylogit$fitted.values
  ret_rate = 1 - a2; # ret_rate[1:8]
  
  A = ret_rate / (1 + discount_rate_ui - ret_rate); #A[1:8]
  clv = df0$M_value * profit_margin_ui * A; #clv[1:8]
  #clv = round(clv,3)
  df1 = data.frame(df0, CLV=clv); print(head(df1))
  df1 <- df1 %>% mutate_if(is.numeric, round, digits=3)
  return(df1) # main output DF for CLV
} # func ends








