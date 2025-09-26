{% test no_riders_over_100kg_macro(model) %}

select id from {{ model }} where weight > 100 group by 1

{% endtest %}