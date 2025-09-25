{% test is_false(model) %}

select id
from {{ model }}
where false
group by 1

{% endtest %}