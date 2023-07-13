select
    case
        when a = 1 then '1'
        when a = 2 then '2'
        when a = 3 then '3'
        else '0'
    end as stmt1
from tab;
