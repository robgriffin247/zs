{% test rider_is_over_100kg(model) %}

select id
from {{ model }}
where weight>100
group by 1

{% endtest %}