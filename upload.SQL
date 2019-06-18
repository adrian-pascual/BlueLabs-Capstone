DROP TABLE IF EXISTS bl_pascuala.anes_16_final;

CREATE TABLE bl_pascuala.anes_16_final  (

id int	
,stratum int	
,variance int	
,state_fips	int
,weight	float
,party_id	int
,gender int
,aca_support int
,home_ownership	int
,age	int
,edu	int
,marital_status int	
,race	int
,delay_care	int
,cant_pay_bill int	
,pre_tot_income	int
,post_tot_income int	
,vote_12	int
,vote_16 int 
);

COPY bl_pascuala.anes_16_final
FROM LOCAL '/Users/adrianpascual/Desktop/ANES/anes_2016/anes_16_final.csv'
delimiter as ','
skip 1
;

GRANT SELECT ON bl_pascuala.anes_16_final to bl_modeler;


DROP TABLE IF EXISTS bl_pascuala.anes_12_final;

CREATE TABLE bl_pascuala.anes_12_final  (

id int	
,state_fips	int
,weight	float
,party_id	int
,gender int
,aca_support int
,age	int
,edu	int
,race	int
,delay_care	int
,cant_pay_bill int	
,pre_tot_income	int
,vote_12	int
,vote_08 int 
);

COPY bl_pascuala.anes_12_final
FROM LOCAL '/Users/adrianpascual/Desktop/ANES/anes_2012/anes_12_final.csv'
delimiter as ','
skip 1
;

GRANT SELECT ON bl_pascuala.anes_12_final to bl_modeler;
