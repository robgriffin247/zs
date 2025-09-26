{% test max_value(model, column_name, threshold) %}

select {{ column_name }} from {{ model }} where {{ column_name }} > {{ threshold }}

{% endtest %}