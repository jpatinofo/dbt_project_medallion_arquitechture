{% macro date_info(input_date) %}
    extract(YEAR FROM  {{ input_date }}) event_year,
    extract(MONTH FROM  {{ input_date }}) event_month,
    extract(DAY FROM   {{ input_date }}) event_day,
    extract(HOUR FROM  {{ input_date }}) event_hour,
    extract(MINUTE FROM  {{ input_date }}) event_minute,
    extract(SECOND FROM  {{ input_date }}) event_second,
    dayofweek({{ input_date }}) week_day,
    dayofyear({{ input_date }}) year_day,
    decade({{ input_date }}) decade_event,
    era({{ input_date }}) era_event,
    quarter({{ input_date }}) quarter_event,
    weekofyear({{ input_date }}) year_week,
    UPPER(strftime({{ input_date }}, '%A')) day_name,
    UPPER(strftime({{ input_date }}, '%B')) month_name,
    UPPER(strftime({{ input_date }}, '%p')) time_indicator,
    strftime({{ input_date }}, '%d/%m/%Y %H:%M:%S') AS format_event_date
{% endmacro %}