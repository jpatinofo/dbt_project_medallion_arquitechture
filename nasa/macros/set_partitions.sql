{% macro status_counters_by_partition(status_column, partition_by_columns) %}
    {% set statuses = ['FAULTY', 'KILLED', 'UNKNOWN', 'WARNING', 'GOOD', 'EXCELLENT'] %}
    {% set partition_clause = "PARTITION BY " ~ partition_by_columns | join(", ") %}
    {% for status in statuses %}
    SUM(CASE WHEN {{ status_column }} = '{{ status }}' THEN 1 ELSE 0 END)
    OVER ({{ partition_clause }}) AS total_{{ status | lower }},
    {% endfor %}
    COUNT(*) OVER ({{ partition_clause }}) AS total_events_mission
{% endmacro %}