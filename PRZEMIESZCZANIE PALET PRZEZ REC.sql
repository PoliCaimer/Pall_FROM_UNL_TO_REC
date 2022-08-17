--DATE: 23/07/2021
--ID: PRZEMIESZCZANIE PALET PRZEZ REC
--FREQUENCY: DAILY
--PURPOSE: DANE DLA KIEROWNIKA ROZŁADUNKÓW O ILOŚCI PRZEMIESZCZONYCH PALET PRZEZ JEGO PRACOWNIKÓW
--FROM: SU
--FOR: DC310
--AUTHOR: AADDE
--REPORT: NO
--ORIGINAL FROM:

SELECT 
logguser,
COUNT(ecarrno) "_  Ilosc palet",
round(sum(l16vol/1000),1) "_Cbm"

FROM
(
    SELECT

    CASE 
    WHEN (mha = 'CBID' or mha = '26CB1') then 1  
    WHEN emha = ' ' then 1 
    WHEN substr(mha,1,3) = substr(mha,1,3) then 1 
    END as new,
    l16t3.*
    
    FROM
    l16t3

    WHERE
    datreg between @('from', #DATETIME) and @('TO', #DATETIME)
    and fmha in 
        (
            SELECT 
            member 
            
            FROM w08t1 
            
            WHERE w08t1.ma_group in ('118','388', '387', '386',' 384', '382','381' , '128','129','138','248','258', '258TR','259','268','269','382','384','386','387','388')
        )
    and fmha not in ('444A','555A','666A','25Q1','25Q2','25Q3','25MAN')
    and 
    (
        mha in 
        (
            SELECT 
            member 
                
            FROM w08t1 
                
            WHERE w08t1.ma_group  in  ('118','388', '387', '386',' 384', '382','381' , '128','129','138','248','258', '258TR','259','268','269','382','384','386','387','388')
        )
        or mha in ('CBID','26CB1')
    )
    and substr(fmha,1,3) != substr(mha,1,3) 
    and l16lcode = '3'
    and l46adr not like( '-%')
    and logguser not like ('L79%')
    and L16T3.logguser in 
    ( 
        SELECT 
        uname 
        
        FROM 
        ASTRO_VIEW_TBL_S90X3 
        
        WHERE 
        ASTRO_VIEW_TBL_S90X3.dep='WAREHOUSE REC'
    )

    ORDER BY
    1,2

) 

WHERE 
NEW = 1

GROUP BY
logguser