{% test no_riders_over_120kg(model) %}

select id from {{ model }} where weight > 120 group by 1

{% endtest %}